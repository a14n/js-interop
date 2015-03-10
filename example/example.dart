@JsName('z.y.x')
library js.example.js_proxy;

import 'package:js/js.dart';

part 'example.g.dart';

@JsProxy()
abstract class _JsFoo {
  factory _JsFoo() = dynamic;

  @JsName('_i')
  int i;

  @JsName('k')
  num k1, @JsName('k_2') k2;
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
  @JsName('_m6')
  int _m6(int a, b);
}

@JsProxy(constructor: 'a.b.JsBar')
abstract class _JsBar {
  external factory _JsBar();
  external factory _JsBar.named(int x, int y);
  JsBar m1();
}

@JsProxy()
abstract class _JsBaz extends JsBar {
  external factory _JsBaz();
}

@JsGlobal()
abstract class _Context {
  int find(String a);

  String a;

  String get b;

  set b(String b1);
}