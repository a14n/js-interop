// GENERATED CODE - DO NOT MODIFY BY HAND
// 2015-05-04T12:19:22.269Z

part of google_maps.sample.simple;

// **************************************************************************
// Generator: JsInterfaceGenerator
// Target: abstract class _GMap
// **************************************************************************

@JsName('Map')
class GMap extends JsInterface implements _GMap {
  GMap.created(JsObject o) : super.created(o);
  GMap(Node mapDiv, [MapOptions opts]) : this.created(new JsObject(
          getPath('google.maps.Map'), [mapDiv, __codec1.encode(opts)]));
}
/// codec for MapOptions
final __codec1 =
    new JsInterfaceCodec<MapOptions>((o) => new MapOptions.created(o));

// **************************************************************************
// Generator: JsInterfaceGenerator
// Target: abstract class _LatLng
// **************************************************************************

class LatLng extends JsInterface implements _LatLng {
  LatLng.created(JsObject o) : super.created(o);
  LatLng(num lat, num lng, [bool noWrap]) : this.created(
          new JsObject(getPath('google.maps.LatLng'), [lat, lng, noWrap]));

  bool equals(LatLng other) =>
      asJsObject(this).callMethod('equals', [__codec2.encode(other)]);
  num get lat => _lat();
  num _lat() => asJsObject(this).callMethod('lat');
  num get lng => _lng();
  num _lng() => asJsObject(this).callMethod('lng');
  String toString() => asJsObject(this).callMethod('toString');
  String toUrlValue([num precision]) =>
      asJsObject(this).callMethod('toUrlValue', [precision]);
}
/// codec for LatLng
final __codec2 = new JsInterfaceCodec<LatLng>((o) => new LatLng.created(o));

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
    asJsObject(this)['center'] = __codec2.encode(_center);
  }
  LatLng get center => __codec2.decode(asJsObject(this)['center']);
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
      [bool capture]) => __codec3.decode(asJsObject(this).callMethod(
          'addDomListener', [instance, eventName, handler, capture]));
  MapsEventListener addDomListenerOnce(
      dynamic instance, String eventName, Function handler,
      [bool capture]) => __codec3.decode(asJsObject(this).callMethod(
          'addDomListenerOnce', [instance, eventName, handler, capture]));
  MapsEventListener addListener(
      dynamic instance, String eventName, Function handler) => __codec3.decode(
          asJsObject(this).callMethod(
              'addListener', [instance, eventName, handler]));
  MapsEventListener addListenerOnce(
      dynamic instance, String eventName, Function handler) => __codec3.decode(
          asJsObject(this).callMethod(
              'addListenerOnce', [instance, eventName, handler]));
  void clearInstanceListeners(dynamic instance) {
    asJsObject(this).callMethod('clearInstanceListeners', [instance]);
  }
  void clearListeners(dynamic instance, String eventName) {
    asJsObject(this).callMethod('clearListeners', [instance, eventName]);
  }
  void removeListener(MapsEventListener listener) {
    asJsObject(this).callMethod('removeListener', [__codec3.encode(listener)]);
  }
  void trigger(
      dynamic instance, String eventName, /*@VarArgs()*/ List<dynamic> args) {
    asJsObject(this).callMethod(
        'trigger', [instance, eventName, __codec4.encode(args)]);
  }
}
/// codec for MapsEventListener
final __codec3 = new JsInterfaceCodec<MapsEventListener>(
    (o) => new MapsEventListener.created(o));

/// codec for List<dynamic>
final __codec4 = new JsListCodec<dynamic>(null);

// **************************************************************************
// Generator: JsInterfaceGenerator
// Target: abstract class _MapsEventListener
// **************************************************************************

class MapsEventListener extends JsInterface implements _MapsEventListener {
  MapsEventListener.created(JsObject o) : super.created(o);
}
