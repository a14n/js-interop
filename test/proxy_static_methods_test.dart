// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
@TestOn("browser")
library js.test.proxy_static_methods_test;

import 'dart:mirrors';

import 'package:js/js.dart';

import 'package:test/test.dart';

part 'proxy_static_methods_test.g.dart';

abstract class _Class0 implements JsInterface {
  external static int getI();
  external static void setI(int i);
  external factory _Class0();
}

@JsName('Class0')
abstract class _ClassPrivateMethod implements JsInterface {
  external static int _getI();
  external factory _ClassPrivateMethod();
}

@JsName('Class0')
abstract class _ClassRenamedMethod implements JsInterface {
  @JsName('getI')
  external static int getIBis();
  external factory _ClassRenamedMethod();
}

@JsName('Class0')
abstract class _ClassRenamedPrivateMethod implements JsInterface {
  @JsName('getI')
  external static int _getIBis();
  external factory _ClassRenamedPrivateMethod();
}

main() {
  setUp((){
    context['Class0']['i'] = 1;
  });

  test('int are supported as return value', () {
    expect(Class0.getI(), 1);
  });

  test('int are supported as method param', () {
    Class0.setI(2);
    expect(context['Class0']['i'], 2);
  });

  test('private field should be mapped to public name', () {
    final clazz = reflectClass(ClassPrivateMethod);
    expect(clazz.declarations.keys, isNot(contains(#getI)));

    expect(ClassPrivateMethod._getI(), 1);
  });

  test('a method should call with the name provided by JsName', () {
    final clazz = reflectClass(ClassRenamedMethod);
    expect(clazz.declarations.keys, isNot(contains(#getI)));

    expect(ClassRenamedMethod.getIBis(), 1);
  });

  test('a private method should call with the name provided by JsName', () {
    final clazz = reflectClass(ClassRenamedPrivateMethod);
    expect(clazz.declarations.keys, isNot(contains(#getI)));

    expect(ClassRenamedPrivateMethod._getIBis(), 1);
  });
}
