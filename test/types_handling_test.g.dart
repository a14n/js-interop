// GENERATED CODE - DO NOT MODIFY BY HAND
// 2015-05-11T21:18:56.237Z

part of js.test.types_handling_test;

// **************************************************************************
// Generator: JsInterfaceGenerator
// Target: class _Color
// **************************************************************************

class Color extends JsEnumBase {
  static final values = <Color>[RED, GREEN, BLUE, WHITE];
  static final RED = new Color._(getPath('Color')['RED']);
  static final GREEN = new Color._(getPath('Color')['GREEN']);
  static final BLUE = new Color._(getPath('Color')['BLUE']);
  static final WHITE = new Color._(getPath('Color')['white']);
  Color._(o) : super.created(o);
}

// **************************************************************************
// Generator: JsInterfaceGenerator
// Target: abstract class _A
// **************************************************************************

class A extends JsInterface implements _A {
  A.created(JsObject o) : super.created(o);
  A() : this.created(new JsObject(getPath('A')));

  void set gender(Gender _gender) {
    asJsObject(this)['gender'] = __codec13.encode(_gender);
  }
  Gender get gender => __codec13.decode(asJsObject(this)['gender']);
  void set genders(List<Gender> _genders) {
    asJsObject(this)['genders'] = __codec14.encode(_genders);
  }
  List<Gender> get genders => __codec14.decode(asJsObject(this)['genders']);

  void set b(B _b) {
    asJsObject(this)['b'] = __codec15.encode(_b);
  }
  B get b => __codec15.decode(asJsObject(this)['b']);
  void set bs(List<B> _bs) {
    asJsObject(this)['bs'] = __codec16.encode(_bs);
  }
  List<B> get bs => __codec16.decode(asJsObject(this)['bs']);
  void set li(List<int> _li) {
    asJsObject(this)['li'] = __codec17.encode(_li);
  }
  List<int> get li => __codec17.decode(asJsObject(this)['li']);

  String toColorString(Color c) =>
      asJsObject(this).callMethod('toColorString', [__codec19.encode(c)]);
  Color toColor(String s) =>
      __codec19.decode(asJsObject(this).callMethod('toColor', [s]));

  B execute(B f(B b)) => __codec15
      .decode(asJsObject(this).callMethod('execute', [__codec20.encode(f)]));

  BisFunc getBisFunc() =>
      __codec20.decode(asJsObject(this).callMethod('getBisFunc'));

  void set simpleFunc(SimpleFunc _simpleFunc) {
    asJsObject(this)['simpleFunc'] = __codec18.encode(_simpleFunc);
  }
  SimpleFunc get simpleFunc => __codec18.decode(asJsObject(this)['simpleFunc']);
}
/// codec for Gender
final __codec13 = new BiMapCodec<Gender, dynamic>(
    new Map<Gender, dynamic>.fromIterable(Gender.values, value: asJs));

/// codec for List<Gender>
final __codec14 = new JsListCodec<Gender>(__codec13);

/// codec for B
final __codec15 = new JsInterfaceCodec<B>((o) => new B.created(o));

/// codec for List<B>
final __codec16 = new JsListCodec<B>(__codec15);

/// codec for List<int>
final __codec17 = new JsListCodec<int>(null);

/// codec for (int) → String
final __codec18 = new FunctionCodec /*<(int) → String>*/ ((f) => f,
    (JsFunction f) => (p_i) {
  return f.apply([p_i]);
});

/// codec for Color
final __codec19 = new BiMapCodec<Color, dynamic>(
    new Map<Color, dynamic>.fromIterable(Color.values, value: asJs));

/// codec for (B) → B
final __codec20 = new FunctionCodec /*<(B) → B>*/ ((f) => (p_b) {
  p_b = __codec15.decode(p_b);
  final result = f(p_b);
  return __codec15.encode(result);
}, (JsFunction f) => (p_b) {
  p_b = __codec15.encode(p_b);
  final result = f.apply([p_b]);
  return __codec15.decode(result);
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
// Target: class _Gender
// **************************************************************************

class Gender extends JsEnumBase {
  static final values = <Gender>[MALE, FEMALE];
  static final MALE = new Gender._(getGenderValue('MALE'));
  static final FEMALE = new Gender._(getGenderValue('FEMALE'));
  Gender._(o) : super.created(o);
}

// **************************************************************************
// Generator: JsInterfaceGenerator
// Target: abstract class _C
// **************************************************************************

class C extends JsInterface implements _C {
  C.created(JsObject o) : super.created(o);
  C() : this.created(new JsObject(getPath('C')));

  void set gender(Gender _gender) {
    asJsObject(this)['gender'] = __codec13.encode(_gender);
  }
  Gender get gender => __codec13.decode(asJsObject(this)['gender']);
  void set genders(List<Gender> _genders) {
    asJsObject(this)['genders'] = __codec14.encode(_genders);
  }
  List<Gender> get genders => __codec14.decode(asJsObject(this)['genders']);
}
