library js.example.simple_class;

import 'dart:js';

class JsType {
  final String name;
  const JsType({this.name});
}

abstract class JsInterface {
  final JsObject _o;
  JsInterface.created(this._o);
}

@JsType()
abstract class LatLng extends JsInterface {
  LatLng.created(o) : super.created(o);

  factory LatLng() = _$LatLng;
  factory LatLng.named() = _$LatLng.named;

  String m1();
}

//----------------------------
// generated content
//----------------------------
class _$LatLng extends LatLng {
  _$LatLng.created(o) : super.created(o);

  _$LatLng() : this.created(null);
  _$LatLng.named() : this.created(null);

  String m1() => toDart(toJs(this).callMethod('m1')) as String;
}

toDart(a)=> null;
toJs(a)=> null;