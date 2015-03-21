part of dependency_injection.test.inheritance;

abstract class _BaseConfiguration extends AbstractInjectConfiguration {
  bool get beanHasBeenCreated;
  bool get beanHasBeenAutowired;
}

abstract class _ExtendBeanBaseConfiguration extends _BaseConfiguration {

  bool beanHasBeenCreated;

  _ExtendBeanBaseConfiguration()
    : beanHasBeenCreated = false;

  @bean String createBean() {
    beanHasBeenCreated = true;
    return 'bean';
  }
}

abstract class _ExtendAutowireBaseConfiguration extends _BaseConfiguration {

  @autowired String mockBean;

  _ExtendAutowireBaseConfiguration()
    : mockBean = null;

  bool get beanHasBeenAutowired => mockBean != null;
}

class _ExtendBeanAutowireBaseConfiguration extends _BaseConfiguration {

  bool beanHasBeenCreated;

  @autowired String mockBean;

  _ExtendBeanAutowireBaseConfiguration()
    : beanHasBeenCreated = false,
      mockBean = null;

  @bean String createBean() {
    beanHasBeenCreated = true;
    return 'bean';
  }

  bool get beanHasBeenAutowired => mockBean != null;
}

abstract class _ImplementBeanBaseConfiguration {

  @bean String createBean();
}

abstract class _ImplementAutowireBaseConfiguration {

  @autowired set mockBean(String bean);
}

abstract class _ImplementBeanAutowireBaseConfiguration {

  @autowired set mockBean(String bean);

  @bean String createBean();
}

class _WithBeanBaseConfiguration {

  bool beanHasBeenCreated = false;

  @bean String createBean() {
    beanHasBeenCreated = true;
    return "bean";
  }
}

class _WithAutowireBaseConfiguration {

  @autowired String mockBean;

  bool get beanHasBeenAutowired => mockBean != null;
}

class _WithBeanAutowireBaseConfiguration {

  bool beanHasBeenCreated = false;

  @autowired String mockBean;

  @bean String createBean() {
    beanHasBeenCreated = true;
    return "bean";
  }

  bool get beanHasBeenAutowired => mockBean != null;
}

class _ExtendBeanConfiguration extends _ExtendBeanBaseConfiguration {

  @autowired String mockBean;

  _ExtendBeanConfiguration()
    : mockBean = null;

  bool get beanHasBeenAutowired => mockBean != null;
}

class _ExtendAutowireConfiguration extends _ExtendAutowireBaseConfiguration {

  bool beanHasBeenCreated;

  _ExtendAutowireConfiguration()
    : beanHasBeenCreated = false;

  @bean String createBean() {
    beanHasBeenCreated = true;
    return 'bean';
  }
}

class _ExtendBeanAutowireConfiguration extends _ExtendBeanAutowireBaseConfiguration {}

class _ImplementBeanConfiguration extends _BaseConfiguration implements _ImplementBeanBaseConfiguration {

  bool beanHasBeenCreated;

  @autowired String mockBean;

  _ImplementBeanConfiguration()
    : beanHasBeenCreated = false,
      mockBean = null;

  String createBean() {
    beanHasBeenCreated = true;
    return 'bean';
  }

  bool get beanHasBeenAutowired => mockBean != null;
}

class _ImplementAutowireConfiguration extends _BaseConfiguration implements _ImplementAutowireBaseConfiguration {

  bool beanHasBeenCreated;

  String mockBean;

  _ImplementAutowireConfiguration()
    : beanHasBeenCreated = false,
      mockBean = null;

  @bean String createBean() {
    beanHasBeenCreated = true;
    return 'bean';
  }

  bool get beanHasBeenAutowired => mockBean != null;
}

class _ImplementBeanAutowireConfiguration extends _BaseConfiguration implements _ImplementBeanAutowireBaseConfiguration {

  bool beanHasBeenCreated;

  String mockBean;

  _ImplementBeanAutowireConfiguration()
    : beanHasBeenCreated = false,
      mockBean = null;

  String createBean() {
    beanHasBeenCreated = true;
    return 'bean';
  }

  bool get beanHasBeenAutowired => mockBean != null;
}

class _WithBeanConfiguration extends _BaseConfiguration with _WithBeanBaseConfiguration {

  @autowired String mockBean;

  _WithBeanConfiguration()
    : mockBean = null;

  bool get beanHasBeenAutowired => mockBean != null;
}

class _WithAutowireConfiguration extends _BaseConfiguration with _WithAutowireBaseConfiguration {

  bool beanHasBeenCreated;

  _WithAutowireConfiguration()
    : beanHasBeenCreated = false;

  @bean String createBean() {
    beanHasBeenCreated = true;
    return 'bean';
  }
}

class _WithBeanAutowireConfiguration extends _BaseConfiguration with _WithBeanAutowireBaseConfiguration {}

// vim: set ai et sw=2 syntax=dart :
