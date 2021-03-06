import 'package:dependency_injection/dependency_injection.dart';

class Bean {
  @autowired String value;
}

class Configuration extends AbstractInjectConfiguration {

  @bean String getBean() => "Hello World!";
  @bean Bean getAutowiredBean() => new Bean();

  @autowired void method(Bean bean) {
    print("Method: @autowired bean ${bean.value}");
    print("This accesses the bean during autowiring so the value may be unassigned!");
  }

  @autowired set setter(Bean bean) {
    print("Setter: @autowired bean ${bean.value}");
    print("This accesses the bean during autowiring so the value may be unassigned!");
  }

  @autowired Bean field;
}

void main() {
  Configuration config = new Configuration();
  config.configure();
  print("Field: @autowired bean ${config.field.value}");
  print("The autowiring has completed so the value has been assigned");
}

// vim: set ai et sw=2 syntax=dart :
