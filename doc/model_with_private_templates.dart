library js.example.simple_class;

class A {
  A.created(o);

  factory A() => null;
}

abstract class _B extends A {
  _B.created(o) : super.created(o);

  factory _B() = dynamic;
  factory _B.named() = dynamic;

  String m1();
}

main() {
  print(new B.created(null).m1());
  print(new B().m1());
  print(new B.named().m1());
}

//----------------------------
// generated content
//----------------------------
class B extends A implements _B {
  B.created(o) : super.created(o);

  B() : this.created(null);
  B.named() : this.created(null);

  String m1() => null;
}

int find(String a) => null;

String a;

String get b => null;

set b(String b1) => null;

