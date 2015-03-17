library js.generator.js_proxy;

import 'dart:async';

import 'package:analyzer/analyzer.dart';
import 'package:analyzer/src/generated/ast.dart';
import 'package:analyzer/src/generated/element.dart';

import 'package:source_gen/source_gen.dart';

import '../src/metadata.dart';
import 'util.dart';

class JsProxyGenerator extends Generator {
  const JsProxyGenerator();

  Future<String> generate(Element element) async {
    if (element is ClassElement) {
      final jsProxyClass = getType(element.library, 'js.metadata', 'JsProxy');
      final annotation = getProxyAnnotation(element.node, jsProxyClass);

      if (annotation == null) return null;

      if (!element.isPrivate) throw '$element must be private';

      return new JsProxyClassGenerator(element, annotation).generate();
    }

    return null;
  }
}

class JsProxyClassGenerator {
  final LibraryElement lib;
  final ClassElement clazz;
  final JsProxy annotation;
  final transformer = new Transformer();

  ClassElement _jsProxyClass, _jsNameClass;

  JsProxyClassGenerator(ClassElement clazz, this.annotation)
      : lib = clazz.library,
        clazz = clazz {
    _jsProxyClass = getType(lib, 'js.metadata', 'JsProxy');
    _jsNameClass = getType(lib, 'js.metadata', 'JsName');
  }

  String generate() {
    final newClassName = getNewClassName(clazz);

    // add implements to make analyzer happy
    if (clazz.node.implementsClause == null) {
      transformer.insertAt(
          clazz.node.leftBracket.offset, ' implements ${clazz.displayName}');
    } else {
      transformer.insertAt(
          clazz.node.implementsClause.end, ', ${clazz.displayName}');
    }

    // add JsInterface extension
    if (clazz.node.extendsClause == null) {
      transformer.insertAt(clazz.node.name.end, ' extends JsInterface');
    }

    // remove JsProxy annotation
    getAnnotations(clazz.node, _jsProxyClass).forEach(transformer.removeNode);

    // remove JsName annotation
    getAnnotations(clazz.node, _jsNameClass).forEach(transformer.removeNode);

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

      // generate only factory redirected constructor for dynamic
      if (!constr.isFactory ||
          constr.node.redirectedConstructor == null ||
          constr.node.redirectedConstructor.type.name.name != 'dynamic') {
        continue;
      }

      final jsName = computeJsName(clazz, _jsNameClass, true);
      var newJsObject = "new JsObject(getPath('$jsName')";
      if (constr.parameters.isNotEmpty) {
        final parameterList =
            constr.parameters.map((p) => p.displayName).join(', ');
        newJsObject += ", [$parameterList].map(toJs).toList()";
      }
      newJsObject += ")";
      transformer.removeToken(constr.node.factoryKeyword);
      transformer.removeToken(constr.node.separator);
      transformer.removeNode(constr.node.redirectedConstructor);
      transformer.insertAt(
          constr.node.end - 1, " : this.created($newJsObject)");
    }

    // generate the default constructor for global and anonymous
    if ((annotation.kind == Kind.ANONYMOUS || annotation.kind == Kind.GLOBAL) &&
        clazz.constructors.any((e) => e.isSynthetic)) {
      final insertionIndex = clazz.constructors
              .where((e) => !e.isSynthetic).isEmpty
          ? clazz.node.leftBracket.end
          : clazz.constructors.first.node.offset;
      var jsObject;
      if (annotation.kind == Kind.GLOBAL) {
        final jsName = computeJsName(clazz, _jsNameClass, false);
        jsObject = "getPath('$jsName')";
      } else if (annotation.kind == Kind.ANONYMOUS) {
        jsObject = "context['Object']";
      }
      transformer.insertAt(
          insertionIndex, "$newClassName() : this.created($jsObject);\n");
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
    transformAbstractAccessors(transformer,
        clazz.accessors.where((e) => !e.isStatic).where((e) => e.isAbstract));

    transformInstanceVariables(lib, transformer, clazz.accessors
        .where((e) => !e.isStatic)
        .where((e) => e.isSynthetic)
        .where((e) => e.variable.initializer == null));

    // generate abstract methods
    clazz.methods.where((e) => !e.isStatic).forEach((m) {
      final jsName = getNameAnnotation(m.node, _jsNameClass);
      final name = jsName != null ? jsName.name : m.displayName;
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

  void transformAbstractAccessors(
      Transformer transformer, Iterable<PropertyAccessorElement> accessors) {
    accessors.forEach((accessor) {
      final jsName = getNameAnnotation(accessor.node, _jsNameClass);
      final name = jsName != null
          ? jsName.name
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

  void transformInstanceVariables(LibraryElement lib, Transformer transformer,
      Iterable<PropertyAccessorElement> accessors) {
    accessors.forEach((accessor) {
      var jsName = getNameAnnotation(accessor.variable.node, _jsNameClass);
      jsName = jsName != null
          ? jsName
          : getNameAnnotation(
              accessor.variable.node.parent.parent, _jsNameClass);
      jsName = jsName != null
          ? jsName.name
          : accessor.isPrivate
              ? accessor.displayName.substring(1)
              : accessor.displayName;
      var name = accessor.displayName;

      var code;
      if (accessor.isGetter) {
        final getterBody = createGetterBody(accessor.returnType, jsName);
        code = "${accessor.returnType.displayName} get $name => $getterBody";
      } else if (accessor.isSetter) {
        final param = accessor.parameters.first;
        final setterBody = createSetterBody(param, jsName: jsName);
        code = accessor.returnType.displayName +
            " set $name(${param.type.displayName} ${param.displayName})"
            "{ $setterBody }";
      }
      VariableDeclarationList varDeclList = accessor.variable.node.parent;
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
    if (nameOfLib != null) name += nameOfLib.name + '.';

    final nameOfClass = getNameAnnotation(clazz.node, jsNameClass);
    if (nameOfClass != null) {
      name += nameOfClass.name;
    } else if (useClassName) {
      name += getNewClassName(clazz);
    } else if (name.endsWith('.')){
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
      if (type.isSubtypeOf(getType(lib, 'js.impl', 'JsInterface').type)) {
        return '((e) => e == null ? null : new $type.created(e))($content)';
      }
    }
    return content;
  }

  String toJs(DartType type, String content) {
    if (!type.isDynamic) {
      if (type.isSubtypeOf(getType(lib, 'js.impl', 'JsInterface').type)) {
        return '((e) => e == null ? null : asJsObject(e))($content)';
      }
    }
    return content;
  }

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
      if (transferables[libName].any((className) =>
          type.isSubtypeOf(getType(lib, libName, className).type))) {
        return true;
      }
    }
    return false;
  }
}

JsProxy getProxyAnnotation(AnnotatedNode node, ClassElement jsProxyClass) {
  final jsNames = getAnnotations(node, jsProxyClass);
  if (jsNames.isEmpty) return null;
  final a = jsNames.single;

  ConstructorElement e = a.element;
  if (e.isDefaultConstructor) {
    return new JsProxy();
  } else if (e.name == 'anonymous') {
    return new JsProxy.anonymous();
  } else if (e.name == 'global') {
    return new JsProxy.global();
  }

  return null;
}

JsName getNameAnnotation(AnnotatedNode node, ClassElement jsNameClass) {
  final jsNames = getAnnotations(node, jsNameClass);
  if (jsNames.isEmpty) return null;
  final a = jsNames.single;
  if (a.arguments.arguments.length == 1) {
    var param = a.arguments.arguments.first;
    if (param is StringLiteral) {
      return new JsName(param.stringValue);
    }
  }
  return null;
}
