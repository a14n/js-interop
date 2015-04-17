// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library js.test.proxy_methods_test;

import 'dart:mirrors';

import 'package:js/js.dart';

import 'package:unittest/unittest.dart';
import 'package:unittest/html_config.dart';

part 'proxy_methods_test.g.dart';

abstract class _Class0 implements JsInterface {
  external factory _Class0();

  int getI();
  void setI(int i);
}

@JsName('Class0')
abstract class _ClassPrivateMethod implements JsInterface {
  external factory _ClassPrivateMethod();

  int _getI();
}

@JsName('Class0')
abstract class _ClassRenamedMethod implements JsInterface {
  external factory _ClassRenamedMethod();

  @JsName('getI')
  int getIBis();
}

@JsName('Class0')
abstract class _ClassRenamedPrivateMethod implements JsInterface {
  external factory _ClassRenamedPrivateMethod();

  @JsName('getI')
  int _getIBis();
}

main() {
  useHtmlConfiguration();

  test('int are supported as return value', () {
    final o = new Class0();
    expect(o.getI(), 1);
  });

  test('int are supported as method param', () {
    final o = new Class0();
    o.setI(2);
    expect(asJsObject(o)['i'], 2);
  });

  test('private field should be mapped to public name', () {
    final clazz = reflectClass(ClassPrivateMethod);
    expect(clazz.declarations.keys, isNot(contains(#getI)));

    final o = new ClassPrivateMethod();
    expect(o._getI(), 1);
  });

  test('a method should call with the name provided by JsName', () {
    final clazz = reflectClass(ClassRenamedMethod);
    expect(clazz.declarations.keys, isNot(contains(#getI)));

    final o = new ClassRenamedMethod();
    expect(o.getIBis(), 1);
  });

  test('a private method should call with the name provided by JsName', () {
    final clazz = reflectClass(ClassRenamedPrivateMethod);
    expect(clazz.declarations.keys, isNot(contains(#getI)));

    final o = new ClassRenamedPrivateMethod();
    expect(o._getIBis(), 1);
  });
}
