// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/**
 * This library contains the annotations used in js.dart separately so they can
 * be imported into the VM.
 */
library js.metadata;

/**
 * A metadata annotation that marks a class as a proxy implementation for a
 * JsInterface.
 *
 * Classes annotated with @JsProxy() are transformed to add an impementation of
 * all abstract methods defined on superclasses that extend JsInterface.
 */
class JsProxy {
  final bool anonymousObject;
  final String constructor;
  const JsProxy._(this.anonymousObject, this.constructor);
  const JsProxy({String constructor}) : this._(false, constructor);
  const JsProxy.anonymous() : this._(true, null);
}

class JsGlobal {
  const JsGlobal();
}

/// A metadata annotation that allows to customize the name used for method call
/// or attribute access on the javascript side.
class JsName {
  final String name;
  const JsName(this.name);
}
