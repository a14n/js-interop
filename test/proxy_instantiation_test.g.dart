// GENERATED CODE - DO NOT MODIFY BY HAND
// 2015-03-14T13:18:10.558Z

part of js.test.proxy_instantiation_test;

// **************************************************************************
// Generator: Instance of 'JsProxyGenerator'
// Target: library js.test.proxy_instantiation_test
// **************************************************************************

void initializeJavaScript({List<String> exclude, List<String> include}) {
  bool accept(String name) => (include != null && include.contains(name)) ||
      (include == null && exclude != null && !exclude.contains(name));

  void register(String name, JsInterface f(JsObject o)) =>
      registerFactoryForJsConstructor(getPath(name), f);

  void mayRegister(String name, JsInterface f(JsObject o)) {
    if (accept(name)) register(name, f);
  }

  mayRegister('Class0', (o) => new Class0.created(o));
  mayRegister('Class1', (o) => new Class1.created(o));
  mayRegister('Class0', (o) => new Class0Alias.created(o));
  mayRegister('my.package.Class2', (o) => new Class2.created(o));
}

// **************************************************************************
// Generator: Instance of 'JsProxyGenerator'
// Target: abstract class _Class0
// **************************************************************************

class Class0 extends JsInterface implements _Class0 {
  Class0.created(JsObject o) : super.created(o);
  Class0() : this.created(new JsObject(getPath('Class0')));
}

// **************************************************************************
// Generator: Instance of 'JsProxyGenerator'
// Target: abstract class _Class1
// **************************************************************************

class Class1 extends JsInterface implements _Class1 {
  Class1.created(JsObject o) : super.created(o);
  Class1(String s)
      : this.created(new JsObject(getPath('Class1'), [s].map(toJs).toList()));
}

// **************************************************************************
// Generator: Instance of 'JsProxyGenerator'
// Target: abstract class _Class0Alias
// **************************************************************************

class Class0Alias extends JsInterface implements _Class0Alias {
  Class0Alias.created(JsObject o) : super.created(o);
  Class0Alias() : this.created(new JsObject(getPath('Class0')));
}

// **************************************************************************
// Generator: Instance of 'JsProxyGenerator'
// Target: abstract class _Class2
// **************************************************************************

class Class2 extends JsInterface implements _Class2 {
  Class2.created(JsObject o) : super.created(o);
  Class2() : this.created(new JsObject(getPath('my.package.Class2')));
}
