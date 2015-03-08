// GENERATED CODE - DO NOT MODIFY BY HAND
// 2015-03-08T16:04:33.806Z

part of js.test.js_expando_test;

// **************************************************************************
// Generator: Instance of 'InitializeJavascriptGenerator'
// Target: library js.test.js_expando_test
// **************************************************************************

void initializeJavaScript({List<String> exclude, List<String> include}) {
  bool accept(String name) => (include != null && include.contains(name)) ||
      (include == null && exclude != null && !exclude.contains(name));

  void register(String name, JsInterface f(JsObject o)) =>
      registerFactoryForJsConstructor(getPath(name), f);

  void mayRegister(String name, JsInterface f(JsObject o)) {
    if (accept(name)) register(name, f);
  }

  mayRegister('Foo', (o) => new Foo.created(o));
}

// **************************************************************************
// Generator: Instance of 'JsProxyGenerator'
// Target: abstract class _Foo
// **************************************************************************

class Foo extends JsInterface implements _Foo {
  Foo.created(JsObject o) : super.created(o);
  Foo() : this.created(new JsObject(getPath('Foo')));
}
