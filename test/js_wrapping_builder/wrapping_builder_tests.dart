library tests;

import 'package:js/js_wrapping_builder.dart' as jsb;
import 'package:unittest/unittest.dart';

main() {
  test('empty class', () {
    final person = new jsb.TypedProxy("Person");
    final content = person.generateAsString();
    expect(content, equals(_buildTemplate()));
  });
  test('libConfig', () {
    final libConfig = new jsb.LibConfig(partOf:"test", fileHeader:"// hello");
    final person = new jsb.TypedProxy("Person");
    final content = person.generateAsString(libConfig);
    expect(content, equals(r"""
// hello
part of test;

class Person extends jsw.TypedProxy {
  static Person cast(js.Proxy proxy) => proxy == null ? null : new Person.fromProxy(proxy);

  Person.fromProxy(js.Proxy proxy) : super.fromProxy(proxy);
}
"""));
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
    test('simple', () {
      final person = new jsb.TypedProxy("Person");
      person.addConstructor(params : [new jsb.Parameter(new jsb.TypedProxyType(person.name), "father"), new jsb.Parameter(new jsb.ListProxyType(String), "hobbies")]);
      final content = person.generateAsString();
      expect(content, equals(_buildTemplate(constructors:r"""
  Person(Person father, List<String> hobbies) : super(js.context.Person, [father, hobbies is js.Serializable<js.Proxy> ? hobbies : js.array(hobbies)]);""")));
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
      person.addGetter(new jsb.TypedProxyType(person.name), "father");
      final content = person.generateAsString();
      expect(content, equals(_buildTemplate(getters:r"""
  Person get father => Person.cast($unsafe.father);""")));
    });

    test('returning a List', () {
      final person = new jsb.TypedProxy("Person");
      person.addGetter(new jsb.ListProxyType(new jsb.TypedProxyType(person.name)), "children");
      final content = person.generateAsString();
      expect(content, equals(_buildTemplate(setters:r"""
  List<Person> get children => jsw.JsArrayToListAdapter.castListOfSerializables($unsafe.children, Person.cast);""")));
    });

    test('returning a List of List of String', () {
      final person = new jsb.TypedProxy("Person");
      person.addGetter(new jsb.ListProxyType(new jsb.ListProxyType(new jsb.ListProxyType(String))), "foo");
      final content = person.generateAsString();
      expect(content, equals(_buildTemplate(setters:r"""
  List<List<List<String>>> get foo => jsw.JsArrayToListAdapter.castListOfSerializables($unsafe.foo, (e) => jsw.JsArrayToListAdapter.castListOfSerializables(e, jsw.JsArrayToListAdapter.cast));""")));
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
      person.addSetter(new jsb.TypedProxyType(person.name), "father");
      final content = person.generateAsString();
      expect(content, equals(_buildTemplate(setters:r"""
  set father(Person father) => $unsafe.father = father;""")));
    });

    test('taking a List', () {
      final person = new jsb.TypedProxy("Person");
      person.addSetter(new jsb.ListProxyType(new jsb.TypedProxyType(person.name)), "children");
      final content = person.generateAsString();
      expect(content, equals(_buildTemplate(setters:r"""
  set children(List<Person> children) => $unsafe.children = children is js.Serializable<js.Proxy> ? children : js.array(children);""")));
    });
  });

  group('methods', () {
    test('simple types', () {
      final person = new jsb.TypedProxy("Person");
      person.addMethod(String, "getName");
      person.addMethod(int, "computeAge");
      person.addMethod(bool, "like", [new jsb.Parameter(String, "name")]);
      final content = person.generateAsString();
      expect(content, equals(_buildTemplate(getters:r"""
  String getName() => $unsafe.getName();
  int computeAge() => $unsafe.computeAge();
  bool like(String name) => $unsafe.like(name);""")));
    });

    test('returning a TypeProxy', () {
      final person = new jsb.TypedProxy("Person");
      person.addMethod(new jsb.TypedProxyType(person.name), "getFather");
      final content = person.generateAsString();
      expect(content, equals(_buildTemplate(setters:r"""
  Person getFather() => Person.cast($unsafe.getFather());""")));
    });

    test('taking a TypeProxy', () {
      final person = new jsb.TypedProxy("Person");
      person.addMethod(null, "setChildren", [new jsb.Parameter(new jsb.ListProxyType(new jsb.TypedProxyType(person.name)), "children")]);
      final content = person.generateAsString();
      expect(content, equals(_buildTemplate(setters:r"""
  void setChildren(List<Person> children) { return $unsafe.setChildren(children is js.Serializable<js.Proxy> ? children : js.array(children)); }""")));
    });
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
