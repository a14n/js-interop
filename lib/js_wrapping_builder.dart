// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library js.wrapping;

import 'package:meta/meta.dart';

class TypedProxy {
  final String name;
  final constructors = <Constructor>[];
  final getters = <Getter>[];
  final setters = <Setter>[];

  TypedProxy(this.name);

  void addConstructor({String name, List<Parameter> params}) {
    constructors.add(new Constructor(this, name, params));
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

  String generateAsString() {
    final r = new StringBuffer();
    r.writeln("import 'package:js/js.dart' as js;");
    r.writeln("import 'package:js/js_wrapping.dart' as jsw;");
    r.writeln();
    r.writeln("class $name extends jsw.TypedProxy {");
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
    r.writeln("}");
    return r.toString();
  }
}

class Getter {
  final dynamic type;
  final String name;

  Getter(this.type, this.name);

  String generateAsString() {
    if (type is TypedProxy) {
      return "${type.name} get $name => ${type.name}.cast(\$unsafe.$name);";
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
    var type = this.type;
    if (type is TypedProxy) {
      type = type.name;
    }
    return "set $name($type $name) => \$unsafe.$name = $name;";
  }
}

class Constructor {
  final TypedProxy typedProxy;
  final String name;
  final List<Parameter> parameters;

  Constructor(this.typedProxy, this.name, this.parameters);

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
    r.write(" : super(js.context.${typedProxy.name}");
    if (parameters != null) {
      r.write(", [");
      r.write(parameters.map((p) => p.name).join(", "));
      r.write("]");
    }
    r.write(");");
    return r.toString();
  }
}

class Parameter {
  final dynamic type;
  final String name;

  Parameter(this.type, this.name);
}