library js.example.simple_class;

class A {
  A.created(o);

  factory A() => null;
}

class B extends A with _$BMixin {
  B.created(o) : super.created(o);

  factory B() = _$B;
  factory B.named() = _$B.named;

  String m1();
}

int find(String a) => _$find(a);

// not possible to use top level variable
String a;

String get b => _$b;

set b(String b1) => _$b = b1;

main() {
  print(new B.created(null).m1());
  print(new B().m1());
  print(new B.named().m1());
}

//----------------------------
// generated content
//----------------------------
class _$BMixin {
  String m1() => 'test';
}

class _$B extends B {
  _$B.created(o) : super.created(o);

  _$B() : this.created(null);
  _$B.named() : this.created(null);
}

int _$find(String a) => null;

String get _$b => null;

set _$b(String b1) => null;
