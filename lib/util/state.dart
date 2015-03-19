// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library js.util.state;

import 'package:js/js.dart';

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
