// GENERATED CODE - DO NOT MODIFY BY HAND
// 2015-04-22T20:27:29.686Z

part of js.test.types_handling_test;

// **************************************************************************
// Generator: JsInterfaceGenerator
// Target: abstract class _A
// **************************************************************************

class A extends JsInterface implements _A {
  A.created(JsObject o) : super.created(o);
  A() : this.created(new JsObject(getPath('A')));

  void set gender(Gender _gender) {
    asJsObject(this)['gender'] = genderCodec.encode(_gender);
  }
  Gender get gender => genderCodec.decode(asJsObject(this)['gender']);
  void set genders(List<Gender> _genders) {
    asJsObject(this)['genders'] = ((e) {
      if (e == null) return null;
      if (e is JsInterface) return asJsObject(e);
      return new JsArray.from(e.map(genderCodec.encode));
    })(_genders);
  }
  List<Gender> get genders => ((e) {
    if (e == null) return null;
    return new JsList<Gender>.created(e, genderCodec);
  })(asJsObject(this)['genders']);

  void set b(B _b) {
    asJsObject(this)['b'] = ((e) => e == null ? null : asJsObject(e))(_b);
  }
  B get b =>
      ((e) => e == null ? null : new B.created(e))(asJsObject(this)['b']);
  void set bs(List<B> _bs) {
    asJsObject(this)['bs'] = ((e) {
      if (e == null) return null;
      if (e is JsInterface) return asJsObject(e);
      return new JsArray.from(e.map(new JsInterfaceCodec<B>(
          (o) => ((e) => e == null ? null : new B.created(e))(o)).encode));
    })(_bs);
  }
  List<B> get bs => ((e) {
    if (e == null) return null;
    return new JsList<B>.created(e, new JsInterfaceCodec<B>(
        (o) => ((e) => e == null ? null : new B.created(e))(o)));
  })(asJsObject(this)['bs']);
  void set li(List<int> _li) {
    asJsObject(this)['li'] = ((e) {
      if (e == null) return null;
      if (e is JsInterface) return asJsObject(e);
      return new JsArray.from(e);
    })(_li);
  }
  List<int> get li => asJsObject(this)['li'] as JsArray;

  String toColorString(Color c) => asJsObject(this).callMethod('toColorString',
      [
    ((e) {
      if (e == null) return null;
      final path = getPath('Color');
      if (e == Color.RED) return path['RED'];
      if (e == Color.GREEN) return path['GREEN'];
      if (e == Color.BLUE) return path['BLUE'];
      if (e == Color.WHITE) return path['white'];
    })(c)
  ]);
  Color toColor(String s) => ((e) {
    if (e == null) return null;
    final path = getPath('Color');
    if (e == path['RED']) return Color.RED;
    if (e == path['GREEN']) return Color.GREEN;
    if (e == path['BLUE']) return Color.BLUE;
    if (e == path['white']) return Color.WHITE;
  })(asJsObject(this).callMethod('toColor', [s]));

  B execute(B f(B b)) => ((e) => e == null ? null : new B.created(e))(
      asJsObject(this).callMethod('execute', [
    ((f) {
      if (f == null) return null;
      return (p_b) {
        p_b = new JsInterfaceCodec<B>(
            (o) => ((e) => e == null ? null : new B.created(e))(o)).decode(p_b);
        final result = f(p_b);
        return new JsInterfaceCodec<B>(
                (o) => ((e) => e == null ? null : new B.created(e))(o))
            .encode(result);
      };
    })(f)
  ]));

  BisFunc getBisFunc() => ((JsFunction f) {
    if (f == null) return null;
    return (p_b) {
      p_b = new JsInterfaceCodec<B>(
          (o) => ((e) => e == null ? null : new B.created(e))(o)).encode(p_b);
      final result = f.apply([p_b]);
      return new JsInterfaceCodec<B>(
              (o) => ((e) => e == null ? null : new B.created(e))(o))
          .decode(result);
    };
  })(asJsObject(this).callMethod('getBisFunc'));

  void set simpleFunc(SimpleFunc _simpleFunc) {
    asJsObject(this)['simpleFunc'] = _simpleFunc;
  }
  SimpleFunc get simpleFunc => ((JsFunction f) {
    if (f == null) return null;
    return (p_i) {
      return f.apply([p_i]);
    };
  })(asJsObject(this)['simpleFunc']);
}

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
    asJsObject(this)['gender'] = genderCodec.encode(_gender);
  }
  Gender get gender => genderCodec.decode(asJsObject(this)['gender']);
  void set genders(List<Gender> _genders) {
    asJsObject(this)['genders'] = ((e) {
      if (e == null) return null;
      if (e is JsInterface) return asJsObject(e);
      return new JsArray.from(e.map(genderCodec.encode));
    })(_genders);
  }
  List<Gender> get genders => ((e) {
    if (e == null) return null;
    return new JsList<Gender>.created(e, genderCodec);
  })(asJsObject(this)['genders']);
}
