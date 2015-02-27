// GENERATED CODE - DO NOT MODIFY BY HAND
// 2015-02-27T21:03:34.873Z

part of js.example.js_proxy;

// **************************************************************************
// Generator: Instance of 'JsProxyGenerator'
// Target: abstract class _JsFoo
// **************************************************************************

class JsFoo extends JsInterface {
  JsFoo.created(JsObject o) : super.created(o);
/// test
  JsFoo() : this.created(new JsObject(getPath('z.y.x.JsFoo')));

  void set k(int _k) {
    toJs(this)['_k'] = toJs(_k);
  }
  int get k => toDart(toJs(this)['k']) as int;
  void set i(int _i) {
    toJs(this)['_i'] = toJs(_i);
  }
  int get i => toDart(toJs(this)['i']) as int;
  int j = null;
  bool get l => toDart(toJs(this)['l']) as bool;

  String get a => toDart(toJs(this)['a']) as String;
  void set a(String a) {
    toJs(this)['a'] = toJs(a);
  }

  String get b => '';
  void set b(String b) {}

  m1() => toDart(toJs(this).callMethod('m1')) as dynamic;
  void m2() {
    toJs(this).callMethod('m2');
  }
  String m3() => toDart(toJs(this).callMethod('m3')) as String;
  String m4(int a) =>
      toDart(toJs(this).callMethod('m4', [a].map(toJs).toList())) as String;
  int m5(int a, b) =>
      toDart(toJs(this).callMethod('m5', [a, b].map(toJs).toList())) as int;
}

// **************************************************************************
// Generator: Instance of 'InitializeJavascriptGenerator'
// Target: abstract class _JsFoo
// **************************************************************************

void initializeJavaScript() {
  registerFactoryForJsConstructor(
      getPath('z.y.x.JsFoo'), (o) => new JsFoo.created(o));
  registerFactoryForJsConstructor(
      getPath('z.y.x.a.b.JsBar'), (o) => new JsBar.created(o));
  registerFactoryForJsConstructor(
      getPath('z.y.x.JsBaz'), (o) => new JsBaz.created(o));
}

// **************************************************************************
// Generator: Instance of 'JsProxyGenerator'
// Target: abstract class _JsBar
// **************************************************************************

class JsBar extends JsInterface {
  JsBar.created(JsObject o) : super.created(o);

  JsBar m1() => toDart(toJs(this).callMethod('m1')) as JsBar;
}

// **************************************************************************
// Generator: Instance of 'JsProxyGenerator'
// Target: _find
// **************************************************************************

int find(String a) =>
    toDart(context.callMethod('find', [a].map(toJs).toList())) as int;

// **************************************************************************
// Generator: Instance of 'JsProxyGenerator'
// Target: _b
// **************************************************************************

String get b => toDart(context['b']) as String;

// **************************************************************************
// Generator: Instance of 'JsProxyGenerator'
// Target: _b
// **************************************************************************

set b(String b1) {
  context['b'] = toJs(b1);
}

// **************************************************************************
// Generator: Instance of 'JsProxyGenerator'
// Target: abstract class _JsBaz
// **************************************************************************

class JsBaz extends JsInterface {
  JsBaz.created(JsObject o) : super.created(o);

  JsBar m1() => toDart(toJs(this).callMethod('m1')) as JsBar;
}
