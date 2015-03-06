library js.generator.init_javascript;

import 'dart:async';

import 'package:analyzer/src/generated/element.dart';

import 'package:source_gen/source_gen.dart';

import 'js_proxy_generator.dart';
import 'util.dart';

final _libs = <LibraryElement>[];

class InitializeJavascriptGenerator extends Generator {
  const InitializeJavascriptGenerator();

  Future<String> generate(Element element) async {
    var libElement = element.library;

    if (_libs.contains(libElement)) return null;
    _libs.add(libElement);

    final jsMetadataLib = libElement.visibleLibraries.firstWhere(
        (l) => l.name == 'js.metadata', orElse: () => null);

    if (jsMetadataLib == null) return null;

    var jsProxyClass = jsMetadataLib.getType('JsProxy');
    var namespaceClass = jsMetadataLib.getType('Namespace');

    var proxies = libElement.units
        .expand((e) => e.types)
        .where((ClassElement e) =>
            e.metadata.any((md) => isAnnotationOfType(md, jsProxyClass)));

    if (proxies.isEmpty) return null;

    var ouput = 'void initializeJavaScript({List<String> exclude, List<String> include}){';
    ouput += "bool accept(String name) => (include != null && include.contains(name)) || "
        "(include == null && exclude != null && !exclude.contains(name));\n\n";
    ouput += "void register(String name, JsInterface f(JsObject o)) => "
        "registerFactoryForJsConstructor(getPath(name), f);\n\n";
    ouput += "void mayRegister(String name, JsInterface f(JsObject o)) { "
        "if(accept(name))register(name, f);}\n\n";
    for (ClassElement clazz in proxies) {
      final name = JsProxyClassGenerator.getNewClassName(clazz);
      final jsProxy = getProxyAnnotation(clazz, jsProxyClass);
      final constructor = JsProxyClassGenerator.getJsProxyConstructor(
          clazz, namespaceClass, jsProxy);
      ouput += "mayRegister('$constructor', (o) => new $name.created(o));";
    }
    ouput += '}';
    return ouput;
  }
}
