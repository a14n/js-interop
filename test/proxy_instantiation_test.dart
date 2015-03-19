// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library js.test.proxy_instantiation_test;

import 'dart:js' as js;

import 'package:js/js.dart';

import 'package:unittest/unittest.dart';
import 'package:unittest/html_config.dart';

part 'proxy_instantiation_test.g.dart';

abstract class _Class0 implements JsInterface {
  external factory _Class0();
}

abstract class _Class1 implements JsInterface {
  external factory _Class1(String s);
}

@JsName('Class0')
abstract class _Class0Alias implements JsInterface {
  external factory _Class0Alias();
}

@JsName('my.package.Class2')
abstract class _Class2 implements JsInterface {
  external factory _Class2();
}

main() {
  useHtmlConfiguration();

  test('Class0 should be instantiable', () {
    final o = new Class0();
    final jsO = asJsObject(o);
    expect(jsO, new isInstanceOf<js.JsObject>());
    expect(js.context.callMethod('isClass0', [jsO]), true);
  });

  test('2 Class0 should be equals and have the same hashcode', () {
    final jsO = new js.JsObject(js.context['Class0']);
    final o1 = new Class0.created(jsO);
    final o2 = new Class0.created(jsO);
    expect(o1 == o2, true);
    expect(o1.hashCode == o2.hashCode, true);
  });

  test('Class1 should be instantiable with 1 argument', () {
    final o = new Class1('test');
    final jsO = asJsObject(o);
    expect(js.context.callMethod('isClass1', [jsO]), true);
    expect(jsO.callMethod('getValue'), 'test');
  });

  test('Class0Alias should create a Class0 js object', () {
    final o = new Class0Alias();
    final jsO = asJsObject(o);
    expect(jsO, new isInstanceOf<js.JsObject>());
    expect(js.context.callMethod('isClass0', [jsO]), true);
  });

  test('Class0Alias and Class0 should be equals is proxyfiing the same js', () {
    final jsO = new js.JsObject(js.context['Class0']);
    final o1 = new Class0.created(jsO);
    final o2 = new Class0Alias.created(jsO);
    expect(o1 == o2, true);
    expect(o1.hashCode == o2.hashCode, true);
  });

  test('Class2 should create a my.package.Class2 js object', () {
    final o = new Class2();
    final jsO = asJsObject(o);
    expect(jsO, new isInstanceOf<js.JsObject>());
    expect(js.context.callMethod('isClass2', [jsO]), true);
  });
}
