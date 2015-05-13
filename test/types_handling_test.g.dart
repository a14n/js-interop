// GENERATED CODE - DO NOT MODIFY BY HAND
// 2015-05-13T16:48:07.218Z

part of js.test.types_handling_test;

// **************************************************************************
// Generator: JsInterfaceGenerator
// Target: class _Color
// **************************************************************************

class Color extends JsEnum {
  static final values = <Color>[RED, GREEN, BLUE];
  static final RED = new Color._(getPath('Color')['RED']);
  static final GREEN = new Color._(getPath('Color')['GREEN']);
  static final BLUE = new Color._(getPath('Color')['BLUE']);
  Color._(o) : super.created(o);
}

// **************************************************************************
// Generator: JsInterfaceGenerator
// Target: abstract class _A
// **************************************************************************

class A extends JsInterface implements _A {
  A.created(JsObject o) : super.created(o);
  A() : this.created(new JsObject(getPath('A')));

  void set b(B _b) {
    asJsObject(this)['b'] = __codec1.encode(_b);
  }
  B get b => __codec1.decode(asJsObject(this)['b']);
  void set bs(List<B> _bs) {
    asJsObject(this)['bs'] = __codec2.encode(_bs);
  }
  List<B> get bs => __codec2.decode(asJsObject(this)['bs']);
  void set li(List<int> _li) {
    asJsObject(this)['li'] = __codec3.encode(_li);
  }
  List<int> get li => __codec3.decode(asJsObject(this)['li']);

  String toColorString(Color c) =>
      asJsObject(this).callMethod('toColorString', [__codec5.encode(c)]);
  Color toColor(String s) =>
      __codec5.decode(asJsObject(this).callMethod('toColor', [s]));

  B execute(B f(B b)) => __codec1
      .decode(asJsObject(this).callMethod('execute', [__codec6.encode(f)]));

  BisFunc getBisFunc() =>
      __codec6.decode(asJsObject(this).callMethod('getBisFunc'));

  void set simpleFunc(SimpleFunc _simpleFunc) {
    asJsObject(this)['simpleFunc'] = __codec4.encode(_simpleFunc);
  }
  SimpleFunc get simpleFunc => __codec4.decode(asJsObject(this)['simpleFunc']);
}
/// codec for B
final __codec1 = new JsInterfaceCodec<B>((o) => new B.created(o));

/// codec for List<B>
final __codec2 = new JsListCodec<B>(__codec1);

/// codec for List<int>
final __codec3 = new JsListCodec<int>(null);

/// codec for (int) → String
final __codec4 = new FunctionCodec /*<(int) → String>*/ ((f) => f,
    (JsFunction f) => (p_i) {
  return f.apply([p_i]);
});

/// codec for Color
final __codec5 = new BiMapCodec<Color, dynamic>(
    new Map<Color, dynamic>.fromIterable(Color.values, value: asJs));

/// codec for (B) → B
final __codec6 = new FunctionCodec /*<(B) → B>*/ ((f) => (p_b) {
  p_b = __codec1.decode(p_b);
  final result = f(p_b);
  return __codec1.encode(result);
}, (JsFunction f) => (p_b) {
  p_b = __codec1.encode(p_b);
  final result = f.apply([p_b]);
  return __codec1.decode(result);
});

// **************************************************************************
// Generator: JsInterfaceGenerator
// Target: abstract class _B
// **************************************************************************

class B extends JsInterface implements _B {
  B.created(JsObject o) : super.created(o);
  B(String v) : this.created(new JsObject(getPath('B'), [v]));

  String toString() => asJsObject(this).callMethod('toString');
}
