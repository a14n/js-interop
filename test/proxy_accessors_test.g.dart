// GENERATED CODE - DO NOT MODIFY BY HAND
// 2015-03-16T05:49:31.672Z

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
  mayRegister('Class0', (o) => new ClassFinalField.created(o));
  mayRegister('Class0', (o) => new ClassNotFinalField.created(o));
  mayRegister('Class0', (o) => new ClassPrivateField.created(o));
  mayRegister('Class0', (o) => new ClassRenamedField.created(o));
  mayRegister('Class0', (o) => new ClassRenamedPrivateField.created(o));
  mayRegister('Class0', (o) => new ClassWithGetter.created(o));
  mayRegister('Class0', (o) => new ClassWithSetter.created(o));
  mayRegister('Class0', (o) => new ClassWithPrivateGetter.created(o));
  mayRegister('Class0', (o) => new ClassWithPrivateSetter.created(o));
  mayRegister('Class0', (o) => new ClassWithRenamedGetter.created(o));
  mayRegister('Class0', (o) => new ClassWithRenamedSetter.created(o));
}

// **************************************************************************
// Generator: Instance of 'JsProxyGenerator'
// Target: abstract class _Class0
// **************************************************************************

class Class0 extends JsInterface implements _Class0 {
  Class0.created(JsObject o) : super.created(o);
  Class0() : this.created(new JsObject(getPath('Class0')));

  int get i => asJsObject(this)['i'];
  double get d => asJsObject(this)['d'];
  String get s => asJsObject(this)['s'];
  bool get b => asJsObject(this)['b'];
}

// **************************************************************************
// Generator: Instance of 'JsProxyGenerator'
// Target: abstract class _ClassFinalField
// **************************************************************************

class ClassFinalField extends JsInterface implements _ClassFinalField {
  ClassFinalField.created(JsObject o) : super.created(o);
  ClassFinalField() : this.created(new JsObject(getPath('Class0')));

  int get i => asJsObject(this)['i'];
}

// **************************************************************************
// Generator: Instance of 'JsProxyGenerator'
// Target: abstract class _ClassNotFinalField
// **************************************************************************

class ClassNotFinalField extends JsInterface implements _ClassNotFinalField {
  ClassNotFinalField.created(JsObject o) : super.created(o);
  ClassNotFinalField() : this.created(new JsObject(getPath('Class0')));

  void set i(int _i) {
    asJsObject(this)['i'] = _i;
  }
  int get i => asJsObject(this)['i'];
}

// **************************************************************************
// Generator: Instance of 'JsProxyGenerator'
// Target: abstract class _ClassPrivateField
// **************************************************************************

class ClassPrivateField extends JsInterface implements _ClassPrivateField {
  ClassPrivateField.created(JsObject o) : super.created(o);
  ClassPrivateField() : this.created(new JsObject(getPath('Class0')));

  void set _i(int __i) {
    asJsObject(this)['i'] = __i;
  }
  int get _i => asJsObject(this)['i'];
}

// **************************************************************************
// Generator: Instance of 'JsProxyGenerator'
// Target: abstract class _ClassRenamedField
// **************************************************************************

class ClassRenamedField extends JsInterface implements _ClassRenamedField {
  ClassRenamedField.created(JsObject o) : super.created(o);
  ClassRenamedField() : this.created(new JsObject(getPath('Class0')));

  void set iBis(int _iBis) {
    asJsObject(this)['i'] = _iBis;
  }
  int get iBis => asJsObject(this)['i'];
}

// **************************************************************************
// Generator: Instance of 'JsProxyGenerator'
// Target: abstract class _ClassRenamedPrivateField
// **************************************************************************

class ClassRenamedPrivateField extends JsInterface
    implements _ClassRenamedPrivateField {
  ClassRenamedPrivateField.created(JsObject o) : super.created(o);
  ClassRenamedPrivateField() : this.created(new JsObject(getPath('Class0')));

  void set _iBis(int __iBis) {
    asJsObject(this)['i'] = __iBis;
  }
  int get _iBis => asJsObject(this)['i'];
}

// **************************************************************************
// Generator: Instance of 'JsProxyGenerator'
// Target: abstract class _ClassWithGetter
// **************************************************************************

class ClassWithGetter extends JsInterface implements _ClassWithGetter {
  ClassWithGetter.created(JsObject o) : super.created(o);
  ClassWithGetter() : this.created(new JsObject(getPath('Class0')));

  int get i => asJsObject(this)['i'];
}

// **************************************************************************
// Generator: Instance of 'JsProxyGenerator'
// Target: abstract class _ClassWithSetter
// **************************************************************************

class ClassWithSetter extends JsInterface implements _ClassWithSetter {
  ClassWithSetter.created(JsObject o) : super.created(o);
  ClassWithSetter() : this.created(new JsObject(getPath('Class0')));

  set i(int i) {
    asJsObject(this)['i'] = i;
  }
}

// **************************************************************************
// Generator: Instance of 'JsProxyGenerator'
// Target: abstract class _ClassWithPrivateGetter
// **************************************************************************

class ClassWithPrivateGetter extends JsInterface
    implements _ClassWithPrivateGetter {
  ClassWithPrivateGetter.created(JsObject o) : super.created(o);
  ClassWithPrivateGetter() : this.created(new JsObject(getPath('Class0')));

  int get _i => asJsObject(this)['i'];
}

// **************************************************************************
// Generator: Instance of 'JsProxyGenerator'
// Target: abstract class _ClassWithPrivateSetter
// **************************************************************************

class ClassWithPrivateSetter extends JsInterface
    implements _ClassWithPrivateSetter {
  ClassWithPrivateSetter.created(JsObject o) : super.created(o);
  ClassWithPrivateSetter() : this.created(new JsObject(getPath('Class0')));

  set _i(int i) {
    asJsObject(this)['i'] = i;
  }
}

// **************************************************************************
// Generator: Instance of 'JsProxyGenerator'
// Target: abstract class _ClassWithRenamedGetter
// **************************************************************************

class ClassWithRenamedGetter extends JsInterface
    implements _ClassWithRenamedGetter {
  ClassWithRenamedGetter.created(JsObject o) : super.created(o);
  ClassWithRenamedGetter() : this.created(new JsObject(getPath('Class0')));

  int get iBis => asJsObject(this)['i'];
}

// **************************************************************************
// Generator: Instance of 'JsProxyGenerator'
// Target: abstract class _ClassWithRenamedSetter
// **************************************************************************

class ClassWithRenamedSetter extends JsInterface
    implements _ClassWithRenamedSetter {
  ClassWithRenamedSetter.created(JsObject o) : super.created(o);
  ClassWithRenamedSetter() : this.created(new JsObject(getPath('Class0')));

  set iBis(int i) {
    asJsObject(this)['i'] = i;
  }
}
