// GENERATED CODE - DO NOT MODIFY BY HAND
// 2015-03-08T21:14:11.333Z

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
    unwrap(this)['i'] = toJs(_i);
  }
  int get i => toDart(unwrap(this)['i']) as int;

  void set k2(num _k2) {
    unwrap(this)['k2'] = toJs(_k2);
  }
  num get k2 => toDart(unwrap(this)['k2']) as num;
  void set k1(num _k1) {
    unwrap(this)['k1'] = toJs(_k1);
  }
  num get k1 => toDart(unwrap(this)['k1']) as num;
  int j = null;
  bool get l => toDart(unwrap(this)['l']) as bool;

  String get a => toDart(unwrap(this)['a']) as String;
  void set a(String a) {
    unwrap(this)['a'] = toJs(a);
  }

  String get b => '';
  void set b(String b) {}

  m1() => toDart(unwrap(this).callMethod('m1')) as dynamic;
  void m2() {
    unwrap(this).callMethod('m2');
  }
  String m3() => toDart(unwrap(this).callMethod('m3')) as String;
  String m4(int a) =>
      toDart(unwrap(this).callMethod('m4', [a].map(toJs).toList())) as String;
  int m5(int a, b) =>
      toDart(unwrap(this).callMethod('m5', [a, b].map(toJs).toList())) as int;
}

// **************************************************************************
// Generator: Instance of 'JsProxyGenerator'
// Target: abstract class _JsBar
// **************************************************************************

class JsBar extends JsInterface implements _JsBar {
  JsBar.created(JsObject o) : super.created(o);
  external factory JsBar();
  external factory JsBar.named(int x, int y);
  JsBar m1() => toDart(unwrap(this).callMethod('m1')) as JsBar;
}

// **************************************************************************
// Generator: Instance of 'JsProxyGenerator'
// Target: abstract class _JsBaz
// **************************************************************************

class JsBaz extends JsBar implements _JsBaz {
  JsBaz.created(JsObject o) : super.created(o);
  external factory JsBaz();
}
