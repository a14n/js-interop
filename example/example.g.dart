// GENERATED CODE - DO NOT MODIFY BY HAND
// 2015-02-21T13:41:02.284Z

part of js.example.js_proxy;

// **************************************************************************
// Generator: Instance of 'JsProxyGenerator'
// Target: abstract class _JsFoo
// **************************************************************************

class JsFoo extends JsInterface {
  JsFoo() : this.created(new JsObject(context['JsFoo']));

  int j = null;
  bool get l => toDart(toJs(this)['l']) as bool;

  String get a => toDart(toJs(this)['a']) as String;
  void set a(String a) {
    toJs(this)['a'] = a;
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
  void set k(int k) {
    toJs(this)['k'] = k;
  }
  int get k => toDart(toJs(this)['k']) as int;
  void set i(int i) {
    toJs(this)['i'] = i;
  }
  int get i => toDart(toJs(this)['i']) as int;
  JsFoo.created(JsObject o) : super.created(o);
}

// **************************************************************************
// Generator: Instance of 'JsProxyGenerator'
// Target: abstract class _JsBar
// **************************************************************************

class JsBar extends JsInterface {
  JsBar m1() => toDart(toJs(this).callMethod('m1')) as JsBar;
  JsBar.created(JsObject o) : super.created(o);
}
