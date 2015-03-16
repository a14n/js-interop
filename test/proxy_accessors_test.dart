// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library js.test.proxy_instantiation_test;

import 'dart:mirrors';

import 'package:js/js.dart';

import 'package:unittest/unittest.dart';
import 'package:unittest/html_config.dart';

part 'proxy_accessors_test.g.dart';

@JsProxy()
abstract class _Class0 {
  factory _Class0() = dynamic;

  final int i;
  final double d;
  final String s;
  final bool b;
}

@JsProxy(constructor: 'Class0')
abstract class _ClassFinalField {
  factory _ClassFinalField() = dynamic;

  final int i;
}

@JsProxy(constructor: 'Class0')
abstract class _ClassNotFinalField {
  factory _ClassNotFinalField() = dynamic;

  int i;
}

@JsProxy(constructor: 'Class0')
abstract class _ClassPrivateField {
  factory _ClassPrivateField() = dynamic;

  int _i;
}

@JsProxy(constructor: 'Class0')
abstract class _ClassRenamedField {
  factory _ClassRenamedField() = dynamic;

  @JsName('i')
  int iBis;
}

@JsProxy(constructor: 'Class0')
abstract class _ClassRenamedPrivateField {
  factory _ClassRenamedPrivateField() = dynamic;

  @JsName('i')
  int _iBis;
}

@JsProxy(constructor: 'Class0')
abstract class _ClassWithGetter {
  factory _ClassWithGetter() = dynamic;

  int get i;
}

@JsProxy(constructor: 'Class0')
abstract class _ClassWithSetter {
  factory _ClassWithSetter() = dynamic;

  set i(int i);
}

@JsProxy(constructor: 'Class0')
abstract class _ClassWithPrivateGetter {
  factory _ClassWithPrivateGetter() = dynamic;

  int get _i;
}

@JsProxy(constructor: 'Class0')
abstract class _ClassWithPrivateSetter {
  factory _ClassWithPrivateSetter() = dynamic;

  set _i(int i);
}

@JsProxy(constructor: 'Class0')
abstract class _ClassWithRenamedGetter {
  factory _ClassWithRenamedGetter() = dynamic;

  @JsName('i')
  int get iBis;
}

@JsProxy(constructor: 'Class0')
abstract class _ClassWithRenamedSetter {
  factory _ClassWithRenamedSetter() = dynamic;

  @JsName('i')
  set iBis(int i);
}

main() {
  useHtmlConfiguration();

  test('int fields are supported', () {
    final o = new Class0();
    expect(o.i, 1);
  });

  test('double fields are supported', () {
    final o = new Class0();
    expect(o.d, 1.2);
  });

  test('String fields are supported', () {
    final o = new Class0();
    expect(o.s, 's');
  });

  test('bool fields are supported', () {
    final o = new Class0();
    expect(o.b, true);
  });

  test('final fields should generate getter but not setter', () {
    final clazz = reflectClass(ClassFinalField);
    expect(clazz.declarations.keys, contains(#i));
    expect(clazz.declarations.keys, isNot(contains(const Symbol('i='))));
  });

  test('fields (not final) should generate getter and setter', () {
    final clazz = reflectClass(ClassNotFinalField);
    expect(clazz.declarations.keys, contains(#i));
    expect(clazz.declarations.keys, contains(const Symbol('i=')));
  });

  test('private field should be mapped to public name', () {
    final clazz = reflectClass(ClassPrivateField);
    expect(clazz.declarations.keys, isNot(contains(#i)));
    expect(clazz.declarations.keys, isNot(contains(const Symbol('i='))));

    final o = new ClassPrivateField();
    expect(o._i, 1);
    o._i = 2;
    expect(asJsObject(o)['i'], 2);
  });

  test('a field should call with the name provided by JsName', () {
    final clazz = reflectClass(ClassRenamedField);
    expect(clazz.declarations.keys, isNot(contains(#i)));
    expect(clazz.declarations.keys, isNot(contains(const Symbol('i='))));

    final o = new ClassRenamedField();
    expect(o.iBis, 1);
    o.iBis = 2;
    expect(asJsObject(o)['i'], 2);
    expect(asJsObject(o).hasProperty('iBis'), false);
  });

  test('a private field should call with the name provided by JsName', () {
    final clazz = reflectClass(ClassRenamedPrivateField);
    expect(clazz.declarations.keys, isNot(contains(#i)));
    expect(clazz.declarations.keys, isNot(contains(const Symbol('i='))));

    final o = new ClassRenamedPrivateField();
    expect(o._iBis, 1);
    o._iBis = 2;
    expect(asJsObject(o)['i'], 2);
  });

  test('ClassWithGetter should have getter but not setter', () {
    final clazz = reflectClass(ClassWithGetter);
    expect(clazz.declarations.keys, contains(#i));
    expect(clazz.declarations.keys, isNot(contains(const Symbol('i='))));

    final o = new ClassWithGetter();
    expect(o.i, 1);
  });

  test('ClassWithSetter should have setter but not getter', () {
    final clazz = reflectClass(ClassWithSetter);
    expect(clazz.declarations.keys, isNot(contains(#i)));
    expect(clazz.declarations.keys, contains(const Symbol('i=')));

    final o = new ClassWithSetter();
    o.i = 2;
    expect(asJsObject(o)['i'], 2);
  });

  test('private getter should be mapped to public name', () {
    final o = new ClassWithPrivateGetter();
    expect(o._i, 1);
  });

  test('private setter should be mapped to public name', () {
    final o = new ClassWithPrivateSetter();
    o._i = 2;
    expect(asJsObject(o)['i'], 2);
  });

  test('private getter should call with the name provided by JsName', () {
    final o = new ClassWithRenamedGetter();
    expect(o.iBis, 1);
  });

  test('private setter should call with the name provided by JsName', () {
    final o = new ClassWithRenamedSetter();
    o.iBis = 2;
    expect(asJsObject(o)['i'], 2);
  });
}
