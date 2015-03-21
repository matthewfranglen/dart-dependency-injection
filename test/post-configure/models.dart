part of dependency_injection.test.post_configure;

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

class _AutowiredConfiguration extends AbstractInjectConfiguration {

  @bean String makeBean() => "bean";
}

// vim: set ai et sw=2 syntax=dart :
