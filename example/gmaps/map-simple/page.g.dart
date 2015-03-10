// GENERATED CODE - DO NOT MODIFY BY HAND
// 2015-03-10T06:46:08.965Z

part of google_maps.sample.simple;

// **************************************************************************
// Generator: Instance of 'JsProxyGenerator'
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

  bool equals(LatLng other) =>
      asJsObject(this).callMethod('equals', [other].map(toJs).toList());
  num get lat => asJsObject(this).callMethod('lat');
  num get lng => asJsObject(this).callMethod('lng');
  String toString() => asJsObject(this).callMethod('toString');
  String toUrlValue([num precision]) =>
      asJsObject(this).callMethod('toUrlValue', [precision].map(toJs).toList());
}

// **************************************************************************
// Generator: Instance of 'JsProxyGenerator'
// Target: abstract class _MapOptions
// **************************************************************************

class MapOptions extends JsInterface implements _MapOptions {
  MapOptions.created(JsObject o) : super.created(o);
  MapOptions() : this.created(new JsObject(getPath('Object')));
  void set zoom(int _zoom) {
    asJsObject(this)['zoom'] = _zoom;
  }
  int get zoom => asJsObject(this)['zoom'];
  void set center(LatLng _center) {
    asJsObject(this)['center'] =
        ((e) => e == null ? null : asJsObject(e))(_center);
  }
  LatLng get center => ((e) => e == null ? null : new LatLng.created(e))(
      asJsObject(this)['center']);
  void set mapTypeId(String _mapTypeId) {
    asJsObject(this)['mapTypeId'] = _mapTypeId;
  }
  String get mapTypeId => asJsObject(this)['mapTypeId'];
}

// **************************************************************************
// Generator: Instance of 'JsProxyGenerator'
// Target: abstract class _GEvent
// **************************************************************************

class GEvent extends JsInterface implements _GEvent {
  GEvent.created(JsObject o) : super.created(o);
  GEvent() : super.created(getPath('google.maps.event'));

  MapsEventListener addDomListener(
          dynamic instance, String eventName, Function handler,
          [bool capture]) =>
      ((e) => e == null ? null : new MapsEventListener.created(e))(
          asJsObject(this).callMethod('addDomListener',
              [instance, eventName, handler, capture].map(toJs).toList()));
  MapsEventListener addDomListenerOnce(
          dynamic instance, String eventName, Function handler,
          [bool capture]) =>
      ((e) => e == null ? null : new MapsEventListener.created(e))(
          asJsObject(this).callMethod('addDomListenerOnce',
              [instance, eventName, handler, capture].map(toJs).toList()));
  MapsEventListener addListener(
      dynamic instance, String eventName, Function handler) => ((e) =>
          e == null ? null : new MapsEventListener.created(e))(
      asJsObject(this).callMethod(
          'addListener', [instance, eventName, handler].map(toJs).toList()));
  MapsEventListener addListenerOnce(
          dynamic instance, String eventName, Function handler) =>
      ((e) => e == null ? null : new MapsEventListener.created(e))(
          asJsObject(this).callMethod('addListenerOnce',
              [instance, eventName, handler].map(toJs).toList()));
  void clearInstanceListeners(dynamic instance) {
    asJsObject(this).callMethod(
        'clearInstanceListeners', [instance].map(toJs).toList());
  }
  void clearListeners(dynamic instance, String eventName) {
    asJsObject(this).callMethod(
        'clearListeners', [instance, eventName].map(toJs).toList());
  }
  void removeListener(MapsEventListener listener) {
    asJsObject(this).callMethod(
        'removeListener', [listener].map(toJs).toList());
  }
  void trigger(
      dynamic instance, String eventName, /*@VarArgs()*/ List<dynamic> args) {
    asJsObject(this).callMethod(
        'trigger', [instance, eventName, args].map(toJs).toList());
  }
}

// **************************************************************************
// Generator: Instance of 'JsProxyGenerator'
// Target: abstract class _MapsEventListener
// **************************************************************************

class MapsEventListener extends JsInterface implements _MapsEventListener {
  MapsEventListener.created(JsObject o) : super.created(o);
}
