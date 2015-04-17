// GENERATED CODE - DO NOT MODIFY BY HAND
// 2015-04-17T16:04:02.510Z

part of js.test.proxy_methods_test;

// **************************************************************************
// Generator: JsInterfaceGenerator
// Target: abstract class _Class0
// **************************************************************************

class Class0 extends JsInterface implements _Class0 {
  Class0.created(JsObject o) : super.created(o);
  Class0() : this.created(new JsObject(getPath('Class0')));

  int getI() => asJsObject(this).callMethod('getI');
  void setI(int i) {
    asJsObject(this).callMethod('setI', [i]);
  }
}

// **************************************************************************
// Generator: JsInterfaceGenerator
// Target: abstract class _ClassPrivateMethod
// **************************************************************************

@JsName('Class0')
class ClassPrivateMethod extends JsInterface implements _ClassPrivateMethod {
  ClassPrivateMethod.created(JsObject o) : super.created(o);
  ClassPrivateMethod() : this.created(new JsObject(getPath('Class0')));

  int _getI() => asJsObject(this).callMethod('getI');
}

// **************************************************************************
// Generator: JsInterfaceGenerator
// Target: abstract class _ClassRenamedMethod
// **************************************************************************

@JsName('Class0')
class ClassRenamedMethod extends JsInterface implements _ClassRenamedMethod {
  ClassRenamedMethod.created(JsObject o) : super.created(o);
  ClassRenamedMethod() : this.created(new JsObject(getPath('Class0')));

  int getIBis() => asJsObject(this).callMethod('getI');
}

// **************************************************************************
// Generator: JsInterfaceGenerator
// Target: abstract class _ClassRenamedPrivateMethod
// **************************************************************************

@JsName('Class0')
class ClassRenamedPrivateMethod extends JsInterface
    implements _ClassRenamedPrivateMethod {
  ClassRenamedPrivateMethod.created(JsObject o) : super.created(o);
  ClassRenamedPrivateMethod() : this.created(new JsObject(getPath('Class0')));

  int _getIBis() => asJsObject(this).callMethod('getI');
}
