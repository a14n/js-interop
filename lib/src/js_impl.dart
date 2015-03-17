// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// This library contains semi-private APIs for implementing typed interfaces.
library js.impl;

import 'dart:js';
export 'dart:js' show context, JsObject;

final JsObject _obj = context['Object'];

/// The base class of Dart interfaces for JavaScript objects.
abstract class JsInterface {
  final JsObject _jsObject;

  JsInterface.created(JsObject o) : _jsObject = o;

  @override int get hashCode => _jsObject.hashCode;
  @override bool operator ==(other) =>
      other is JsInterface && _jsObject == other._jsObject;
}

JsObject asJsObject(JsInterface o) => o._jsObject;

dynamic toJs(dynamic o) => o is JsInterface ? asJsObject(o) : o;

JsObject getPath(String path) =>
    path.split('.').fold(context, (JsObject o, p) => o[p]);

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
