// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// The js library allows Dart library authors to define Dart interfaces for
/// JavaScript objects.
library js;

import 'dart:js';

export 'dart:js';
export 'adapter/js_list.dart';
export 'util/codec.dart' show JsInterfaceCodec;

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

/// A metadata annotation that mark an enum as a set of values.
class JsEnum<T> {
  final Map<T, String> names;
  const JsEnum({this.names});
}

/// A metadata annotation that allows to customize the name used for method call
/// or attribute access on the javascript side.
class JsName {
  final String name;
  const JsName(this.name);
}

class _Anonymous {
  const _Anonymous();
}

/// This means that the Js object is a anonymous js object. That is it is
/// created with `new Object()`.
const _Anonymous anonymous = const _Anonymous();
