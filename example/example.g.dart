// GENERATED CODE - DO NOT MODIFY BY HAND
// 2015-04-15T15:56:27.998Z

part of js.example.js_proxy;

// **************************************************************************
// Generator: JsInterfaceGenerator
// Target: abstract class _JsFoo
// **************************************************************************

class JsFoo extends JsInterface implements _JsFoo {
  JsFoo.created(JsObject o) : super.created(o);
  JsFoo() : this.created(new JsObject(getPath('z.y.x.JsFoo')));

  void set l1(List _l1) {
    asJsObject(this)['l1'] = ((e) {
      if (e == null) return null;
      if (e is JsInterface) return asJsObject(e);
      return new JsArray.from(e);
    })(_l1);
  }
  List get l1 => asJsObject(this)['l1'] as JsArray;
  void set l2(List<num> _l2) {
    asJsObject(this)['l2'] = ((e) {
      if (e == null) return null;
      if (e is JsInterface) return asJsObject(e);
      return new JsArray.from(e);
    })(_l2);
  }
  List<num> get l2 => asJsObject(this)['l2'] as JsArray;
  void set l3(List<JsFoo> _l3) {
    asJsObject(this)['l3'] = ((e) {
      if (e == null) return null;
      if (e is JsInterface) return asJsObject(e);
      return new JsArray.from(e.map(toJs));
    })(_l3);
  }
  List<JsFoo> get l3 => ((e) {
    if (e == null) return null;
    return new JsList<JsFoo>.created(e, new JsInterfaceCodec<JsFoo>(
        (o) => ((e) => e == null ? null : new JsFoo.created(e))(o)));
  })(asJsObject(this)['l3']);

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
  String m4(int a) => asJsObject(this).callMethod('m4', [a]);
  int m5(int a, b) => asJsObject(this).callMethod('m5', [a, toJs(b)]);

  int _m6(int a, b) => asJsObject(this).callMethod('_m6', [a, toJs(b)]);
}

// **************************************************************************
// Generator: JsInterfaceGenerator
// Target: abstract class _JsBar
// **************************************************************************

@JsName('a.b.JsBar')
class JsBar extends JsInterface implements _JsBar {
  JsBar.created(JsObject o) : super.created(o) {
    getState(this).putIfAbsent(#a, () => 0);
  }

  factory JsBar() = dynamic;
  factory JsBar.named(int x, int y) = dynamic;

  JsBar m1() => ((e) => e == null ? null : new JsBar.created(e))(
      asJsObject(this).callMethod('m1'));

  void set a(int a) {
    getState(this)[#a] = a;
  }
  int get a => getState(this)[#a];
}

// **************************************************************************
// Generator: JsInterfaceGenerator
// Target: abstract class _JsBaz
// **************************************************************************

class JsBaz extends JsBar implements _JsBaz {
  JsBaz.created(JsObject o) : super.created(o);
  factory JsBaz() = dynamic;
}

// **************************************************************************
// Generator: JsInterfaceGenerator
// Target: abstract class __Context
// **************************************************************************

class _Context extends JsInterface implements __Context {
  _Context.created(JsObject o) : super.created(o);

  int find(String a) => asJsObject(this).callMethod('find', [a]);

  void set a(String _a) {
    asJsObject(this)['a'] = _a;
  }
  String get a => asJsObject(this)['a'];

  String get b => asJsObject(this)['b'];

  set b(String b1) {
    asJsObject(this)['b'] = b1;
  }
}
