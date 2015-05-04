// GENERATED CODE - DO NOT MODIFY BY HAND
// 2015-05-04T12:26:03.830Z

part of js.test.types_handling_test;

// **************************************************************************
// Generator: JsInterfaceGenerator
// Target: abstract class _A
// **************************************************************************

class A extends JsInterface implements _A {
  A.created(JsObject o) : super.created(o);
  A() : this.created(new JsObject(getPath('A')));

  void set gender(Gender _gender) {
    asJsObject(this)['gender'] = __codec1.encode(_gender);
  }
  Gender get gender => __codec1.decode(asJsObject(this)['gender']);
  void set genders(List<Gender> _genders) {
    asJsObject(this)['genders'] = __codec2.encode(_genders);
  }
  List<Gender> get genders => __codec2.decode(asJsObject(this)['genders']);

  void set b(B _b) {
    asJsObject(this)['b'] = __codec3.encode(_b);
  }
  B get b => __codec3.decode(asJsObject(this)['b']);
  void set bs(List<B> _bs) {
    asJsObject(this)['bs'] = __codec4.encode(_bs);
  }
  List<B> get bs => __codec4.decode(asJsObject(this)['bs']);
  void set li(List<int> _li) {
    asJsObject(this)['li'] = __codec5.encode(_li);
  }
  List<int> get li => __codec5.decode(asJsObject(this)['li']);

  String toColorString(Color c) =>
      asJsObject(this).callMethod('toColorString', [__codec7.encode(c)]);
  Color toColor(String s) =>
      __codec7.decode(asJsObject(this).callMethod('toColor', [s]));

  B execute(B f(B b)) => __codec3
      .decode(asJsObject(this).callMethod('execute', [__codec8.encode(f)]));

  BisFunc getBisFunc() =>
      __codec8.decode(asJsObject(this).callMethod('getBisFunc'));

  void set simpleFunc(SimpleFunc _simpleFunc) {
    asJsObject(this)['simpleFunc'] = __codec6.encode(_simpleFunc);
  }
  SimpleFunc get simpleFunc => __codec6.decode(asJsObject(this)['simpleFunc']);
}
/// codec for Gender
final __codec1 = genderCodec;

/// codec for List<Gender>
final __codec2 = new JsListCodec<Gender>(__codec1);

/// codec for B
final __codec3 = new JsInterfaceCodec<B>((o) => new B.created(o));

/// codec for List<B>
final __codec4 = new JsListCodec<B>(__codec3);

/// codec for List<int>
final __codec5 = new JsListCodec<int>(null);

/// codec for (int) → String
final __codec6 = new FunctionCodec /*<(int) → String>*/ ((f) => f,
    (JsFunction f) => (p_i) {
  return f.apply([p_i]);
});

/// codec for Color
final __codec7 = new BiMapCodec<Color, dynamic>({
  Color.RED: getPath('Color')['RED'],
  Color.GREEN: getPath('Color')['GREEN'],
  Color.BLUE: getPath('Color')['BLUE'],
  Color.WHITE: getPath('Color')['white']
});

/// codec for (B) → B
final __codec8 = new FunctionCodec /*<(B) → B>*/ ((f) => (p_b) {
  p_b = __codec3.decode(p_b);
  final result = f(p_b);
  return __codec3.encode(result);
}, (JsFunction f) => (p_b) {
  p_b = __codec3.encode(p_b);
  final result = f.apply([p_b]);
  return __codec3.decode(result);
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

// **************************************************************************
// Generator: JsInterfaceGenerator
// Target: abstract class _C
// **************************************************************************

class C extends JsInterface implements _C {
  C.created(JsObject o) : super.created(o);
  C() : this.created(new JsObject(getPath('C')));

  void set gender(Gender _gender) {
    asJsObject(this)['gender'] = __codec1.encode(_gender);
  }
  Gender get gender => __codec1.decode(asJsObject(this)['gender']);
  void set genders(List<Gender> _genders) {
    asJsObject(this)['genders'] = __codec2.encode(_genders);
  }
  List<Gender> get genders => __codec2.decode(asJsObject(this)['genders']);
}
