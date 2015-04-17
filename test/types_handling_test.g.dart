// GENERATED CODE - DO NOT MODIFY BY HAND
// 2015-04-17T20:54:55.307Z

part of js.test.types_handling_test;

// **************************************************************************
// Generator: JsInterfaceGenerator
// Target: abstract class _A
// **************************************************************************

class A extends JsInterface implements _A {
  A.created(JsObject o) : super.created(o);
  A() : this.created(new JsObject(getPath('A')));

  void set b(B _b) {
    asJsObject(this)['b'] = ((e) => e == null ? null : asJsObject(e))(_b);
  }
  B get b =>
      ((e) => e == null ? null : new B.created(e))(asJsObject(this)['b']);
  void set bs(List<B> _bs) {
    asJsObject(this)['bs'] = ((e) {
      if (e == null) return null;
      if (e is JsInterface) return asJsObject(e);
      return new JsArray.from(e.map(toJs));
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
    })(c)
  ]);
  Color toColor(String s) => ((e) {
    if (e == null) return null;
    final path = getPath('Color');
    if (e == path['RED']) return Color.RED;
    if (e == path['GREEN']) return Color.GREEN;
    if (e == path['BLUE']) return Color.BLUE;
  })(asJsObject(this).callMethod('toColor', [s]));
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
