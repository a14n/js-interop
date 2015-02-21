library js.example.js_proxy;

import 'package:js/js.dart';

part 'p.dart';
part 'example.g.dart';

@JsProxy()
abstract class _JsFoo {
  _JsFoo();

  int i, k;
  int j = null;
  bool get l;

  String get a;
  void set a(String a);

  String get b => '';
  void set b(String b) {}

  m1();
  void m2();
  String m3();
  String m4(int a);
  int m5(int a, b);
}

@JsProxy(constructor: 'a.b.JsBar')
abstract class _JsBar {
  JsBar m1();
}