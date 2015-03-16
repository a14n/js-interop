// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// This library contains semi-private APIs for implementing typed interfaces.
library js.impl;

import 'dart:js';
import 'package:js/src/js_list.dart';
import 'dart:collection';
export 'dart:js' show context, JsObject;

JsObject _obj = context['Object'];

/// The base class of Dart interfaces for JavaScript objects.
abstract class JsInterface {
  final JsObject _jsObject;

  JsInterface.created(JsObject o) : _jsObject = o;

  @override int get hashCode => _jsObject.hashCode;
  @override bool operator ==(other) =>
      other is JsInterface && _jsObject == other._jsObject;
}

JsObject asJsObject(JsInterface o) => o._jsObject;

Expando<Map<Symbol, dynamic>> _STATE = new Expando();

/// takes JsInterface|JsObject as parameter
Map<Symbol, dynamic> getState(o) {
  if (o is JsInterface) o = asJsObject(o);
  var state = _STATE[o];
  if (state == null) {
    state = <Symbol, dynamic>{};
    _STATE[o] = state;
  }
  return state;
}

/**
 * Converts a Dart object to a [JsObject] (or supported primitive) for sending
 * to JavaScript. [o] must be either a [JsInterface] or an exported Dart object.
 */
dynamic toJs(dynamic o) {
  if (o == null) return o;
  if (o is num ||
      o is String ||
      o is bool ||
      o is DateTime ||
      o is JsObject) return o;

  if (o is JsInterface) return asJsObject(o);

  return o;
}

/**
 * Converts a JS value (primitive or [JsObject]) to Dart.
 *
 * If [o] is a JS object with a associated Dart proxy class, an instance of that
 * proxy class is returned. If [o] is an exported Dart object, the original
 * Dart object is returned. The Dart object is stored as a reference on the
 * JS object so that the same Dart object is returned from subsequent calls
 * to [toDart].
 */
dynamic toDart(dynamic o) {
  if (o == null) return o;

  if (o is JsObject) {
    var wrapper;
    if (o is JsArray) {
      wrapper = new JsList.created(o);
    } else {
      // look up JsInterface factory
      var jsConstructor = o['constructor'] as JsFunction;
      var dartConstructor = _interfaceConstructors[jsConstructor];
      if (dartConstructor != null) {
        wrapper = dartConstructor(o);
      }
    }
    if (wrapper != null) return wrapper;
  }

  return o;
}

dynamic jsify(data) {
  if ((data is! Map) && (data is! Iterable)) {
    throw new ArgumentError("object must be a Map or Iterable, was $data");
  }

  if (data is JsObject) return data;

  var _convertedObjects = new HashMap.identity();

  _convert(o) {
    if (_convertedObjects.containsKey(o)) {
      return _convertedObjects[o];
    }

    if (o is JsInterface) {
      return asJsObject(o);
    } else if (o is Map) {
      final convertedMap = new JsObject(_obj);
      _convertedObjects[o] = convertedMap;
      for (var key in o.keys) {
        convertedMap[key] = _convert(o[key]);
      }
      return convertedMap;
    } else if (o is Iterable) {
      var convertedList = new JsArray();
      _convertedObjects[o] = convertedList;
      convertedList.addAll(o.map(_convert));
      return convertedList;
    } else {
      return toJs(o);
    }
  }

  return _convert(data);
}

// Dart Type -> JS constructorfor proxy
final Map<JsFunction, InterfaceFactory> _interfaceConstructors =
    <JsFunction, InterfaceFactory>{};

typedef JsInterface InterfaceFactory(JsObject o);

void registerFactoryForJsConstructor(
    JsFunction constructor, InterfaceFactory factory) {
  _interfaceConstructors[constructor] = factory;
}

JsObject getPath(String path) =>
    path.split('.').fold(context, (JsObject o, p) => o[p]);
