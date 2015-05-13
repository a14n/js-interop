// GENERATED CODE - DO NOT MODIFY BY HAND
// 2015-05-13T16:50:14.017Z

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

  num _getZoom() => asJsObject(this).callMethod('getZoom');
  num get zoom => _getZoom();
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
  void set mapTypeId(MapTypeId _mapTypeId) {
    asJsObject(this)['mapTypeId'] = _mapTypeId;
  }
  MapTypeId get mapTypeId => asJsObject(this)['mapTypeId'];
}

// **************************************************************************
// Generator: JsInterfaceGenerator
// Target: class _MapTypeId
// **************************************************************************

class MapTypeId extends JsEnum {
  static final values = <MapTypeId>[HYBRID, ROADMAP, SATELLITE, TERRAIN];
  static final HYBRID =
      new MapTypeId._(getPath('google.maps.MapTypeId')['HYBRID']);
  static final ROADMAP =
      new MapTypeId._(getPath('google.maps.MapTypeId')['ROADMAP']);
  static final SATELLITE =
      new MapTypeId._(getPath('google.maps.MapTypeId')['SATELLITE']);
  static final TERRAIN =
      new MapTypeId._(getPath('google.maps.MapTypeId')['TERRAIN']);
  MapTypeId._(o) : super.created(o);
}

// **************************************************************************
// Generator: JsInterfaceGenerator
// Target: abstract class _GEvent
// **************************************************************************

class GEvent extends JsInterface implements _GEvent {
  GEvent.created(JsObject o) : super.created(o);

  MapsEventListener addDomListener(
      dynamic instance, String eventName, Function handler,
      [bool capture]) => __codec4.decode(asJsObject(this).callMethod(
          'addDomListener', [
    __codec3.encode(instance),
    eventName,
    handler,
    capture
  ]));
  MapsEventListener addDomListenerOnce(
      dynamic instance, String eventName, Function handler,
      [bool capture]) => __codec4.decode(asJsObject(this).callMethod(
          'addDomListenerOnce', [
    __codec3.encode(instance),
    eventName,
    handler,
    capture
  ]));
  MapsEventListener addListener(
      dynamic instance, String eventName, Function handler) => __codec4.decode(
          asJsObject(this).callMethod(
              'addListener', [__codec3.encode(instance), eventName, handler]));
  MapsEventListener addListenerOnce(
      dynamic instance, String eventName, Function handler) => __codec4
      .decode(asJsObject(this).callMethod(
          'addListenerOnce', [__codec3.encode(instance), eventName, handler]));
  void clearInstanceListeners(dynamic instance) {
    asJsObject(this).callMethod(
        'clearInstanceListeners', [__codec3.encode(instance)]);
  }
  void clearListeners(dynamic instance, String eventName) {
    asJsObject(this).callMethod(
        'clearListeners', [__codec3.encode(instance), eventName]);
  }
  void removeListener(MapsEventListener listener) {
    asJsObject(this).callMethod('removeListener', [__codec4.encode(listener)]);
  }
  void trigger(
      dynamic instance, String eventName, /*@VarArgs()*/ List<dynamic> args) {
    asJsObject(this).callMethod('trigger', [
      __codec3.encode(instance),
      eventName,
      __codec5.encode(args)
    ]);
  }
}
/// codec for dynamic
final __codec3 = new DynamicCodec();

/// codec for MapsEventListener
final __codec4 = new JsInterfaceCodec<MapsEventListener>(
    (o) => new MapsEventListener.created(o));

/// codec for List<dynamic>
final __codec5 = new JsListCodec<dynamic>(__codec3);

// **************************************************************************
// Generator: JsInterfaceGenerator
// Target: abstract class _MapsEventListener
// **************************************************************************

class MapsEventListener extends JsInterface implements _MapsEventListener {
  MapsEventListener.created(JsObject o) : super.created(o);
}
