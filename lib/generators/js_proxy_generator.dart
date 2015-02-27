library js.generator.js_proxy;

import 'dart:async';

import 'package:analyzer/analyzer.dart';
import 'package:analyzer/src/generated/ast.dart';
import 'package:analyzer/src/generated/element.dart';
import 'package:analyzer/src/generated/scanner.dart';

import 'package:source_gen/source_gen.dart';

import '../src/metadata.dart';
import 'util.dart';

class JsProxyGenerator extends GeneratorForAnnotation<JsProxy> {
  const JsProxyGenerator();

  Future<String> generateForAnnotatedElement(
      Element element, JsProxy annotation) async {
    if (!element.isPrivate) throw '$element must be private';

    if (element is ClassElement) {
      return new JsProxyClassGenerator(element, annotation).generate();
    }

    // top level
    if (element.enclosingElement is CompilationUnitElement) {
      if (element is FunctionElement) {
        return generateForFunction(element);
      }

      if (element is TopLevelVariableElement) {
        return generateForTopLevelVariable(element);
      }

      if (element is PropertyAccessorElement) {
        return generateForPropertyAccessor(element);
      }
    }
  }
}

String generateForFunction(FunctionElement func) {
  final newName = func.displayName.substring(1);

  final transformer = new Transformer();

  // remove JsProxy annotation
  var jsProxyClass = getType(func, 'js.metadata', 'JsProxy');
  func.node.metadata
      .where((e) => isAnnotationOfType(e.elementAnnotation, jsProxyClass))
      .forEach((e) => transformer.removeNode(e));

  // rename
  transformer.replace(func.node.name.offset, func.node.name.end, newName);

  // body transformation
  var call = "context.callMethod('$newName'";
  if (func.parameters.isNotEmpty) {
    final parameterList = func.parameters.map((p) => p.displayName).join(', ');
    call += ", [$parameterList].map(toJs).toList()";
  }
  call += ")";
  if (func.returnType.isVoid) {
    transformer.replace(func.node.functionExpression.body.offset,
        func.node.functionExpression.body.end, '$call;');
  } else {
    transformer.replace(func.node.functionExpression.body.offset,
        func.node.functionExpression.body.end,
        " => ${toDart(func.returnType, call)};");
  }
  return transformer.applyOn(func);
}

String generateForTopLevelVariable(TopLevelVariableElement element) {
  return null;
}

String generateForPropertyAccessor(PropertyAccessorElement accessor) {
  final transformer = new Transformer();

  final name = accessor.displayName.substring(1);
  FunctionDeclaration funcDecl = accessor.node;

  // remove JsProxy annotation
  var jsProxyClass = getType(accessor, 'js.metadata', 'JsProxy');
  funcDecl.metadata
      .where((e) => isAnnotationOfType(e.elementAnnotation, jsProxyClass))
      .forEach((e) => transformer.removeNode(e));

  // rename to public
  transformer.replace(funcDecl.name.offset, funcDecl.name.end, name);

  // generate body
  String newFuncDecl;
  if (accessor.isGetter) {
    final type = accessor.returnType;
    final getterBody = createGetterBody(type, name, target: 'context');
    newFuncDecl = " => $getterBody";
  } else if (accessor.isSetter) {
    final type = accessor.parameters.first.type;
    final setterBody = createSetterBody(accessor.parameters.first,
        jsName: name, target: 'context');
    newFuncDecl = " { $setterBody }";
  }
  transformer.replace(funcDecl.functionExpression.body.offset,
      funcDecl.functionExpression.body.end, newFuncDecl);

  return transformer.applyOn(accessor);
}

class JsProxyClassGenerator {
  final ClassElement clazz;
  final JsProxy annotation;
  final transformer = new Transformer();

  ClassElement _jsProxyClass, _namespaceClass, _jsInterfaceClass;

  JsProxyClassGenerator(this.clazz, this.annotation) {
    _jsProxyClass = getType(clazz, 'js.metadata', 'JsProxy');
    _namespaceClass = getType(clazz, 'js.metadata', 'Namespace');
    _jsInterfaceClass = getType(clazz, 'js.impl', 'JsInterface');
  }

  String generate() {
    final newClassName = getNewClassName(clazz);

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
    clazz.constructors.where((c) => !c.isSynthetic).forEach((c) {
      final begin = c.node.firstTokenAfterCommentAndMetadata.offset;
      if (c.isDefaultConstructor) {
        transformer.replace(begin, c.node.returnType.end, newClassName);
      } else {
        transformer.replace(
            begin, c.node.name.end, '$newClassName.${c.displayName}');
      }
    });

    // generate the constructor .created
    if (!clazz.constructors.any((e) => e.displayName == 'created')) {
      final insertionIndex = clazz.constructors
              .where((e) => !e.isSynthetic).isEmpty
          ? clazz.node.leftBracket.end
          : clazz.constructors.first.node.offset;
      transformer.insertAt(insertionIndex,
          '$newClassName.created(JsObject o) : super.created(o);\n');
    }

    // generate constructors
    final jsConstructor =
        getJsProxyConstructor(clazz, _namespaceClass, annotation);
    clazz.constructors
        .where((c) => !c.isFactory)
        .where((c) => c.displayName != 'created')
        .where((c) => !c.isSynthetic)
        .where((c) => c.node.initializers.isEmpty)
        .forEach((c) {
      var newJsObject = "new JsObject(getPath('$jsConstructor')";
      if (c.parameters.isNotEmpty) {
        final parameterList = c.parameters.map((p) => p.displayName).join(', ');
        newJsObject += ", [$parameterList].map(toJs).toList()";
      }
      newJsObject += ")";
      transformer
          .insertAt(c.node.parameters.end, " : this.created($newJsObject)");
    });

    // generate properties
    transformAbstractAccessors(transformer,
        clazz.accessors.where((e) => !e.isStatic).where((e) => e.isAbstract));

    transformInstanceVariables(transformer, clazz.accessors
        .where((e) => !e.isStatic)
        .where((e) => e.isSynthetic)
        .where((e) => e.variable.initializer == null));

    // generate abstract methods
    clazz.methods.where((e) => !e.isStatic).forEach((m) {
      var call = "toJs(this).callMethod('${m.displayName}'";
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
        final setterBody = createSetterBody(param);
        code =
            "${accessor.returnType} set $name(${param.type.displayName} ${param.displayName}) { $setterBody }";
      }
      transformer.insertAt(accessor.variable.node.parent.end + 1, code);
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

  static String getJsProxyConstructor(ClassElement clazz,
      ClassElement namespaceClass, JsProxy jsProxyAnnotation) {
    var jsConstructor = "";
    final namespace = getNamespaceAnnotation(
        clazz.library.unit.directives.first, namespaceClass);
    if (namespace != null) jsConstructor += namespace.namespace + '.';
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
    {String target: "toJs(this)"}) {
  final typeName = type.displayName;
  return toDart(type, "$target['$name']") + ';';
}

String createSetterBody(ParameterElement param,
    {String target: "toJs(this)", String jsName}) {
  final name = param.displayName;
  final type = param.type;
  final typeName = type.displayName;
  jsName = jsName != null ? jsName : name;
  return "$target['$jsName'] = " + toJs(type, name) + ';';
}

String toDart(DartType type, String content) {
  final typeName = type.displayName;
  return "toDart($content) as $type";
}

String toJs(DartType type, String content) => "toJs($content)";

String getSourceCode(Element element) => element.source.contents.data.substring(
    element.node.offset, element.node.end);

class SourceTransformation {
  int begin;
  int end;
  final String content;

  SourceTransformation(this.begin, this.end, this.content);
  SourceTransformation.removal(this.begin, this.end) : content = '';
  SourceTransformation.insertion(int index, this.content)
      : begin = index,
        end = index;

  void shift(int value) {
    begin += value;
    end += value;
  }
}

class Transformer {
  final _transformations = <SourceTransformation>[];

  void insertAt(int index, String content) =>
      _transformations.add(new SourceTransformation.insertion(index, content));

  void removeBetween(int begin, int end) =>
      _transformations.add(new SourceTransformation.removal(begin, end));

  void removeNode(AstNode node) => _transformations
      .add(new SourceTransformation.removal(node.offset, node.end));

  void removeToken(Token token) => _transformations
      .add(new SourceTransformation.removal(token.offset, token.end));

  void replace(int begin, int end, String content) =>
      _transformations.add(new SourceTransformation(begin, end, content));

  String applyOn(Element element) {
    var code = getSourceCode(element);
    final initialPadding = -element.node.offset;
    _transformations.forEach((e) => e.shift(initialPadding));
    for (var i = 0; i < _transformations.length; i++) {
      final t = _transformations[i];
      code = code.substring(0, t.begin) + t.content + code.substring(t.end);
      _transformations.skip(i + 1).forEach((e) {
        if (e.end <= t.begin) return;
        if (t.end <= e.begin) {
          e.shift(t.content.length - (t.end - t.begin));
          return;
        }
        throw 'Colision in transformations';
      });
    }
    return code;
  }
}
