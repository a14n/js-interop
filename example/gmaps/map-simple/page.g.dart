// GENERATED CODE - DO NOT MODIFY BY HAND
// 2015-05-11T21:26:18.188Z

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
    asJsObject(this)['mapTypeId'] = __codec3.encode(_mapTypeId);
  }
  MapTypeId get mapTypeId => __codec3.decode(asJsObject(this)['mapTypeId']);
}
/// codec for MapTypeId
final __codec3 = new BiMapCodec<MapTypeId, dynamic>(
    new Map<MapTypeId, dynamic>.fromIterable(MapTypeId.values, value: asJs));

// **************************************************************************
// Generator: JsInterfaceGenerator
// Target: class _MapTypeId
// **************************************************************************

class MapTypeId extends JsEnumBase {
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
      [bool capture]) => __codec5.decode(asJsObject(this).callMethod(
          'addDomListener', [
    __codec4.encode(instance),
    eventName,
    handler,
    capture
  ]));
  MapsEventListener addDomListenerOnce(
      dynamic instance, String eventName, Function handler,
      [bool capture]) => __codec5.decode(asJsObject(this).callMethod(
          'addDomListenerOnce', [
    __codec4.encode(instance),
    eventName,
    handler,
    capture
  ]));
  MapsEventListener addListener(
      dynamic instance, String eventName, Function handler) => __codec5.decode(
          asJsObject(this).callMethod(
              'addListener', [__codec4.encode(instance), eventName, handler]));
  MapsEventListener addListenerOnce(
      dynamic instance, String eventName, Function handler) => __codec5
      .decode(asJsObject(this).callMethod(
          'addListenerOnce', [__codec4.encode(instance), eventName, handler]));
  void clearInstanceListeners(dynamic instance) {
    asJsObject(this).callMethod(
        'clearInstanceListeners', [__codec4.encode(instance)]);
  }
  void clearListeners(dynamic instance, String eventName) {
    asJsObject(this).callMethod(
        'clearListeners', [__codec4.encode(instance), eventName]);
  }
  void removeListener(MapsEventListener listener) {
    asJsObject(this).callMethod('removeListener', [__codec5.encode(listener)]);
  }
  void trigger(
      dynamic instance, String eventName, /*@VarArgs()*/ List<dynamic> args) {
    asJsObject(this).callMethod('trigger', [
      __codec4.encode(instance),
      eventName,
      __codec6.encode(args)
    ]);
  }
}
/// codec for dynamic
final __codec4 = new DynamicCodec();

/// codec for MapsEventListener
final __codec5 = new JsInterfaceCodec<MapsEventListener>(
    (o) => new MapsEventListener.created(o));

/// codec for List<dynamic>
final __codec6 = new JsListCodec<dynamic>(__codec4);

// **************************************************************************
// Generator: JsInterfaceGenerator
// Target: abstract class _MapsEventListener
// **************************************************************************

class MapsEventListener extends JsInterface implements _MapsEventListener {
  MapsEventListener.created(JsObject o) : super.created(o);
}
