library source_gen.build_file;

import 'package:js/generators/init_javascript_generator.dart';
import 'package:js/generators/js_proxy_generator.dart';
import 'package:source_gen/source_gen.dart';

void main(List<String> args) {
  build(args, const [
    const JsProxyGenerator(),
    const InitializeJavascriptGenerator()
  ], librarySearchPaths: ['example', 'test']).then((msg) {
    print(msg);
  });
}
