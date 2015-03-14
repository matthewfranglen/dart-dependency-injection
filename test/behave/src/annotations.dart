part of dependency_injection.test.behave;

class BehaveAnnotation {
  final String value;

  const BehaveAnnotation(this.value);
}

class Given extends BehaveAnnotation {
  const Given(String value) : super(value);
}

class When extends BehaveAnnotation {
  const When(String value) : super(value);
}

class Then extends BehaveAnnotation {
  const Then(String value) : super(value);
}

class And extends BehaveAnnotation {
  const And(String value) : super(value);
}

// vim: set ai et sw=2 syntax=dart :
