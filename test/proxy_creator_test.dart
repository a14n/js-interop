// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library js.test.proxy_creator_test;

import 'package:unittest/unittest.dart';
import 'package:js/proxy_creator.dart';

main() {
  group('Proxy creation', () {

    test('should accept simple name', () {
      expect(createProxySkeleton('MyClass'), '''
@JsName('MyClass')
abstract class _MyClass implements JsInterface {
  external factory _MyClass();
}''');
    });

    test('should accept qualified name', () {
      expect(createProxySkeleton('a.b.MyClass'), '''
@JsName('a.b.MyClass')
abstract class _MyClass implements JsInterface {
  external factory _MyClass();
}''');
    });

  });
}
