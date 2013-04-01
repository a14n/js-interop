// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library js.wrapping;

import 'package:meta/meta.dart';

class LibConfig {
  final String partOf;
  final String fileHeader;
  LibConfig({this.partOf, this.fileHeader});
}

class TypedProxy {
  final String name;
  final String extendsFrom;
  final constructors = <Constructor>[];
  final getters = <Getter>[];
  final setters = <Setter>[];
  final methods = <Method>[];
  final customs = <String>[];

  TypedProxy(this.name, {this.extendsFrom});

  void addConstructor({String name, String functionName, List<Parameter> params}) {
    constructors.add(new Constructor(this, name, functionName, params));
  }

  void addProperty(dynamic type, String name) {
    addGetter(type, name);
    addSetter(type, name);
  }
  void addGetter(dynamic type, String name) {
    getters.add(new Getter(type, name));
  }
  void addSetter(dynamic type, String name) {
    setters.add(new Setter(type, name));
  }
  void addMethod(dynamic returnType, String name, [List<Parameter> params]) {
    methods.add(new Method(returnType, name, params));
  }
  void addCustom(String content){
    customs.add(content);
  }

  String generateAsString([LibConfig libConfig]) {
    final r = new StringBuffer();
    if (libConfig != null && libConfig.fileHeader != null) {
      r.writeln(libConfig.fileHeader);
    }
    if (libConfig != null && libConfig.partOf != null) {
      r.writeln("part of ${libConfig.partOf};");
    } else {
      r.writeln("import 'package:js/js.dart' as js;");
      r.writeln("import 'package:js/js_wrapping.dart' as jsw;");
    }
    r.writeln();
    r.write("class $name extends ");
    if (extendsFrom != null) {
      r.write(extendsFrom);
    } else {
      r.write("jsw.TypedProxy");
    }
    r.writeln(" {");
    r.writeln("  static $name cast(js.Proxy proxy) => proxy == null ? null : new $name.fromProxy(proxy);");
    r.writeln();
    if (!constructors.isEmpty) {
      constructors.forEach((g) => r.writeln("  " + g.generateAsString()));
    }
    r.writeln("  $name.fromProxy(js.Proxy proxy) : super.fromProxy(proxy);");
    if (!getters.isEmpty) {
      r.writeln();
      getters.forEach((g) => r.writeln("  " + g.generateAsString()));
    }
    if (!setters.isEmpty) {
      r.writeln();
      setters.forEach((s) => r.writeln("  " + s.generateAsString()));
    }
    if (!methods.isEmpty) {
      r.writeln();
      methods.forEach((m) => r.writeln("  " + m.generateAsString()));
    }
    if (!customs.isEmpty) {
      r.writeln();
      customs.forEach((content) => r.writeln(content));
    }
    r.writeln("}");
    return r.toString();
  }
}

class Getter {
  final dynamic type;
  final String name;

  Getter(this.type, this.name);

  String generateAsString() {
    if (type is SerializableType) {
      return "${type.type} get $name => ${type.fromJs('\$unsafe.$name')};";
    } else {
      return "$type get $name => \$unsafe.$name;";
    }
  }
}

class Setter {
  final dynamic type;
  final String name;

  Setter(this.type, this.name);

  String generateAsString() {
    if (type is SerializableType) {
      return "set $name(${type.type} $name) => \$unsafe.$name = ${type.toJs(name)};";
    } else {
      return "set $name($type $name) => \$unsafe.$name = $name;";
    }
  }
}

class Constructor {
  final TypedProxy typedProxy;
  final String name;
  final String functionName;
  final List<Parameter> parameters;

  Constructor(this.typedProxy, this.name, this.functionName, this.parameters);

  String generateAsString() {
    final r = new StringBuffer();
    r.write(typedProxy.name);
    if (name != null) {
      r.write(".$name");
    }
    r.write("(");
    if (parameters != null) {
      r.write(parameters.map((p) => "${p.type} ${p.name}").join(", "));
    }
    r.write(")");
    if (functionName != null) {
      r.write(" : super(${functionName}");
    } else {
      r.write(" : super(js.context.${typedProxy.name}");
    }
    if (parameters != null) {
      r.write(", [");
      r.write(parameters.map((p) => p.toJs()).join(", "));
      r.write("]");
    }
    r.write(");");
    return r.toString();
  }
}

class Method {
  final dynamic returnType;
  final String name;
  final List<Parameter> parameters;

  Method(this.returnType, this.name, this.parameters);

  String generateAsString() {
    final r = new StringBuffer();
    if (returnType != null) {
      r.write(returnType is SerializableType ? returnType.type : returnType);
    } else {
      r.write("void");
    }
    r.write(" $name(");
    if (parameters != null) {
      r.write(parameters.map((p) => "${p.type} ${p.name}").join(", "));
    }
    r.write(") ");
    if (returnType != null) {
      r.write("=> ");
    } else {
      r.write("{ return ");
    }
    final jsCall = "\$unsafe.$name(" + (parameters == null ? "" : parameters.map((p) => p.toJs()).join(", ")) + ")";
    r.write(returnType is SerializableType ? returnType.fromJs(jsCall) : jsCall);
    r.write(";");
    if (returnType == null) {
      r.write(" }");
    }
    return r.toString();
  }
}

class Parameter {
  final dynamic _type;
  final String name;

  Parameter(this._type, this.name);

  String get type => _type is SerializableType ? _type.type : "$_type";
  String toJs() => _type is SerializableType ? _type.toJs(name) : "$name";
}

abstract class SerializableType {
  String get type;
  String toJs([String base]);
  String fromJs(String base);
  String forCast();
}

class TypedProxyType implements SerializableType {
  final String name;

  TypedProxyType(this.name);

  String get type => name;
  String toJs([String base = ""]) => base;
  String fromJs(String base) => "$name.cast($base)";
  String forCast() => "$name.cast";
}

class ListProxyType implements SerializableType {
  final dynamic ofType;

  ListProxyType(this.ofType);

  String get type => "List<${ofType is SerializableType ? ofType.type : ofType}>";
  String toJs([String base = ""]) => "$base is js.Serializable<js.Proxy> ? $base : js.array($base)";
  String fromJs(String base) => "jsw.JsArrayToListAdapter.castListOfSerializables($base, ${ofType.forCast()})";
  String forCast() => ofType is SerializableType ? "(e) => jsw.JsArrayToListAdapter.castListOfSerializables(e, ${ofType.forCast()})" : "jsw.JsArrayToListAdapter.cast";
}
