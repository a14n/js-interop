@Namespace('z.y.x')
library js.example.js_proxy;

import 'package:js/js.dart';

part 'p.dart';
part 'example.g.dart';

@JsProxy()
abstract class _JsFoo  {
  _JsFoo();

  int i;

  num k1, k2;
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

/// comment
@JsProxy()
int _find(String a) => null;

@JsProxy()
String _a;

@JsProxy()
String get _b => null;

@JsProxy()
set _b(String b1) => null;