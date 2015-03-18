@JsName('google.maps')
library google_maps.sample.simple;

import 'dart:html';
import 'package:js/js.dart';

part 'page.g.dart';


@JsName('Map')
@JsProxy()
abstract class _GMap {
  factory _GMap(Node mapDiv, [MapOptions opts]) = dynamic;
}

@JsProxy()
abstract class _LatLng extends JsInterface {
  factory _LatLng(num lat, num lng, [bool noWrap]) = dynamic;

  bool equals(LatLng other);
  num get lat => asJsObject(this).callMethod('lat');
  num get lng => asJsObject(this).callMethod('lng');
  String toString();
  String toUrlValue([num precision]);
}

@JsProxy.anonymous()
abstract class _MapOptions {
  factory _MapOptions() = dynamic;
  int zoom;
  LatLng center;
  String mapTypeId;
}

class MapTypeId {
  static final String HYBRID = getPath('google.maps.MapTypeId')['HYBRID'];
  static final String ROADMAP = getPath('google.maps.MapTypeId')['ROADMAP'];
  static final String SATELLITE = getPath('google.maps.MapTypeId')['SATELLITE'];
  static final String TERRAIN = getPath('google.maps.MapTypeId')['TERRAIN'];
}

final GEvent event = new GEvent();

@JsName('event')
@JsProxy.anonymous()
abstract class _GEvent {
  MapsEventListener addDomListener(dynamic instance, String eventName, Function handler, [bool capture]);
  MapsEventListener addDomListenerOnce(dynamic instance, String eventName, Function handler, [bool capture]);
  MapsEventListener addListener(dynamic instance, String eventName, Function handler);
  MapsEventListener addListenerOnce(dynamic instance, String eventName, Function handler);
  void clearInstanceListeners(dynamic instance);
  void clearListeners(dynamic instance, String eventName);
  void removeListener(MapsEventListener listener);
  void trigger(dynamic instance, String eventName, /*@VarArgs()*/ List<dynamic> args);
}

@JsProxy.anonymous()
abstract class _MapsEventListener {
}


void main() {
  final mapOptions = new MapOptions()
    ..zoom = 8
    ..center = new LatLng(-34.397, 150.644)
    ..mapTypeId = MapTypeId.ROADMAP
    ;
  var map = new GMap(querySelector("#map_canvas"), mapOptions);
  event.addListener(map, "zoom_changed", () => print(asJsObject(map).callMethod('getZoom')));
}
