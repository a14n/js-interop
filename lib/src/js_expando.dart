// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library js.js_expando;

import 'dart:convert';

import 'package:js/js.dart' show JsObject;
import 'codec.dart';

/**
 * A [JsExpando] allows access to a JavaScript property of browser objects in a
 * type-safe way.
 *
 * A [JsExpando] has a fixed [propertyName] and property type [T]. Property
 * values are converted to and from JavaScript with [toDart] and [toJs].
 */
class JsExpando<T> {
  final String propertyName;
  final Codec<T, dynamic> _codec;

  JsExpando(this.propertyName, [this._codec = const IdentityCodec()]);

  /**
   * Returns the value of [propertyName] for the JavaScript object corresponding
   * to [object]. The value is converted to Dart with [toDart].
   */
  T operator [](Object object) {
    var jso = (object is JsObject) ? object
        : new JsObject.fromBrowserObject(object);
    return _codec.decode(jso[propertyName]);
  }

  /**
   * Sets the value of [propertyName] to [value] for the JavaScript object
   * corresponding to [object]. The value is converted to JavaScript with
   * [toJs].
   */
  void operator []=(Object object, T value) {
    var jso = (object is JsObject) ? object
        : new JsObject.fromBrowserObject(object);
    jso[propertyName] = _codec.encode(value);
  }
}
