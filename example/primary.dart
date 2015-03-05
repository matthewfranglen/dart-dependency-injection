import 'package:dependency_injection/dependency_injection.dart';

class Configuration extends AbstractInjectConfiguration {

  @bean @primary String getBean() => "Hello World!";
  @bean String makeDifferentBean() => "Goodbye!";

  @autowired void method(String bean) {
    print("Method: @primary ${bean}");
  }

  @autowired set setter(String bean) {
    print("Setter: @primary ${bean}");
  }

  @autowired String field;
}

void main() {
  Configuration config = new Configuration();
  config.configure();
  print("Field: @primary ${config.field}");
}

// vim: set ai et sw=2 syntax=dart :
