// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library js.generator.js_interface;

import 'dart:async';

import 'package:analyzer/analyzer.dart';
import 'package:analyzer/src/generated/ast.dart';
import 'package:analyzer/src/generated/element.dart';

import 'package:source_gen/source_gen.dart';

import 'util.dart';

class JsInterfaceGenerator extends Generator {
  const JsInterfaceGenerator();

  Future<String> generate(Element element) async {
    // JsInterface
    final jsInterfaceClass = getType(element.library, 'js', 'JsInterface');
    if (element is ClassElement &&
        element.type.isSubtypeOf(jsInterfaceClass.type)) {
      if (element.unit.element.name.endsWith('.g.dart')) return null;
      if (!element.isPrivate) throw '$element must be private';
      return new JsInterfaceClassGenerator(element).generate();
    }

    return null;
  }
}

class JsInterfaceClassGenerator {
  final LibraryElement lib;
  final ClassElement clazz;
  final transformer = new Transformer();

  ClassElement _jsNameClass;

  JsInterfaceClassGenerator(ClassElement clazz)
      : lib = clazz.library,
        clazz = clazz {
    _jsNameClass = getType(lib, 'js', 'JsName');
  }

  String generate() {
    final newClassName = getPublicClassName(clazz);

    final ClassDeclaration classNode = clazz.node;

    // add implements to make analyzer happy
    if (classNode.implementsClause == null) {
      transformer.insertAt(
          classNode.leftBracket.offset, ' implements ${clazz.displayName}');
    } else {
      var interfaceCount = classNode.implementsClause.interfaces.length;
      // remove implement JsInterface
      classNode.implementsClause.interfaces
          .where((e) => e.name.name == 'JsInterface')
          .forEach((e) {
        interfaceCount--;
        if (classNode.implementsClause.interfaces.length == 1) {
          transformer.removeNode(e);
        } else {
          final index = classNode.implementsClause.interfaces.indexOf(e);
          int begin, end;
          if (index == 0) {
            begin = e.offset;
            end = classNode.implementsClause.interfaces[1].offset;
          } else {
            begin = classNode.implementsClause.interfaces[index - 1].end;
            end = e.end;
          }
          transformer.removeBetween(begin, end);
        }
      });

      transformer.insertAt(classNode.implementsClause.end,
          (interfaceCount > 0 ? ', ' : '') + clazz.displayName);
    }

    // add JsInterface extension
    if (classNode.extendsClause == null) {
      transformer.insertAt(classNode.name.end, ' extends JsInterface');
    }

    // remove abstract
    transformer.removeToken(classNode.abstractKeyword);

    // rename class
    transformer.replace(
        classNode.name.offset, classNode.name.end, newClassName);

    // generate constructors
    for (final constr in clazz.constructors) {
      if (constr.isSynthetic) continue;

      // rename
      transformer.replace(constr.node.returnType.offset,
          constr.node.returnType.end, newClassName);

      // generate only external factory constructor
      if (!constr.isFactory ||
          constr.node.externalKeyword == null ||
          constr.node.initializers.isNotEmpty) {
        continue;
      }

      var newJsObject = "new JsObject(";
      if (anonymousAnnotations.isNotEmpty) {
        if (constr.parameters.isNotEmpty) {
          throw '@anonymous JsInterface can not have constructor with '
              'parameters';
        }
        newJsObject += "context['Object']";
      } else {
        final jsName = computeJsName(clazz, _jsNameClass, true);
        newJsObject += "getPath('$jsName')";
        if (constr.parameters.isNotEmpty) {
          final parameterList = constr.parameters
              .map((p) => toJs(p.type, p.displayName))
              .join(', ');
          newJsObject += ", [$parameterList]";
        }
      }
      newJsObject += ")";

      transformer.removeToken(constr.node.factoryKeyword);
      transformer.removeToken(constr.node.externalKeyword);
      transformer.insertAt(
          constr.node.end - 1, " : this.created($newJsObject)");
    }

    // generate the constructor .created
    if (!clazz.constructors.any((e) => e.name == 'created')) {
      final insertionIndex = clazz.constructors
              .where((e) => !e.isSynthetic).isEmpty
          ? classNode.leftBracket.end
          : clazz.constructors.first.node.offset;
      transformer.insertAt(insertionIndex,
          '$newClassName.created(JsObject o) : super.created(o);\n');
    }

    // generate properties
    transformAbstractAccessors(
        clazz.accessors.where((e) => !e.isStatic).where((e) => e.isAbstract));

    transformInstanceVariables(clazz.accessors
        .where((e) => !e.isStatic)
        .where((e) => e.isSynthetic)
        .where((e) => e.variable.initializer == null));

    // generate abstract methods
    clazz.methods.where((e) => !e.isStatic && e.isAbstract).forEach((m) {
      final jsName = getNameAnnotation(m.node, _jsNameClass);
      final name = jsName != null
          ? jsName
          : m.isPrivate ? m.displayName.substring(1) : m.displayName;
      var call = "asJsObject(this).callMethod('$name'";
      if (m.parameters.isNotEmpty) {
        final parameterList =
            m.parameters.map((p) => toJs(p.type, p.displayName)).join(', ');
        call += ", [$parameterList]";
      }
      call += ")";

      if (m.returnType.isVoid) {
        transformer.replace(m.node.end - 1, m.node.end, "{ $call; }");
      } else {
        transformer.insertAt(
            m.node.end - 1, " => ${toDart(m.returnType, call)}");
      }

      getAnnotations(m.node, _jsNameClass).forEach(transformer.removeNode);
    });

    return transformer.applyOn(clazz);
  }

  Iterable<Annotation> get anonymousAnnotations => clazz.node.metadata
      .where((a) {
    var e = a.element;
    return e.library.name == 'js' && e.name == 'anonymous';
  });

  void removeAnonymousAnnotation() {
    anonymousAnnotations.forEach(transformer.removeNode);
  }

  void transformAbstractAccessors(Iterable<PropertyAccessorElement> accessors) {
    accessors.forEach((accessor) {
      final jsName = getNameAnnotation(accessor.node, _jsNameClass);
      final name = jsName != null
          ? jsName
          : accessor.isPrivate
              ? accessor.displayName.substring(1)
              : accessor.displayName;
      String newFuncDecl;
      if (accessor.isGetter) {
        final getterBody = createGetterBody(accessor.returnType, name);
        newFuncDecl = " => $getterBody";
      } else if (accessor.isSetter) {
        final setterBody =
            createSetterBody(accessor.parameters.first, jsName: name);
        newFuncDecl = " { $setterBody }";
      }
      transformer.replace(
          accessor.node.end - 1, accessor.node.end, newFuncDecl);

      getAnnotations(accessor.node, _jsNameClass)
          .forEach(transformer.removeNode);
    });
  }

  void transformInstanceVariables(Iterable<PropertyAccessorElement> accessors) {
    accessors.forEach((accessor) {
      final VariableDeclarationList varDeclList = accessor.variable.node.parent;
      var jsName = getNameAnnotation(accessor.variable.node, _jsNameClass);
      jsName = jsName != null
          ? jsName
          : getNameAnnotation(varDeclList.parent, _jsNameClass);
      jsName = jsName != null
          ? jsName
          : accessor.isPrivate
              ? accessor.displayName.substring(1)
              : accessor.displayName;
      var name = accessor.displayName;

      var code;
      if (accessor.isGetter) {
        final getterBody = createGetterBody(accessor.returnType, jsName);
        code = "${varDeclList.type} get $name => $getterBody";
      } else if (accessor.isSetter) {
        final param = accessor.parameters.first;
        final setterBody = createSetterBody(param, jsName: jsName);
        code = accessor.returnType.displayName +
            " set $name(${varDeclList.type} ${param.displayName})"
            "{ $setterBody }";
      }
      transformer.insertAt(varDeclList.end + 1, code);
    });

    // remove variable declarations
    final Set<VariableDeclaration> variables =
        accessors.map((e) => e.variable.node).toSet();
    final Set<VariableDeclarationList> varDeclLists =
        variables.map((e) => e.parent).toSet();
    varDeclLists.forEach((varDeclList) {
      transformer.removeNode(varDeclList.parent);
    });
  }

  static String computeJsName(
      ClassElement clazz, ClassElement jsNameClass, bool useClassName) {
    var name = "";

    final nameOfLib =
        getNameAnnotation(clazz.library.unit.directives.first, jsNameClass);
    if (nameOfLib != null) name += nameOfLib + '.';

    final nameOfClass = getNameAnnotation(getClassNode(clazz), jsNameClass);
    if (nameOfClass != null) {
      name += nameOfClass;
    } else if (useClassName) {
      name += getPublicClassName(clazz);
    } else if (name.endsWith('.')) {
      name = name.substring(0, name.length - 1);
    }
    return name;
  }

  // workaround issue 23071
  static AnnotatedNode getClassNode(ClassElement clazz) {
    if (!clazz.isEnum) return clazz.node;
    return clazz.library.units.expand((u) => u.node.declarations
        .where((d) => d is EnumDeclaration && d.name.name == clazz.name)).first;
  }

  static String getPublicClassName(ClassElement clazz) =>
      clazz.isPrivate ? clazz.displayName.substring(1) : clazz.displayName;

  String createGetterBody(DartType type, String name,
      {String target: "asJsObject(this)"}) {
    return toDart(type, "$target['$name']") + ';';
  }

  String createSetterBody(ParameterElement param,
      {String target: "asJsObject(this)", String jsName}) {
    final name = param.displayName;
    final type = param.type;
    jsName = jsName != null ? jsName : name;
    return "$target['$jsName'] = " + toJs(type, name) + ';';
  }

  String toDart(DartType type, String content) {
    if (!type.isDynamic) {
      if (type.isSubtypeOf(getType(lib, 'js', 'JsInterface').type)) {
        return '((e) => e == null ? null : new $type.created(e))($content)';
      } else if (isJsEnum(type)) {
        final values = getEnumValues(type.element);
        final jsPath =
            computeJsName(type.element, getType(lib, 'js', 'JsName'), true);
        return '''
((e) {
  if (e == null) return null;
  final path = getPath('$jsPath');
  ${values.map((e) => "if (e == path['${getRealEnumNameValue(type, e)}']) return $type.$e;").join('\n')}
})($content)''';
      } else if (isListType(type)) {
        final typeParam = (type as InterfaceType).typeArguments.first;
        final codec = getCodec(typeParam);
        if (codec != null) {
          return '''
((e) {
  if (e == null) return null;
  return new JsList<$typeParam>.created(e, $codec);
})($content)''';
        } else {
          return "$content as JsArray";
        }
      } else if (type is FunctionType) {
        final returnCodec = getCodec(type.returnType);
        var paramChanges = '';
        type.parameters.forEach((p) {
          final codec = getCodec(p.type);
          if (codec != null) {
            paramChanges += 'p_${p.name} = $codec.encode(p_${p.name});';
          }
        });
        var call =
            'f.apply([${type.parameters.map((p) => 'p_' + p.name).join(', ')}])';
        if (returnCodec != null) {
          call = 'final result = $call; return $returnCodec.decode(result);';
        } else if (!type.returnType.isVoid) {
          call = 'return $call;';
        } else {
          call = '$call;';
        }
        return '''
((JsFunction f) {
  if (f == null) return null;
  return (${type.parameters.map((p) => 'p_' + p.name).join(', ')}) {
    $paramChanges
    $call
  };
})($content)''';
      }
    }
    return content;
  }

  String getCodec(DartType type) {
    if (isJsInterfaceType(type)) {
      return 'new JsInterfaceCodec<$type>((o) => ${toDart(type, 'o')})';
    } else if (isListType(type)) {
      final typeParam = (type as InterfaceType).typeArguments.first;
      return 'new JsListCodec<$typeParam>(${getCodec(typeParam)})';
    } else if (isJsEnum(type)) {
      final values = getEnumValues(type.element);
      final jsPath =
          computeJsName(type.element, getType(lib, 'js', 'JsName'), true);
      final mapContent = values
          .map((e) =>
              "$type.$e: getPath('$jsPath')['${getRealEnumNameValue(type, e)}']")
          .join(',');
      return 'new BiMapCodec<$type, dynamic>({$mapContent})';
    } else if (type is FunctionType) {
      // TODO(aa) type for Function can be "int -> String" : create typedef
      return 'new FunctionCodec/*<$type>*/((o) => ${toJs(type, 'o')}, (o) => ${toDart(type, 'o')})';
    }
    return null;
  }

  String getRealEnumNameValue(DartType type, String enumName) {
    final a = getAnnotations(
        getClassNode(type.element), getType(lib, 'js', 'JsEnum')).single;
    if (a.arguments.arguments.length == 1) {
      var param = a.arguments.arguments.first;
      if (param is NamedExpression &&
          param.name.label.name == "names" &&
          param.expression is MapLiteral) {
        for (final e in param.expression.entries) {
          if (e.key.toString() == '$type.$enumName') {
            return (e.value as StringLiteral).stringValue;
          }
        }
      }
    }
    return enumName;
  }

  Iterable<String> getEnumValues(ClassElement element) {
    EnumDeclaration enumDecl = getClassNode(element);
    return enumDecl.constants.map((e) => e.name.name);
  }

  String toJs(DartType type, String content) {
    if (type.isDynamic) {
      return 'toJs($content)';
    } else if (isJsInterfaceType(type)) {
      return '((e) => e == null ? null : asJsObject(e))($content)';
    } else if (isJsEnum(type)) {
      final values = getEnumValues(type.element);
      final jsPath =
          computeJsName(type.element, getType(lib, 'js', 'JsName'), true);
      return '''
((e) {
  if (e == null) return null;
  final path = getPath('$jsPath');
  ${values.map((e) => "if (e == $type.$e) return path['${getRealEnumNameValue(type, e)}'];").join('\n')}
})($content)''';
    } else if (isListType(type)) {
      final typeParam = (type as InterfaceType).typeArguments.first;
      return '''
((e) {
  if (e == null) return null;
  if (e is JsInterface) return asJsObject(e);
  return new JsArray.from(${isTypeTransferable(typeParam) ? 'e' : 'e.map(toJs)'});
})($content)''';
    } else if (type is FunctionType) {
      final returnCodec = getCodec(type.returnType);
      final paramCodecs = type.parameters.map((p) => p.type).map(getCodec);
      if (returnCodec == null && paramCodecs.every((c) => c == null)) {
        return content;
      } else {
        var paramChanges = '';
        type.parameters.forEach((p) {
          final codec = getCodec(p.type);
          if (codec != null) {
            paramChanges += 'p_${p.name} = $codec.decode(p_${p.name});';
          }
        });
        var call = 'f(${type.parameters.map((p) => 'p_' + p.name).join(', ')})';
        if (returnCodec != null) {
          call = 'final result = $call; return $returnCodec.encode(result);';
        } else if (!type.returnType.isVoid) {
          call = 'return $call;';
        } else {
          call = '$call;';
        }
        return '''
((f) {
  if (f == null) return null;
  return (${type.parameters.map((p) => 'p_' + p.name).join(', ')}) {
    $paramChanges
    $call
  };
})($content)''';
      }
    } else if (isTypeTransferable(type)) {
      return content;
    }
    return 'toJs($content)';
  }

  bool isJsEnum(DartType type) {
    final element = type.element;
    if (element is! ClassElement) return false;
    if (!element.isEnum) return false;
    return getAnnotations(
        getClassNode(element), getType(lib, 'js', 'JsEnum')).isNotEmpty;
  }

  bool isJsInterfaceType(DartType type) => !type.isDynamic &&
      type.isSubtypeOf(getType(lib, 'js', 'JsInterface').type);

  bool isListType(DartType type) => !type.isDynamic &&
      type.isSubtypeOf(getType(lib, 'dart.core', 'List').type
          .substitute4([DynamicTypeImpl.instance]));

  /// return [true] if the type is transferable through dart:js
  /// (see https://api.dartlang.org/docs/channels/stable/latest/dart_js.html)
  bool isTypeTransferable(DartType type) {
    final transferables = const <String, List<String>>{
      'dart.js': const ['JsObject'],
      'dart.core': const ['num', 'bool', 'String', 'DateTime'],
      'dart.dom.html': const ['Blob', 'Event', 'ImageData', 'Node', 'Window'],
      'dart.dom.indexed_db': const ['KeyRange'],
      'dart.typed_data': const ['TypedData'],
    };
    for (final libName in transferables.keys) {
      if (getLib(lib, libName) == null) continue;
      if (transferables[libName].any((className) =>
          type.isSubtypeOf(getType(lib, libName, className).type))) {
        return true;
      }
    }
    return false;
  }
}

String getNameAnnotation(AnnotatedNode node, ClassElement jsNameClass) {
  final jsNames = getAnnotations(node, jsNameClass);
  if (jsNames.isEmpty) return null;
  final a = jsNames.single;
  if (a.arguments.arguments.length == 1) {
    var param = a.arguments.arguments.first;
    if (param is StringLiteral) {
      return param.stringValue;
    }
  }
  return null;
}
