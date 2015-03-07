library js.util;

import 'package:analyzer/analyzer.dart';
import 'package:analyzer/src/generated/ast.dart';
import 'package:analyzer/src/generated/element.dart';
import 'package:analyzer/src/generated/scanner.dart';

import '../src/metadata.dart';

LibraryElement getLib(Element element, String name) =>
    element.library.visibleLibraries.firstWhere((l) => l.name == name);

ClassElement getType(Element element, String libraryName, String className) =>
    getLib(element, libraryName).getType(className);

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
  return type.isSubtypeOf(annotationClass.type);
}

JsProxy getProxyAnnotation(Element interface, ClassElement jsProxyClass) {
  var node = interface.node;
  for (Annotation a in node.metadata) {
    var e = a.element;
    if (e is ConstructorElement && e.type.returnType == jsProxyClass.type) {
      if (e.isDefaultConstructor) {
        String constructor;
        for (Expression e in a.arguments.arguments) {
          if (e is NamedExpression) {
            if (e.name.label.name == 'constructor' &&
                e.expression is StringLiteral) {
              StringLiteral s = e.expression;
              constructor = s.stringValue;
            }
          }
        }
        return new JsProxy(constructor: constructor);
      } else if (e.name == 'anonymous') {
        return new JsProxy.anonymous();
      }
    }
  }
  return null;
}

JsName getNameAnnotation(AnnotatedNode node, ClassElement jsNameClass) {
  for (Annotation a in node.metadata) {
    var e = a.element;
    if (e is ConstructorElement && e.type.returnType == jsNameClass.type) {
      if (a.arguments.arguments.length == 1) {
        var param = a.arguments.arguments.first;
        if (param is StringLiteral) {
          return new JsName(param.stringValue);
        }
      }
    }
  }
  return null;
}

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
