library js.generator.js_proxy;

import 'dart:async';

import 'package:analyzer/analyzer.dart';
import 'package:analyzer/src/generated/ast.dart';
import 'package:analyzer/src/generated/element.dart';
import 'package:analyzer/src/generated/scanner.dart';

import 'package:source_gen/source_gen.dart';

import '../src/metadata.dart';

class JsProxyGenerator extends GeneratorForAnnotation<JsProxy> {
  const JsProxyGenerator();

  Future<String> generateForAnnotatedElement(
      Element element, JsProxy annotation) async {
    if (!element.isPrivate) throw '$element must be private';

    if (element is ClassElement) return new JsProxyClassGenerator(
        element, annotation).generate();
  }
}

class JsProxyClassGenerator {
  final ClassElement clazz;
  final JsProxy annotation;
  final transformations = <SourceTransformation>[];

  ClassElement _jsProxyClass, _jsInterfaceClass;

  JsProxyClassGenerator(this.clazz, this.annotation) {
    final jsMetadataLib = clazz.library.visibleLibraries.firstWhere(
        (l) => l.name == 'js.metadata', orElse: () => null);
    _jsProxyClass = jsMetadataLib.getType('JsProxy');
    final jsImplLib = clazz.library.visibleLibraries.firstWhere(
        (l) => l.name == 'js.impl', orElse: () => null);
    _jsInterfaceClass = jsMetadataLib.getType('JsInterface');
  }

  String generate() {
    final code =
        clazz.source.contents.data.substring(clazz.node.offset, clazz.node.end);
    final newClassName = clazz.displayName.substring(1);
    final endOfClass = clazz.node.end - 2;

    // check extension
    if (clazz.node.extendsClause == null) {
      transformations.add(new SourceTransformation.insertion(
          clazz.node.name.end, ' extends JsInterface'));
    }

    // remove JsProxy annotation
    clazz.node.metadata
        .where((e) => isAnnotationOfType(e.elementAnnotation, _jsProxyClass))
        .forEach((e) => transformations.add(removeNode(e)));

    // remove abstract
    transformations.add(removeToken(clazz.node.abstractKeyword));

    // rename class
    transformations.add(new SourceTransformation(
        clazz.node.name.offset, clazz.node.name.end, newClassName));
    clazz.constructors.where((c) => !c.isSynthetic).forEach((c) {
      // final begin = c.node.returnType.offset;
      final begin = c.node.offset;
      if (c.node.period == null) {
        transformations.add(new SourceTransformation(
            begin, c.node.returnType.end, newClassName));
      } else {
        transformations.add(new SourceTransformation(
            begin, c.node.name.end, '$newClassName.${c.displayName}'));
      }
    });

    // generate the name constructor .created
    if (!clazz.constructors.any((e) => e.displayName == 'created')) {
      transformations.add(new SourceTransformation.insertion(
          endOfClass, '$newClassName.created(JsObject o) : super.created(o);'));
    }

    // generate constructors
    final jsConstructor =
        annotation.constructor != null ? annotation.constructor : newClassName;
    clazz.constructors
        .where((c) => !c.isFactory)
        .where((c) => c.displayName != 'created')
        .where((c) => !c.isSynthetic)
        .where((c) => c.node.initializers.isEmpty)
        .forEach((c) {
      var newJsObject = "new JsObject(context['$jsConstructor']";
      if (c.parameters.isNotEmpty){
        final parameterList = c.parameters.map((p) => p.displayName).join(', ');
        newJsObject += ", [$parameterList].map(toJs).toList()";
      }
      newJsObject += ")";
      transformations.add(new SourceTransformation.insertion(
          c.node.parameters.end,
          " : this.created($newJsObject)"));
    });

    // generate properties
    final removedVariables = <VariableDeclaration>[];
    clazz.accessors.where((e) => !e.isStatic).forEach((p) {
      if (p.isAbstract) {
        if (p.isGetter) {
          transformations.add(new SourceTransformation.insertion(p.node.end - 1,
              " => toDart(toJs(this)['${p.displayName}']) as ${p.returnType.displayName}"));
        } else if (p.isSetter) {
          transformations.add(new SourceTransformation(p.node.end - 1,
              p.node.end,
              " { toJs(this)['${p.displayName}'] = ${p.parameters.first.displayName}; }"));
        }
      } else if (p.isSynthetic && p.variable.initializer == null) {
        final name = p.displayName;
        final typeName = p.variable.type.displayName;
        if (p.isGetter) {
          transformations.add(new SourceTransformation.insertion(endOfClass,
              "$typeName get $name => toDart(toJs(this)['$name']) as $typeName;"));
        } else if (p.isSetter) {
          transformations.add(new SourceTransformation.insertion(endOfClass,
              "void set $name($typeName $name) { toJs(this)['$name'] = $name; }"));
        }
        removedVariables.add(p.variable.node);
      }
    });

    // remove generated variables
    if (removedVariables.isNotEmpty) {
      removedVariables
          .map((e) => e.parent)
          .toSet()
          .forEach((VariableDeclarationList varDeclList) {
        if (varDeclList.variables.every((e) => removedVariables.contains(e))) {
          transformations.add(removeNode(varDeclList.parent));
        } else {
          throw "Please don't mix variables initialized and uninitialized,"
              " it's really a pain to handle :p";
        }
      });
    }

    // generate abstract methods
    clazz.methods.where((e) => !e.isStatic).forEach((m) {
      var call = "toJs(this).callMethod('${m.displayName}'";
      if (m.parameters.isNotEmpty) {
        final parameterList = m.parameters.map((p) => p.displayName).join(', ');
        call += ", [$parameterList].map(toJs).toList()";
      }
      call += ")";

      if (m.returnType.isVoid) {
        transformations.add(
            new SourceTransformation(m.node.end - 1, m.node.end, "{ $call; }"));
      } else {
        transformations.add(new SourceTransformation.insertion(m.node.end - 1,
            " => toDart($call) as ${m.returnType.displayName}"));
      }
    });

    return SourceTransformation.applyAll(code, transformations,
        initialPadding: -clazz.node.offset);
  }
}

bool isAnnotationOfType(
    ElementAnnotation annotation, ClassElement annotationClass) {
  var metaElement = annotation.element;
  var exp;
  var type;
  if (metaElement is PropertyAccessorElement) {
    exp = metaElement.variable;
    type = exp.evaluationResult.value.type;
  } else if (metaElement is ConstructorElement) {
    exp = metaElement;
    type = metaElement.enclosingElement.type;
  } else {
    throw new UnimplementedError('Unsupported annotation: ${annotation}');
  }
  if (exp == annotationClass) return true;
  if (type.isSubtypeOf(annotationClass.type)) {
    return true;
  }
  return false;
}

SourceTransformation removeNode(AstNode node) =>
    new SourceTransformation.removal(node.offset, node.end);
SourceTransformation removeToken(Token token) =>
    new SourceTransformation.removal(token.offset, token.end);

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

  static String applyAll(
      String code, List<SourceTransformation> transformations,
      {int initialPadding: 0}) {
    transformations.forEach((e) => e.shift(initialPadding));
    for (var i = 0; i < transformations.length; i++) {
      final t = transformations[i];
      code = code.substring(0, t.begin) + t.content + code.substring(t.end);
      transformations.skip(i + 1).forEach((e) {
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
