// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library js.js_expando;

import 'dart:js';

import 'package:js/js.dart';

/**
 * A [JsExpando] allows access to a JavaScript property of browser objects in a
 * type-safe way.
 *
 * A [JsExpando] has a fixed [name] and property type [T]. Property
 * values are converted to and from JavaScript with [toDart] and [toJs].
 */
class JsExpando<T> implements Expando<T> {
  static final JsObject _obj = context['Object'];

  final String name;

  JsExpando(this.name);

  /**
   * Returns the value of [name] for the JavaScript object corresponding
   * to [object]. The value is converted to Dart with [toDart].
   */
  T operator [](Object object) {
    var jso = (object is JsObject) ? object
        : new JsObject.fromBrowserObject(object);
    return toDart(jso[name]) as T;
  }

  /**
   * Sets the value of [name] to [value] for the JavaScript object
   * corresponding to [object]. The value is converted to JavaScript with
   * [toJs].
   */
  void operator []=(Object object, T value) {
    var jso = (object is JsObject) ? object
        : new JsObject.fromBrowserObject(object);
    if (value == null) jso.deleteProperty(name);
    else {
      _obj.callMethod('defineProperty', [jso, name, new JsObject(_obj)
        ..['configurable'] = true
        ..['value'] = toJs(value)]);
    }
  }
}
