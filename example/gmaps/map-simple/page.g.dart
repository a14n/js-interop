// GENERATED CODE - DO NOT MODIFY BY HAND
// 2015-04-15T15:56:28.062Z

part of google_maps.sample.simple;

// **************************************************************************
// Generator: JsInterfaceGenerator
// Target: abstract class _GMap
// **************************************************************************

@JsName('Map')
class GMap extends JsInterface implements _GMap {
  GMap.created(JsObject o) : super.created(o);
  GMap(Node mapDiv, [MapOptions opts]) : this.created(new JsObject(
          getPath('google.maps.Map'), [
        mapDiv,
        ((e) => e == null ? null : asJsObject(e))(opts)
      ]));
}

// **************************************************************************
// Generator: JsInterfaceGenerator
// Target: abstract class _LatLng
// **************************************************************************

class LatLng extends JsInterface implements _LatLng {
  LatLng.created(JsObject o) : super.created(o);
  LatLng(num lat, num lng, [bool noWrap]) : this.created(
          new JsObject(getPath('google.maps.LatLng'), [lat, lng, noWrap]));

  bool equals(LatLng other) => asJsObject(this).callMethod(
      'equals', [((e) => e == null ? null : asJsObject(e))(other)]);
  num get lat => _lat();
  num _lat() => asJsObject(this).callMethod('lat');
  num get lng => _lng();
  num _lng() => asJsObject(this).callMethod('lng');
  String toString() => asJsObject(this).callMethod('toString');
  String toUrlValue([num precision]) =>
      asJsObject(this).callMethod('toUrlValue', [precision]);
}

// **************************************************************************
// Generator: JsInterfaceGenerator
// Target: abstract class _MapOptions
// **************************************************************************

@anonymous
class MapOptions extends JsInterface implements _MapOptions {
  MapOptions.created(JsObject o) : super.created(o);
  MapOptions() : this.created(new JsObject(context['Object']));

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
// Generator: JsInterfaceGenerator
// Target: abstract class _GEvent
// **************************************************************************

class GEvent extends JsInterface implements _GEvent {
  GEvent.created(JsObject o) : super.created(o);

  MapsEventListener addDomListener(
          dynamic instance, String eventName, Function handler,
          [bool capture]) =>
      ((e) => e == null ? null : new MapsEventListener.created(e))(
          asJsObject(this).callMethod('addDomListener', [
    toJs(instance),
    eventName,
    toJs(handler),
    capture
  ]));
  MapsEventListener addDomListenerOnce(
          dynamic instance, String eventName, Function handler,
          [bool capture]) =>
      ((e) => e == null ? null : new MapsEventListener.created(e))(
          asJsObject(this).callMethod('addDomListenerOnce', [
    toJs(instance),
    eventName,
    toJs(handler),
    capture
  ]));
  MapsEventListener addListener(
          dynamic instance, String eventName, Function handler) =>
      ((e) => e == null ? null : new MapsEventListener.created(e))(
          asJsObject(this).callMethod(
              'addListener', [toJs(instance), eventName, toJs(handler)]));
  MapsEventListener addListenerOnce(
          dynamic instance, String eventName, Function handler) =>
      ((e) => e == null ? null : new MapsEventListener.created(e))(
          asJsObject(this).callMethod(
              'addListenerOnce', [toJs(instance), eventName, toJs(handler)]));
  void clearInstanceListeners(dynamic instance) {
    asJsObject(this).callMethod('clearInstanceListeners', [toJs(instance)]);
  }
  void clearListeners(dynamic instance, String eventName) {
    asJsObject(this).callMethod('clearListeners', [toJs(instance), eventName]);
  }
  void removeListener(MapsEventListener listener) {
    asJsObject(this).callMethod('removeListener',
        [((e) => e == null ? null : asJsObject(e))(listener)]);
  }
  void trigger(
      dynamic instance, String eventName, /*@VarArgs()*/ List<dynamic> args) {
    asJsObject(this).callMethod('trigger', [
      toJs(instance),
      eventName,
      ((e) {
        if (e == null) return null;
        if (e is JsInterface) return asJsObject(e);
        return new JsArray.from(e);
      })(args)
    ]);
  }
}

// **************************************************************************
// Generator: JsInterfaceGenerator
// Target: abstract class _MapsEventListener
// **************************************************************************

class MapsEventListener extends JsInterface implements _MapsEventListener {
  MapsEventListener.created(JsObject o) : super.created(o);
}
