library tests;

import 'package:js/js_wrapping_builder.dart' as jsb;
import 'package:unittest/unittest.dart';

main() {
  test('empty class', () {
    final person = new jsb.TypedProxy("Person");
    final content = person.generateAsString();
    expect(content, equals(_buildTemplate()));
  });
  group('constructors', () {
    test('empty', () {
      final person = new jsb.TypedProxy("Person");
      person.addConstructor();
      final content = person.generateAsString();
      expect(content, equals(_buildTemplate(constructors:r"""
  Person() : super(js.context.Person);""")));
    });
    test('simple', () {
      final person = new jsb.TypedProxy("Person");
      person.addConstructor(params : [new jsb.Parameter(String, "firstname"), new jsb.Parameter(int, "age")]);
      final content = person.generateAsString();
      expect(content, equals(_buildTemplate(constructors:r"""
  Person(String firstname, int age) : super(js.context.Person, [firstname, age]);""")));
    });
  });

  group('getters', () {
    test('simple types', () {
      final person = new jsb.TypedProxy("Person");
      person.addGetter(String, "firstname");
      person.addGetter(int, "age");
      person.addGetter(bool, "isMan");
      final content = person.generateAsString();
      expect(content, equals(_buildTemplate(getters:r"""
  String get firstname => $unsafe.firstname;
  int get age => $unsafe.age;
  bool get isMan => $unsafe.isMan;""")));
    });

    test('returning a TypedProxy', () {
      final person = new jsb.TypedProxy("Person");
      person.addGetter(person, "father");
      final content = person.generateAsString();
      expect(content, equals(_buildTemplate(getters:r"""
  Person get father => Person.cast($unsafe.father);""")));
    });
  });

  group('setters', () {
    test('simple types', () {
      final person = new jsb.TypedProxy("Person");
      person.addSetter(String, "firstname");
      person.addSetter(int, "age");
      person.addSetter(bool, "isMan");
      final content = person.generateAsString();
      expect(content, equals(_buildTemplate(getters:r"""
  set firstname(String firstname) => $unsafe.firstname = firstname;
  set age(int age) => $unsafe.age = age;
  set isMan(bool isMan) => $unsafe.isMan = isMan;""")));
    });

    test('taking a TypeProxy', () {
      final person = new jsb.TypedProxy("Person");
      person.addSetter(person, "father");
      final content = person.generateAsString();
      expect(content, equals(_buildTemplate(setters:r"""
  set father(Person father) => $unsafe.father = father;""")));
    });
  });

  test('properties', () {
    final person = new jsb.TypedProxy("Person");
    person.addProperty(String, "firstname");
    final content = person.generateAsString();
    expect(content, equals(_buildTemplate(getters:r"""
  String get firstname => $unsafe.firstname;""", setters:r"""
  set firstname(String firstname) => $unsafe.firstname = firstname;""")));
  });
}

_buildTemplate({String constructors, String getters, String setters}) {
  final r = new StringBuffer();
  r.writeln(r"""
import 'package:js/js.dart' as js;
import 'package:js/js_wrapping.dart' as jsw;

class Person extends jsw.TypedProxy {
  static Person cast(js.Proxy proxy) => proxy == null ? null : new Person.fromProxy(proxy);
""");
  if (constructors != null) {
    r.writeln(constructors);
  }
  r.writeln(r"  Person.fromProxy(js.Proxy proxy) : super.fromProxy(proxy);");
  if (getters != null) {
    r.writeln();
    r.writeln(getters);
  }
  if (setters != null) {
    r.writeln();
    r.writeln(setters);
  }
  r.writeln("}");
  return r.toString();
}