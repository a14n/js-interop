// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// The js library allows Dart library authors to define Dart interfaces for
/// JavaScript objects.
library js;

import 'dart:js';

export 'dart:js';
export 'adapter/js_list.dart';
export 'util/codec.dart';

final JsObject _obj = context['Object'];

/// The base class of Dart interfaces for JavaScript objects.
abstract class JsInterface extends JsRef<JsObject> {
  JsInterface.created(JsObject o) : super.created(o);
}

/// The base class of Dart interfaces for JavaScript objects.
abstract class JsRef<T> {
  final T _value;

  JsRef.created(this._value);

  @override int get hashCode => _value.hashCode;
  @override bool operator ==(other) => other is JsRef && _value == other._value;
}

/// The base class of Dart interfaces for JavaScript objects.
abstract class JsEnum extends JsRef {
  JsEnum.created(o) : super.created(o);
}

/// Returns the underlying [JsObject] corresponding to the non nullable [o].
JsObject asJsObject(JsInterface o) => o._value;

/// Returns the underlying js value corresponding to [o] if [o] is a [JsRef]
/// (usually [JsEnumBase] or [JsInterface]). Otherwise it returns [o].
asJs(o) => o is JsRef ? o._value : o;

/// Return the [JsObject] targeted by the [path].
JsObject getPath(String path) =>
    path.split('.').fold(context, (JsObject o, p) => o[p]);

/// A metadata annotation that marks an enum as a set of values.
const jsEnum = const _JsEnum();
class _JsEnum {
  const _JsEnum();
}

/// A metadata annotation that allows to customize the name used for method call
/// or attribute access on the javascript side.
///
/// You can use it on libraries, classes, members.
class JsName {
  final String name;
  const JsName(this.name);
}


/// A metadata annotation used to indicate that the Js object is a anonymous js
/// object. That is it is created with `new Object()`.
const anonymous = const _Anonymous();
class _Anonymous {
  const _Anonymous();
}
