part of dependency_injection.test.inheritance;

abstract class _BaseConfiguration extends AbstractInjectConfiguration {
  bool get beanHasBeenCreated;
  bool get beanHasBeenAutowired;
}

class _ExtendBaseConfiguration extends _BaseConfiguration {

  bool beanHasBeenCreated;

  @autowired String mockBean;

  _ExtendBaseConfiguration()
    : beanHasBeenCreated = false,
      mockBean = null;

  @bean String createBean() {
    beanHasBeenCreated = true;
    return 'bean';
  }

  bool get beanHasBeenAutowired => mockBean != null;
}

abstract class _ImplementBaseConfiguration {

  @autowired set mockBean(String bean);

  @bean String createBean();
}

class _WithBaseConfiguration {

  bool beanHasBeenCreated = false;

  @autowired String mockBean;

  @bean String createBean() {
    beanHasBeenCreated = true;
    return "bean";
  }

  bool get beanHasBeenAutowired => mockBean != null;
}

class _ExtendConfiguration extends _ExtendBaseConfiguration {}

class _ImplementConfiguration extends _BaseConfiguration implements _ImplementBaseConfiguration {

  bool beanHasBeenCreated;

  String mockBean;

  _ImplementConfiguration()
    : beanHasBeenCreated = false,
      mockBean = null;

  String createBean() {
    beanHasBeenCreated = true;
    return 'bean';
  }

  bool get beanHasBeenAutowired => mockBean != null;
}

class _WithConfiguration extends _BaseConfiguration with _WithBaseConfiguration {}

// vim: set ai et sw=2 syntax=dart :
