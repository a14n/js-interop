// GENERATED CODE - DO NOT MODIFY BY HAND
// 2015-03-17T18:14:06.648Z

part of js.example.js_proxy;

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
    asJsObject(this)['k'] = _k2;
  }
  num get k2 => asJsObject(this)['k'];
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
  JsBar.created(JsObject o) : super.created(o) {
    getState(this).putIfAbsent(#a, () => 0);
  }

  JsBar() : this.created(new JsObject(getPath('z.y.x.a.b.JsBar')));
  JsBar.named(int x, int y) : this.created(
          new JsObject(getPath('z.y.x.a.b.JsBar'), [x, y].map(toJs).toList()));

  JsBar m1() => ((e) => e == null ? null : new JsBar.created(e))(
      asJsObject(this).callMethod('m1'));

  void set a(int a) {
    getState(this)[#a] = a;
  }
  int get a => getState(this)[#a];
}

// **************************************************************************
// Generator: Instance of 'JsProxyGenerator'
// Target: abstract class _JsBaz
// **************************************************************************

class JsBaz extends JsBar implements _JsBaz {
  JsBaz.created(JsObject o) : super.created(o);
  JsBaz() : this.created(new JsObject(getPath('z.y.x.JsBaz')));
}

// **************************************************************************
// Generator: Instance of 'JsProxyGenerator'
// Target: abstract class __Context
// **************************************************************************

class _Context extends JsInterface implements __Context {
  _Context.created(JsObject o) : super.created(o);
  _Context() : this.created(getPath('z.y.x'));

  int find(String a) =>
      asJsObject(this).callMethod('find', [a].map(toJs).toList());

  void set a(String _a) {
    asJsObject(this)['a'] = _a;
  }
  String get a => asJsObject(this)['a'];

  String get b => asJsObject(this)['b'];

  set b(String b1) {
    asJsObject(this)['b'] = b1;
  }
}
