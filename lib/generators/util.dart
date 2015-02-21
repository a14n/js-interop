library js.util;

import 'package:analyzer/analyzer.dart';
import 'package:analyzer/src/generated/ast.dart';
import 'package:analyzer/src/generated/element.dart';
import 'package:analyzer/src/generated/scanner.dart';

import '../src/metadata.dart';

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

JsProxy getProxyAnnotation(ClassElement interface, ClassElement jsProxyClass) {
  var node = interface.node;
  for (Annotation a in node.metadata) {
    var e = a.element;
    if (e is ConstructorElement && e.type.returnType == jsProxyClass.type) {
      bool global;
      String constructor;
      for (Expression e in a.arguments.arguments) {
        if (e is NamedExpression) {
          if (e.name.label.name == 'global' && e.expression is BooleanLiteral) {
            BooleanLiteral b = e.expression;
            global = b.value;
          } else if (e.name.label.name == 'constructor' &&
              e.expression is StringLiteral) {
            StringLiteral s = e.expression;
            constructor = s.stringValue;
          }
        }
      }
      return new JsProxy(global: global, constructor: constructor);
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
