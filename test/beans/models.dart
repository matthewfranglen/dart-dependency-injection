part of dependency_injection.test.beans;

abstract class _CreationConfiguration extends AbstractInjectConfiguration {
  bool get beanHasBeenCreated;
}

class _CreationSingleConfiguration extends _CreationConfiguration {
  bool beanHasBeenCreated;

  _CreationSingleConfiguration()
    : beanHasBeenCreated = false;

  @bean String createBean() {
    beanHasBeenCreated = true;
    return 'bean';
  }
}

class _CreationDuplicateConfiguration extends _CreationConfiguration {
  bool firstBeanHasBeenCreated, secondBeanHasBeenCreated;

  _CreationDuplicateConfiguration()
    : firstBeanHasBeenCreated = false,
      secondBeanHasBeenCreated = false;

  bool get beanHasBeenCreated =>
    firstBeanHasBeenCreated && secondBeanHasBeenCreated;

  @bean String createBean() {
    firstBeanHasBeenCreated = true;
    return 'bean';
  }

  @bean String createSecondBean() {
    secondBeanHasBeenCreated = true;
    return 'bean';
  }
}

class _CreationExceptionThrowingConfiguration extends AbstractInjectConfiguration {
  @bean String createBean() => throw new Exception();
}

abstract class _AutowiredBean {
  bool get beanHasBeenAutowired;
}

class _AutowiredFieldBean implements _AutowiredBean {
  @autowired String bean;

  _AutowiredFieldBean() : bean = null;

  bool get beanHasBeenAutowired => bean != null;
}

class _AutowiredSetterBean implements _AutowiredBean {

  bool beanHasBeenAutowired;

  _AutowiredSetterBean() : beanHasBeenAutowired = false;

  @autowired set mockBean(String bean) {
    beanHasBeenAutowired = true;
  }
}

class _AutowiredMethodBean implements _AutowiredBean {

  bool beanHasBeenAutowired;

  _AutowiredMethodBean() : beanHasBeenAutowired = false;

  @autowired void setBean(String bean) {
    beanHasBeenAutowired = true;
  }
}

abstract class _AutowiredBeanConfiguration extends AbstractInjectConfiguration {
  _AutowiredBean get autowiredBean;

  bool get beanHasBeenCreated => autowiredBean != null;
}

class _AutowiredBeanFieldConfiguration extends _AutowiredBeanConfiguration {

  @autowired _AutowiredBean autowiredBean;

  @bean _AutowiredBean createBean() {
    return new _AutowiredFieldBean();
  }

  @bean String createMockBean() {
    return 'bean';
  }
}

class _AutowiredBeanSetterConfiguration extends _AutowiredBeanConfiguration {

  @autowired _AutowiredBean autowiredBean;

  @bean _AutowiredBean createBean() {
    return new _AutowiredSetterBean();
  }

  @bean String createMockBean() {
    return 'bean';
  }
}

class _AutowiredBeanMethodConfiguration extends _AutowiredBeanConfiguration {

  @autowired _AutowiredBean autowiredBean;

  @bean _AutowiredBean createBean() {
    return new _AutowiredMethodBean();
  }

  @bean String createMockBean() {
    return 'bean';
  }
}

// vim: set ai et sw=2 syntax=dart :
