// GENERATED CODE - DO NOT MODIFY BY HAND
// 2015-04-24T13:47:13.366Z

part of js.test.types_handling_test;

// **************************************************************************
// Generator: JsInterfaceGenerator
// Target: abstract class _A
// **************************************************************************

class A extends JsInterface implements _A {
  A.created(JsObject o) : super.created(o);
  A() : this.created(new JsObject(getPath('A')));

  void set gender(Gender _gender) {
    asJsObject(this)['gender'] = __codec10.encode(_gender);
  }
  Gender get gender => __codec10.decode(asJsObject(this)['gender']);
  void set genders(List<Gender> _genders) {
    asJsObject(this)['genders'] = __codec11.encode(_genders);
  }
  List<Gender> get genders => __codec11.decode(asJsObject(this)['genders']);

  void set b(B _b) {
    asJsObject(this)['b'] = __codec12.encode(_b);
  }
  B get b => __codec12.decode(asJsObject(this)['b']);
  void set bs(List<B> _bs) {
    asJsObject(this)['bs'] = __codec13.encode(_bs);
  }
  List<B> get bs => __codec13.decode(asJsObject(this)['bs']);
  void set li(List<int> _li) {
    asJsObject(this)['li'] = __codec14.encode(_li);
  }
  List<int> get li => __codec14.decode(asJsObject(this)['li']);

  String toColorString(Color c) =>
      asJsObject(this).callMethod('toColorString', [__codec16.encode(c)]);
  Color toColor(String s) =>
      __codec16.decode(asJsObject(this).callMethod('toColor', [s]));

  B execute(B f(B b)) => __codec12
      .decode(asJsObject(this).callMethod('execute', [__codec17.encode(f)]));

  BisFunc getBisFunc() =>
      __codec17.decode(asJsObject(this).callMethod('getBisFunc'));

  void set simpleFunc(SimpleFunc _simpleFunc) {
    asJsObject(this)['simpleFunc'] = __codec15.encode(_simpleFunc);
  }
  SimpleFunc get simpleFunc => __codec15.decode(asJsObject(this)['simpleFunc']);
}
/// codec for Gender
final __codec10 = genderCodec;

/// codec for List<Gender>
final __codec11 = new JsListCodec<Gender>(__codec10);

/// codec for B
final __codec12 = new JsInterfaceCodec<B>((o) => new B.created(o));

/// codec for List<B>
final __codec13 = new JsListCodec<B>(__codec12);

/// codec for List<int>
final __codec14 = new JsListCodec<int>(null);

/// codec for (int) → String
final __codec15 = new FunctionCodec /*<(int) → String>*/ ((o) => o,
    (o) => ((JsFunction f) {
  if (f == null) return null;
  return (p_i) {
    return f.apply([p_i]);
  };
})(o));

/// codec for Color
final __codec16 = new BiMapCodec<Color, dynamic>({
  Color.RED: getPath('Color')['RED'],
  Color.GREEN: getPath('Color')['GREEN'],
  Color.BLUE: getPath('Color')['BLUE'],
  Color.WHITE: getPath('Color')['white']
});

/// codec for (B) → B
final __codec17 = new FunctionCodec /*<(B) → B>*/ ((o) => ((f) {
  if (f == null) return null;
  return (p_b) {
    p_b = __codec12.decode(p_b);
    final result = f(p_b);
    return __codec12.encode(result);
  };
})(o), (o) => ((JsFunction f) {
  if (f == null) return null;
  return (p_b) {
    p_b = __codec12.encode(p_b);
    final result = f.apply([p_b]);
    return __codec12.decode(result);
  };
})(o));

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
    asJsObject(this)['gender'] = __codec10.encode(_gender);
  }
  Gender get gender => __codec10.decode(asJsObject(this)['gender']);
  void set genders(List<Gender> _genders) {
    asJsObject(this)['genders'] = __codec11.encode(_genders);
  }
  List<Gender> get genders => __codec11.decode(asJsObject(this)['genders']);
}
