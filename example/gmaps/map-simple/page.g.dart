// GENERATED CODE - DO NOT MODIFY BY HAND
// 2015-03-08T16:03:58.404Z

part of google_maps.sample.simple;

// **************************************************************************
// Generator: Instance of 'InitializeJavascriptGenerator'
// Target: library google_maps.sample.simple
// **************************************************************************

void initializeJavaScript({List<String> exclude, List<String> include}) {
  bool accept(String name) => (include != null && include.contains(name)) ||
      (include == null && exclude != null && !exclude.contains(name));

  void register(String name, JsInterface f(JsObject o)) =>
      registerFactoryForJsConstructor(getPath(name), f);

  void mayRegister(String name, JsInterface f(JsObject o)) {
    if (accept(name)) register(name, f);
  }

  mayRegister('google.maps.Map', (o) => new GMap.created(o));
  mayRegister('google.maps.LatLng', (o) => new LatLng.created(o));
}

// **************************************************************************
// Generator: Instance of 'JsProxyGenerator'
// Target: abstract class _GMap
// **************************************************************************

class GMap extends JsInterface implements _GMap {
  GMap.created(JsObject o) : super.created(o);
  GMap(Node mapDiv, [MapOptions opts]) : this.created(new JsObject(
          getPath('google.maps.Map'), [mapDiv, opts].map(toJs).toList()));
}

// **************************************************************************
// Generator: Instance of 'JsProxyGenerator'
// Target: abstract class _LatLng
// **************************************************************************

class LatLng extends JsInterface implements _LatLng {
  LatLng.created(JsObject o) : super.created(o);
  LatLng(num lat, num lng, [bool noWrap]) : this.created(new JsObject(
          getPath('google.maps.LatLng'),
          [lat, lng, noWrap].map(toJs).toList()));

  bool equals(LatLng other) => toDart(
      unwrap(this).callMethod('equals', [other].map(toJs).toList())) as bool;
  num get lat => unwrap(this).callMethod('lat');
  num get lng => unwrap(this).callMethod('lng');
  String toString() => toDart(unwrap(this).callMethod('toString')) as String;
  String toUrlValue([num precision]) => toDart(unwrap(this).callMethod(
      'toUrlValue', [precision].map(toJs).toList())) as String;
}

// **************************************************************************
// Generator: Instance of 'JsProxyGenerator'
// Target: abstract class _MapOptions
// **************************************************************************

class MapOptions extends JsInterface implements _MapOptions {
  MapOptions.created(JsObject o) : super.created(o);
  MapOptions() : this.created(new JsObject(getPath('Object')));
  void set zoom(int _zoom) {
    unwrap(this)['zoom'] = toJs(_zoom);
  }
  int get zoom => toDart(unwrap(this)['zoom']) as int;
  void set center(LatLng _center) {
    unwrap(this)['center'] = toJs(_center);
  }
  LatLng get center => toDart(unwrap(this)['center']) as LatLng;
  void set mapTypeId(String _mapTypeId) {
    unwrap(this)['mapTypeId'] = toJs(_mapTypeId);
  }
  String get mapTypeId => toDart(unwrap(this)['mapTypeId']) as String;
}
