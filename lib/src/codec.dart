import 'dart:convert';

import 'js_impl.dart';

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
  JsInterfaceFactory _factory;

  JsInterfaceDecoder(this._factory);

  @override
  T convert(JsObject input) => input == null ? null : _factory(input);
}
