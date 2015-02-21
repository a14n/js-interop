// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/**
 * The js library allows Dart library authors to export their APIs to JavaScript
 * and to define Dart interfaces for JavaScript objects.
 */
library js;

export 'dart:js' show JsObject, context;

export 'package:js/src/js_impl.dart' show JsInterface, JsGlobal, toJs, toDart,
    registerJsConstructorForType, registerFactoryForJsConstructor, getPath;
export 'package:js/src/js_expando.dart' show JsExpando;
export 'package:js/src/js_list.dart' show JsList;
export 'package:js/src/js_map.dart' show JsMap;
export 'package:js/src/metadata.dart';
