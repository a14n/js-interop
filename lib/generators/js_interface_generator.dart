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
    if (element is ClassElement) {
      if (element.unit.element.name.endsWith('.g.dart')) return null;

      final jsInterfaceClass = getType(element.library, 'js', 'JsInterface');
      if (!element.type.isSubtypeOf(jsInterfaceClass.type)) return null;

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
    final newClassName = getNewClassName(clazz);

    // add implements to make analyzer happy
    if (clazz.node.implementsClause == null) {
      transformer.insertAt(
          clazz.node.leftBracket.offset, ' implements ${clazz.displayName}');
    } else {
      var interfaceCount = clazz.node.implementsClause.interfaces.length;
      // remove implement JsInterface
      clazz.node.implementsClause.interfaces
          .where((e) => e.name.name == 'JsInterface')
          .forEach((e) {
        interfaceCount--;
        if (clazz.node.implementsClause.interfaces.length == 1) {
          transformer.removeNode(e);
        } else {
          final index = clazz.node.implementsClause.interfaces.indexOf(e);
          int begin, end;
          if (index == 0) {
            begin = e.offset;
            end = clazz.node.implementsClause.interfaces[1].offset;
          } else {
            begin = clazz.node.implementsClause.interfaces[index - 1].end;
            end = e.end;
          }
          transformer.removeBetween(begin, end);
        }
      });

      transformer.insertAt(clazz.node.implementsClause.end,
          (interfaceCount > 0 ? ', ' : '') + clazz.displayName);
    }

    // add JsInterface extension
    if (clazz.node.extendsClause == null) {
      transformer.insertAt(clazz.node.name.end, ' extends JsInterface');
    }

    // remove abstract
    transformer.removeToken(clazz.node.abstractKeyword);

    // rename class
    transformer.replace(
        clazz.node.name.offset, clazz.node.name.end, newClassName);

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
          final parameterList =
              constr.parameters.map((p) => p.displayName).join(', ');
          newJsObject += ", [$parameterList].map(toJs).toList()";
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
          ? clazz.node.leftBracket.end
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
        final parameterList = m.parameters.map((p) => p.displayName).join(', ');
        call += ", [$parameterList].map(toJs).toList()";
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

    final nameOfClass = getNameAnnotation(clazz.node, jsNameClass);
    if (nameOfClass != null) {
      name += nameOfClass;
    } else if (useClassName) {
      name += getNewClassName(clazz);
    } else if (name.endsWith('.')) {
      name = name.substring(0, name.length - 1);
    }
    return name;
  }

  static String getNewClassName(ClassElement clazz) =>
      clazz.displayName.substring(1);

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
      } else if (isListType(type)) {
        final typeParam = (type as InterfaceType).typeArguments.first;
        if (isJsInterfaceType(typeParam)) {
          var output = '''
((e) {
  if (e == null) return null;
  return new JsList.created(e,
      new JsInterfaceCodec((o) => new $typeParam.created(o)));
})($content)''';
          return output;
        } else {
          return "$content as JsArray";
        }
      }
    }
    return content;
  }

  String toJs(DartType type, String content) {
    if (type.isDynamic) {
      return 'toJs($content)';
    } else if (isJsInterfaceType(type)) {
      return '((e) => e == null ? null : asJsObject(e))($content)';
    } else if (isListType(type)) {
      final typeParam = (type as InterfaceType).typeArguments.first;
      return '''
((e) {
  if (e == null) return null;
  if (e is JsInterface) return asJsObject(e);
  return new JsArray.from(${isTypeTransferable(typeParam) ? 'e' : 'e.map(toJs)'});
})($content)''';
    } else {
      return content;
    }
  }

  bool isJsInterfaceType(DartType type) => !type.isDynamic &&
      type.isSubtypeOf(getType(lib, 'js', 'JsInterface').type);

  bool isListType(DartType type) => type.isSubtypeOf(
      getType(lib, 'dart.core', 'List').type
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
