// GENERATED CODE - DO NOT MODIFY BY HAND
// 2015-02-27T13:20:48.170Z

part of js.test.js_expando_test;

// **************************************************************************
// Generator: Instance of 'InitializeJavascriptGenerator'
// Target: main
// **************************************************************************

void initializeJavaScript() {
  registerFactoryForJsConstructor(getPath('Foo'), (o) => new Foo.created(o));
}

// **************************************************************************
// Generator: Instance of 'JsProxyGenerator'
// Target: abstract class _Foo
// **************************************************************************

class Foo extends JsInterface {
  Foo.created(JsObject o) : super.created(o);
  Foo() : this.created(new JsObject(getPath('Foo')));
}
