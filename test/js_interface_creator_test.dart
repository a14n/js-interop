// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library js.test.proxy_creator_test;

import 'package:unittest/unittest.dart';
import 'package:js/js_interface_creator.dart';

main() {
  group('JsInterface creation', () {
    test('should accept simple name', () {
      expect(createInterfaceSkeleton('MyClass'), '''
@JsName('MyClass')
abstract class _MyClass implements JsInterface {
  external factory _MyClass();
}''');
    });

    test('should accept qualified name', () {
      expect(createInterfaceSkeleton('a.b.MyClass'), '''
@JsName('a.b.MyClass')
abstract class _MyClass implements JsInterface {
  external factory _MyClass();
}''');
    });
  });
}
