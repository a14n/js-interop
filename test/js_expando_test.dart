// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library js.test.js_expando_test;

import 'dart:html';
import 'dart:js' as js;

// these imports instead of js.dart so the transformer doesn't kick in and
// remove mirrors
import 'package:js/js.dart';
import 'package:js/util/codec.dart';
import 'package:js/util/js_expando.dart';

import 'package:unittest/unittest.dart';
import 'package:unittest/html_config.dart';

part 'js_expando_test.g.dart';

main() {
  useHtmlConfiguration();

  group('JsExpando', () {
    test('should access a JS simple property', () {
      var expando = new JsExpando<String>('foo');
      expect(expando[window], null);
      expando[window] = 'bar';
      expect(expando[window], 'bar');
      // reset global state
      expando[window] = null;
    });

    test('should access a JS simple property', () {
      var expando = new JsExpando<Foo>(
          'foo', new JsInterfaceCodec((o) => new Foo.created(o)));
      var foo = new Foo();
      expect(expando[window], null);
      expando[window] = foo;
      expect((js.context['foo'] as JsObject).instanceof(js.context['Foo']),
          isTrue);
      expect(expando[window], equals(foo));
    });
  });
}

abstract class _Foo implements JsInterface {
  external factory _Foo();
}
