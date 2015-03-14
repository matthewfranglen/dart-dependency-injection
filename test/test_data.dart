import 'package:dependency_injection/dependency_injection.dart';

abstract class MockConfiguration extends AbstractInjectConfiguration {

  bool get beanHasBeenCreated;

  bool get beanHasBeenAutowired;
}


class MockBean {}

abstract class AutowiredBean {
  bool get beanHasBeenAutowired;
}

class AutowiredFieldBean implements AutowiredBean {
  @autowired MockBean bean;

  AutowiredFieldBean() : bean = null;

  bool get beanHasBeenAutowired => bean != null;
}

class AutowiredSetterBean implements AutowiredBean {

  bool beanHasBeenAutowired;

  AutowiredSetterBean() : beanHasBeenAutowired = false;

  @autowired set mockBean(MockBean bean) {
    beanHasBeenAutowired = true;
  }
}

class AutowiredMethodBean implements AutowiredBean {

  bool beanHasBeenAutowired;

  AutowiredMethodBean() : beanHasBeenAutowired = false;

  @autowired void setBean(MockBean bean) {
    beanHasBeenAutowired = true;
  }
}

abstract class BeanAutowiringConfiguration extends AbstractInjectConfiguration {
  AutowiredBean get autowiredBean;
}

class BeanFieldAutowiringConfiguration extends BeanAutowiringConfiguration {

  @autowired AutowiredBean autowiredBean;

  BeanFieldAutowiringConfiguration();

  @bean AutowiredBean createBean() {
    return new AutowiredFieldBean();
  }

  @bean MockBean createMockBean() {
    return new MockBean();
  }
}

class BeanSetterAutowiringConfiguration extends BeanAutowiringConfiguration {

  @autowired AutowiredBean autowiredBean;

  BeanSetterAutowiringConfiguration();

  @bean AutowiredBean createBean() {
    return new AutowiredSetterBean();
  }

  @bean MockBean createMockBean() {
    return new MockBean();
  }
}

class BeanMethodAutowiringConfiguration extends BeanAutowiringConfiguration {

  @autowired AutowiredBean autowiredBean;

  BeanMethodAutowiringConfiguration();

  @bean AutowiredBean createBean() {
    return new AutowiredMethodBean();
  }

  @bean MockBean createMockBean() {
    return new MockBean();
  }
}

// vim: set ai et sw=2 syntax=dart :
