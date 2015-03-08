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
    if (element is LibraryElement) {
      return new InitializeJavascriptGenerator(element).generate();
    }

    if (element is ClassElement) {
      final libElement = element.library;
      final jsMetadataLib = libElement.visibleLibraries.firstWhere(
          (l) => l.name == 'js.metadata', orElse: () => null);

      if (jsMetadataLib == null) return null;

      final jsProxyClass = jsMetadataLib.getType('JsProxy');
      final annotation = getProxyAnnotation(element, jsProxyClass);

      if (annotation == null) return null;

      if (!element.isPrivate) throw '$element must be private';

      return new JsProxyClassGenerator(element, annotation).generate();
    }

    return null;
  }
}

class InitializeJavascriptGenerator {
  LibraryElement libElement;

  InitializeJavascriptGenerator(this.libElement);

  String generate() {
    final jsMetadataLib = libElement.visibleLibraries.firstWhere(
        (l) => l.name == 'js.metadata', orElse: () => null);

    if (jsMetadataLib == null) return null;

    var jsProxyClass = jsMetadataLib.getType('JsProxy');
    var jsNameClass = jsMetadataLib.getType('JsName');

    var proxies = libElement.units
        .expand((e) => e.types)
        .where((ClassElement e) =>
            e.metadata.any((md) => isAnnotationOfType(md, jsProxyClass)));

    if (proxies.isEmpty) return null;

    var ouput = '''
void initializeJavaScript({List<String> exclude, List<String> include}) {
  bool accept(String name) => (include != null && include.contains(name)) ||
      (include == null && exclude != null && !exclude.contains(name));

  void register(String name, JsInterface f(JsObject o)) =>
      registerFactoryForJsConstructor(getPath(name), f);

  void mayRegister(String name, JsInterface f(JsObject o)) {
      if(accept(name))register(name, f);
  }

''';
    for (ClassElement clazz in proxies) {
      final name = JsProxyClassGenerator.getNewClassName(clazz);
      final jsProxy = getProxyAnnotation(clazz, jsProxyClass);

      if (jsProxy.anonymousObject) continue;

      final constructor = JsProxyClassGenerator.getJsProxyConstructor(
          clazz, jsNameClass, jsProxy);
      ouput += "mayRegister('$constructor', (o) => new $name.created(o));";
    }
    ouput += '}';
    return ouput;
  }
}

class JsProxyClassGenerator {
  final ClassElement clazz;
  final JsProxy annotation;
  final transformer = new Transformer();

  ClassElement _jsProxyClass, _jsNameClass;

  JsProxyClassGenerator(this.clazz, this.annotation) {
    _jsProxyClass = getType(clazz, 'js.metadata', 'JsProxy');
    _jsNameClass = getType(clazz, 'js.metadata', 'JsName');
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
    clazz.node.metadata
        .where((e) => isAnnotationOfType(e.elementAnnotation, _jsProxyClass))
        .forEach((e) => transformer.removeNode(e));

    // remove abstract
    transformer.removeToken(clazz.node.abstractKeyword);

    // rename class
    transformer.replace(
        clazz.node.name.offset, clazz.node.name.end, newClassName);

    // generate constructors
    final jsConstructor = annotation.anonymousObject
        ? 'Object'
        : getJsProxyConstructor(clazz, _jsNameClass, annotation);
    for (final constr in clazz.constructors) {
      // check that there are only factory constructors that redirect to dynamic
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

      var newJsObject = "new JsObject(getPath('$jsConstructor')";
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

    transformInstanceVariables(transformer, clazz.accessors
        .where((e) => !e.isStatic)
        .where((e) => e.isSynthetic)
        .where((e) => e.variable.initializer == null));

    // generate abstract methods
    clazz.methods.where((e) => !e.isStatic).forEach((m) {
      var call = "unwrap(this).callMethod('${m.displayName}'";
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
    });

    return transformer.applyOn(clazz);
  }

  void transformAbstractAccessors(
      Transformer transformer, Iterable<PropertyAccessorElement> accessors) {
    accessors.forEach((accessor) {
      final name = accessor.isPrivate
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
    });
  }

  void transformInstanceVariables(
      Transformer transformer, Iterable<PropertyAccessorElement> accessors) {
    accessors.forEach((accessor) {
      final name = accessor.isPrivate
          ? accessor.displayName.substring(1)
          : accessor.displayName;
      var code;
      if (accessor.isGetter) {
        final getterBody = createGetterBody(accessor.returnType, name);
        code = "${accessor.returnType.displayName} get $name => $getterBody";
      } else if (accessor.isSetter) {
        final param = accessor.parameters.first;
        final setterBody = createSetterBody(param, jsName: name);
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
      if (varDeclList.variables.every((e) => variables.contains(e))) {
        transformer.removeNode(varDeclList.parent);
      } else {
        throw "Please don't mix variables initialized and uninitialized,"
            " it's really a pain to handle :p";
      }
    });
  }

  static String getJsProxyConstructor(
      ClassElement clazz, ClassElement jsNameClass, JsProxy jsProxyAnnotation) {
    var jsConstructor = "";
    final namespace =
        getNameAnnotation(clazz.library.unit.directives.first, jsNameClass);
    if (namespace != null) jsConstructor += namespace.name + '.';
    if (jsProxyAnnotation.constructor != null) {
      jsConstructor += jsProxyAnnotation.constructor;
    } else {
      jsConstructor += getNewClassName(clazz);
    }
    return jsConstructor;
  }

  static String getNewClassName(ClassElement clazz) =>
      clazz.displayName.substring(1);
}

String createGetterBody(DartType type, String name,
    {String target: "unwrap(this)"}) {
  return toDart(type, "$target['$name']") + ';';
}

String createSetterBody(ParameterElement param,
    {String target: "unwrap(this)", String jsName}) {
  final name = param.displayName;
  final type = param.type;
  jsName = jsName != null ? jsName : name;
  return "$target['$jsName'] = " + toJs(type, name) + ';';
}

String toDart(DartType type, String content) {
  return "toDart($content) as $type";
}

String toJs(DartType type, String content) => "toJs($content)";
