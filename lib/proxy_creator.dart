// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library js.proxy_creator;

String createProxySkeleton(String name) {
  final className = '_' + name.substring(name.lastIndexOf('.') + 1);
  return '''
@JsProxy(constructor: '$name')
abstract class $className {
}''';
}
