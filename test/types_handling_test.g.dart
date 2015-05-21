// GENERATED CODE - DO NOT MODIFY BY HAND
// 2015-05-21T16:42:25.828Z

part of js.test.types_handling_test;

// **************************************************************************
// Generator: JsInterfaceGenerator
// Target: class _Color
// **************************************************************************

class Color extends JsEnum {
  static final values = <Color>[RED, GREEN, BLUE];
  static final RED = new Color._('RED', context['Color']['RED']);
  static final GREEN = new Color._('GREEN', context['Color']['GREEN']);
  static final BLUE = new Color._('BLUE', context['Color']['BLUE']);
  final String _name;
  Color._(this._name, o) : super.created(o);
  String toString() => 'Color.$_name';
}

// **************************************************************************
// Generator: JsInterfaceGenerator
// Target: abstract class _A
// **************************************************************************

class A extends JsInterface implements _A {
  A.created(JsObject o) : super.created(o);
  A() : this.created(new JsObject(context['A']));

  void set b(B _b) {
    asJsObject(this)['b'] = __codec13.encode(_b);
  }
  B get b => __codec13.decode(asJsObject(this)['b']);
  void set bs(List<B> _bs) {
    asJsObject(this)['bs'] = __codec14.encode(_bs);
  }
  List<B> get bs => __codec14.decode(asJsObject(this)['bs']);
  void set li(List<int> _li) {
    asJsObject(this)['li'] = __codec15.encode(_li);
  }
  List<int> get li => __codec15.decode(asJsObject(this)['li']);

  String toColorString(Color c) =>
      asJsObject(this).callMethod('toColorString', [__codec17.encode(c)]);
  Color toColor(String s) =>
      __codec17.decode(asJsObject(this).callMethod('toColor', [s]));

  String execute(B f(B b)) =>
      asJsObject(this).callMethod('execute', [__codec18.encode(f)]);

  String execute2(String f(B s, [int i])) =>
      asJsObject(this).callMethod('execute2', [__codec19.encode(f)]);

  BisFunc getBisFunc() =>
      __codec18.decode(asJsObject(this).callMethod('getBisFunc'));

  void set simpleFunc(SimpleFunc _simpleFunc) {
    asJsObject(this)['simpleFunc'] = __codec16.encode(_simpleFunc);
  }
  SimpleFunc get simpleFunc => __codec16.decode(asJsObject(this)['simpleFunc']);
}
/// codec for B
final __codec13 = new JsInterfaceCodec<B>((o) => new B.created(o));

/// codec for List<B>
final __codec14 = new JsListCodec<B>(__codec13);

/// codec for List<int>
final __codec15 = new JsListCodec<int>(null);

/// codec for (int) → String
final __codec16 = new FunctionCodec /*<(int) → String>*/ ((f) => f,
    (JsFunction f) => (p_i) {
  return f.apply([p_i]);
});

/// codec for Color
final __codec17 = new BiMapCodec<Color, dynamic>(
    new Map<Color, dynamic>.fromIterable(Color.values, value: asJs));

/// codec for (B) → B
final __codec18 = new FunctionCodec /*<(B) → B>*/ ((f) => (p_b) {
  p_b = __codec13.decode(p_b);
  final result = f(p_b);
  return __codec13.encode(result);
}, (JsFunction f) => (p_b) {
  p_b = __codec13.encode(p_b);
  final result = f.apply([p_b]);
  return __codec13.decode(result);
});

/// codec for (B, [int]) → String
final __codec19 = new FunctionCodec /*<(B, [int]) → String>*/ ((f) => (p_s,
    [p_i]) {
  p_s = __codec13.decode(p_s);
  return f(p_s, p_i);
}, (JsFunction f) => (p_s, [p_i]) {
  p_s = __codec13.encode(p_s);
  return f.apply([p_s, p_i]);
});

// **************************************************************************
// Generator: JsInterfaceGenerator
// Target: abstract class _B
// **************************************************************************

class B extends JsInterface implements _B {
  B.created(JsObject o) : super.created(o);
  B(String v) : this.created(new JsObject(context['B'], [v]));

  String toString() => asJsObject(this).callMethod('toString');
}
