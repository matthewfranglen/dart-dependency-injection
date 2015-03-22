import 'package:dependency_injection/dependency_injection.dart';

class Configuration extends AbstractInjectConfiguration {
  @bean String getBean() => "Hello World!";
}

class Bean {
  @autowired String field;
}

void main() {
  Configuration config = new Configuration();
  config.configure();
  Bean bean = new Bean();
  config.autowireBean(bean);
  print("Field: ${bean.field}");
}

// vim: set ai et sw=2 syntax=dart :
