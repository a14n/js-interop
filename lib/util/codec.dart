// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library js.util.codec;

import 'dart:convert';
export 'dart:convert' show Codec;

import 'package:js/js.dart';

class IdentityCodec<T> extends Codec<T, T> {
  final Converter<T, T> decoder = const IdentityConverter();
  final Converter<T, T> encoder = const IdentityConverter();

  const IdentityCodec();
}

class IdentityConverter<T> extends Converter<T, T> {
  const IdentityConverter();

  @override
  T convert(T input) => input;
}

typedef JsInterface JsInterfaceFactory(JsObject o);

class JsInterfaceCodec<T extends JsInterface> extends Codec<T, JsObject> {
  final Converter<JsObject, T> decoder;
  final Converter<T, JsObject> encoder = const JsInterfaceEncoder();

  JsInterfaceCodec(JsInterfaceFactory factory)
      : decoder = new JsInterfaceDecoder<T>(factory);
}

class JsInterfaceEncoder<T extends JsInterface> extends Converter<T, JsObject> {
  const JsInterfaceEncoder();

  @override
  JsObject convert(T input) => input == null ? null : asJsObject(input);
}

class JsInterfaceDecoder<T extends JsInterface> extends Converter<JsObject, T> {
  final JsInterfaceFactory _factory;

  JsInterfaceDecoder(this._factory);

  @override
  T convert(JsObject input) => input == null ? null : _factory(input);
}

class BiMapCodec<S, T> extends Codec<S, T> {
  final Converter<T, S> decoder;
  final Converter<S, T> encoder;

  BiMapCodec(Map<S, T> map)
      : decoder = new BiMapConverter<T, S>(
          new Map<T, S>.fromIterables(map.values, map.keys)),
        encoder = new BiMapConverter<S, T>(map);
}

class BiMapConverter<S, T> extends Converter<S, T> {
  final Map<S, T> _map;

  BiMapConverter(this._map);

  @override
  T convert(S input) => _map[input];
}

class ChainedCodec<S, T> extends Codec<S, T> {
  final Converter<T, S> decoder;
  final Converter<S, T> encoder;

  ChainedCodec(List<Codec<S, T>> codecs)
      : decoder = new ChainedConverter<T, S>(codecs.map((c) => c.decoder)),
        encoder = new ChainedConverter<S, T>(codecs.map((c) => c.encoder));
}
class ChainedConverter<S, T> extends Converter<S, T> {
  final Iterable<Converter<S, T>> _converters;

  ChainedConverter(this._converters);

  @override
  T convert(S input) {
    for (final converter in _converters) {
      try {
        final converted = converter.convert(input);
        if (converted != null) return converted;
      } on CastError {}
    }
    throw new StateError('no converter to handle $input');
  }
}
