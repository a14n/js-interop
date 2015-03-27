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

typedef T JsInterfaceFactory<T extends JsInterface>(JsObject o);

class JsInterfaceCodec<T extends JsInterface> extends Codec<T, JsObject> {
  final Converter<JsObject, T> decoder;
  final Converter<T, JsObject> encoder = const JsInterfaceEncoder();

  JsInterfaceCodec(JsInterfaceFactory<T> factory)
      : decoder = new JsInterfaceDecoder<T>(factory);
}

class JsInterfaceEncoder<T extends JsInterface> extends Converter<T, JsObject> {
  const JsInterfaceEncoder();

  @override
  JsObject convert(T input) => input == null ? null : asJsObject(input);
}

class JsInterfaceDecoder<T extends JsInterface> extends Converter<JsObject, T> {
  final JsInterfaceFactory<T> _factory;

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

class ChainedCodec extends Codec {
  final Converter decoder;
  final Converter encoder;

  final List<_Codec> _codecs;

  ChainedCodec() : this._(<_Codec>[]);
  ChainedCodec._(List<_Codec> _codecs)
      : _codecs = _codecs,
        decoder = new ChainedConverter(_codecs, false),
        encoder = new ChainedConverter(_codecs, true);

  void add(
      Predicate acceptEncodedValue, Predicate acceptDecodedValue, Codec codec) {
    _codecs.add(new _Codec(acceptEncodedValue, acceptDecodedValue, codec));
  }
}

typedef bool Predicate(o);
class _Codec {
  Predicate acceptEncodedValue;
  Predicate acceptDecodedValue;
  Codec codec;
  _Codec(this.acceptEncodedValue, this.acceptDecodedValue, this.codec);
}

class ChainedConverter extends Converter {
  final List<_Codec> _codecs;
  final bool encoder;

  ChainedConverter(this._codecs, this.encoder);

  @override
  convert(input) {
    for (final codec in _codecs) {
      var value;
      if (encoder && codec.acceptDecodedValue(input)) {
        value = codec.codec.encode(input);
      }
      if (!encoder && codec.acceptEncodedValue(input)) {
        value = codec.codec.decode(input);
      }
      if (value != null) {
        return value;
      }
    }
    return input;
  }
}
