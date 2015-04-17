// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

@JsName('a')
library js.test.namespaced_library_test;

import 'dart:js' as js;

import 'package:js/js.dart';

import 'package:unittest/unittest.dart';
import 'package:unittest/html_config.dart';

part 'namespaced_library_test.g.dart';

abstract class _Class0 implements JsInterface {
  external factory _Class0();
}

@JsName('b.Class1')
abstract class _Class1 implements JsInterface {
  external factory _Class1();
}

main() {
  useHtmlConfiguration();

  test('a.Class0 should be instantiable', () {
    final o = new Class0();
    final jsO = asJsObject(o);
    expect(jsO, new isInstanceOf<js.JsObject>());
    expect(js.context.callMethod('isClass0', [jsO]), true);
  });

  test('a.b.Class1 should be instantiable', () {
    final o = new Class1();
    final jsO = asJsObject(o);
    expect(jsO, new isInstanceOf<js.JsObject>());
    expect(js.context.callMethod('isClass1', [jsO]), true);
  });
}
