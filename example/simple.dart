import 'package:dependency_injection/dependency_injection.dart';

class Configuration extends AbstractInjectConfiguration {

  @bean String getBean() => "Hello World!";

  @autowired void method(String bean) {
    print("Method: ${bean}");
  }

  @autowired set setter(String bean) {
    print("Setter: ${bean}");
  }

  @autowired String field;
}

void main() {
  Configuration config = new Configuration();
  config.configure();
  print("Field: ${config.field}");
}

// vim: set ai et sw=2 syntax=dart :
