// GENERATED CODE - DO NOT MODIFY BY HAND
// 2015-03-10T22:09:11.063Z

part of js.example.js_proxy;

// **************************************************************************
// Generator: Instance of 'JsProxyGenerator'
// Target: library js.example.js_proxy
// **************************************************************************

void initializeJavaScript({List<String> exclude, List<String> include}) {
  bool accept(String name) => (include != null && include.contains(name)) ||
      (include == null && exclude != null && !exclude.contains(name));

  void register(String name, JsInterface f(JsObject o)) =>
      registerFactoryForJsConstructor(getPath(name), f);

  void mayRegister(String name, JsInterface f(JsObject o)) {
    if (accept(name)) register(name, f);
  }

  mayRegister('z.y.x.JsFoo', (o) => new JsFoo.created(o));
  mayRegister('z.y.x.a.b.JsBar', (o) => new JsBar.created(o));
  mayRegister('z.y.x.JsBaz', (o) => new JsBaz.created(o));
}

// **************************************************************************
// Generator: Instance of 'JsProxyGenerator'
// Target: abstract class _JsFoo
// **************************************************************************

class JsFoo extends JsInterface implements _JsFoo {
  JsFoo.created(JsObject o) : super.created(o);
  JsFoo() : this.created(new JsObject(getPath('z.y.x.JsFoo')));

  void set i(int _i) {
    asJsObject(this)['_i'] = _i;
  }
  int get i => asJsObject(this)['_i'];

  void set k2(num _k2) {
    asJsObject(this)['k_2'] = _k2;
  }
  num get k2 => asJsObject(this)['k_2'];
  void set k1(num _k1) {
    asJsObject(this)['k'] = _k1;
  }
  num get k1 => asJsObject(this)['k'];
  int j = null;
  bool get l => asJsObject(this)['l'];

  String get a => asJsObject(this)['a'];
  void set a(String a) {
    asJsObject(this)['a'] = a;
  }

  String get b => '';
  void set b(String b) {}

  m1() => asJsObject(this).callMethod('m1');
  void m2() {
    asJsObject(this).callMethod('m2');
  }
  String m3() => asJsObject(this).callMethod('m3');
  String m4(int a) => asJsObject(this).callMethod('m4', [a].map(toJs).toList());
  int m5(int a, b) =>
      asJsObject(this).callMethod('m5', [a, b].map(toJs).toList());

  int _m6(int a, b) =>
      asJsObject(this).callMethod('_m6', [a, b].map(toJs).toList());
}

// **************************************************************************
// Generator: Instance of 'JsProxyGenerator'
// Target: abstract class _JsBar
// **************************************************************************

class JsBar extends JsInterface implements _JsBar {
  JsBar.created(JsObject o) : super.created(o);
  external factory JsBar();
  external factory JsBar.named(int x, int y);
  JsBar m1() => ((e) => e == null ? null : new JsBar.created(e))(
      asJsObject(this).callMethod('m1'));
}

// **************************************************************************
// Generator: Instance of 'JsProxyGenerator'
// Target: abstract class _JsBaz
// **************************************************************************

class JsBaz extends JsBar implements _JsBaz {
  JsBaz.created(JsObject o) : super.created(o);
  external factory JsBaz();
}
