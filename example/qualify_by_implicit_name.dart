import 'package:dependency_injection/dependency_injection.dart';

class Configuration extends AbstractInjectConfiguration {

  @bean String getBean() => "Hello World!";
  @bean String makeDifferentBean() => "Goodbye!";

  @autowired void method(@Qualifier("bean") String bean) {
    print("Method: @qualifier ${bean}");
  }

  @autowired set setter(@Qualifier("bean") String bean) {
    print("Setter: @qualifier ${bean}");
  }

  @autowired @Qualifier("bean") String field;
}

void main() {
  Configuration config = new Configuration();
  config.configure();
  print("Field: @qualifier ${config.field}");
}

// vim: set ai et sw=2 syntax=dart :
