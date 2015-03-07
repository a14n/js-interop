library google_maps.sample.simple;

import 'dart:html';
import 'package:js/js.dart';

part 'page.g.dart';

@JsProxy(constructor: 'google.maps.Map')
abstract class _GMap {
  factory _GMap(Node mapDiv, [MapOptions opts]) = dynamic;
}

@JsProxy(constructor: 'google.maps.LatLng')
abstract class _LatLng extends JsInterface {
  factory _LatLng(num lat, num lng, [bool noWrap]) = dynamic;

  bool equals(LatLng other);
  num get lat => unwrap(this).callMethod('lat');
  num get lng => unwrap(this).callMethod('lng');
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

void main() {
  initializeJavaScript();

  final mapOptions = new MapOptions()
    ..zoom = 8
    ..center = new LatLng(-34.397, 150.644)
    ..mapTypeId = MapTypeId.ROADMAP
    ;
  new GMap(querySelector("#map_canvas"), mapOptions);
}
