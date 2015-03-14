import 'package:dependency_injection/dependency_injection.dart';

abstract class MockConfiguration extends AbstractInjectConfiguration {

  bool get beanHasBeenCreated;

  bool get beanHasBeenAutowired;
}

class AmbiguousAutowireConfiguration extends AbstractInjectConfiguration {

  @bean MockBean createBean() => new MockBean();

  @bean MockBean createDuplicateBean() => new MockBean();

  @autowired void autowireBean(MockBean bean) {}
}

class DuplicateBeanTypeConfiguration extends AbstractInjectConfiguration {

  @bean MockBean createBean() => new MockBean();

  @bean MockBean createDuplicateBean() => new MockBean();
}

class PrimaryAutowireConfiguration extends MockConfiguration {

  bool _primaryBeanHasBeenCreated, _beanHasBeenCreated, beanHasBeenAutowired;

  PrimaryAutowireConfiguration()
    : _primaryBeanHasBeenCreated = false,
      _beanHasBeenCreated = false,
      beanHasBeenAutowired = false;

  bool get beanHasBeenCreated => _primaryBeanHasBeenCreated && _beanHasBeenCreated;

  @bean @primary MockBean createBean() {
    _primaryBeanHasBeenCreated = true;
    return new MockBean();
  }

  @bean MockBean createDuplicateBean() {
    _beanHasBeenCreated = true;
    return new MockBean();
  }

  @autowired set mockBean(MockBean bean) {
    beanHasBeenAutowired = true;
  }
}

class DuplicatePrimaryAutowireConfiguration extends AbstractInjectConfiguration {

  DuplicatePrimaryAutowireConfiguration();

  @bean @primary MockBean createBean() => new MockBean();

  @bean @primary MockBean createDuplicateBean() => new MockBean();

  @autowired set mockBean(MockBean bean) {}
}

class ExceptionThrowingBeanConfiguration extends AbstractInjectConfiguration {

  @bean MockBean createBean() => throw new Exception();
}

class ExceptionThrowingAutowireConfiguration extends AbstractInjectConfiguration {

  @bean MockBean createBean() => new MockBean();

  @autowired void autowireBean(MockBean bean) {
    throw new Exception();
  }
}

class OptionalAutowireConfiguration extends AbstractInjectConfiguration {

  @Autowired(required: false) void autowireBean(MockBean bean) {}
}

class DuplicateOptionalAutowireConfiguration extends AbstractInjectConfiguration {

  @bean MockBean createBean() => new MockBean();

  @bean MockBean createDuplicateBean() => new MockBean();

  @Autowired(required: false) void autowireBean(MockBean bean) {}
}

class ValidOptionalAutowiredBeanConfiguration extends MockConfiguration {

  bool beanHasBeenCreated, beanHasBeenAutowired;

  ValidOptionalAutowiredBeanConfiguration()
    : beanHasBeenCreated = false,
      beanHasBeenAutowired = false;

  @bean MockBean createBean() {
    beanHasBeenCreated = true;
    return new MockBean();
  }

  @Autowired(required: false) void autowireBean(MockBean bean) {
    beanHasBeenAutowired = true;
  }
}

class QualifierAutowiredBeanConfiguration extends MockConfiguration {

  bool _qualifiedBeanHasBeenCreated, _beanHasBeenCreated, beanHasBeenAutowired;

  QualifierAutowiredBeanConfiguration()
    : _qualifiedBeanHasBeenCreated = false,
      _beanHasBeenCreated = false,
      beanHasBeenAutowired = false;

  bool get beanHasBeenCreated => _qualifiedBeanHasBeenCreated && _beanHasBeenCreated;

  @Bean(name: "bean") MockBean createBean() {
    _qualifiedBeanHasBeenCreated = true;
    return new MockBean();
  }

  @bean MockBean createDuplicateBean() {
    _beanHasBeenCreated = true;
    return new MockBean();
  }

  @autowired void setBean(@Qualifier("bean") MockBean bean) {
    beanHasBeenAutowired = true;
  }
}

class QualifierSetterAutowiredBeanConfiguration extends MockConfiguration {

  bool _qualifiedBeanHasBeenCreated, _beanHasBeenCreated, beanHasBeenAutowired;

  QualifierSetterAutowiredBeanConfiguration()
    : _qualifiedBeanHasBeenCreated = false,
      _beanHasBeenCreated = false,
      beanHasBeenAutowired = false;

  bool get beanHasBeenCreated => _qualifiedBeanHasBeenCreated && _beanHasBeenCreated;

  @Bean(name: "bean") MockBean createBean() {
    _qualifiedBeanHasBeenCreated = true;
    return new MockBean();
  }

  @bean MockBean createDuplicateBean() {
    _beanHasBeenCreated = true;
    return new MockBean();
  }

  @autowired set mockBean(@Qualifier("bean") MockBean bean) {
    beanHasBeenAutowired = true;
  }
}

class QualifierFieldAutowiredBeanConfiguration extends MockConfiguration {

  bool _qualifiedBeanHasBeenCreated, _beanHasBeenCreated;

  @autowired @Qualifier("bean") MockBean mockBean;

  QualifierFieldAutowiredBeanConfiguration()
    : _qualifiedBeanHasBeenCreated = false,
      _beanHasBeenCreated = false,
      mockBean = null;

  bool get beanHasBeenCreated => _qualifiedBeanHasBeenCreated && _beanHasBeenCreated;

  bool get beanHasBeenAutowired => bean != null;

  @Bean(name: "bean") MockBean createBean() {
    _qualifiedBeanHasBeenCreated = true;
    return new MockBean();
  }

  @bean MockBean createDuplicateBean() {
    _beanHasBeenCreated = true;
    return new MockBean();
  }
}

class PrimaryQualifierAutowiredBeanConfiguration extends MockConfiguration {

  bool _primaryQualifiedBeanHasBeenCreated, _beanHasBeenCreated, beanHasBeenAutowired;

  PrimaryQualifierAutowiredBeanConfiguration()
    : _primaryQualifiedBeanHasBeenCreated = false,
      _beanHasBeenCreated = false,
      beanHasBeenAutowired = false;

  bool get beanHasBeenCreated => _primaryQualifiedBeanHasBeenCreated && _beanHasBeenCreated;

  @Bean(name: "bean") @primary MockBean createBean() {
    _primaryQualifiedBeanHasBeenCreated = true;
    return new MockBean();
  }

  @Bean(name: "bean") MockBean createDuplicateBean() {
    _beanHasBeenCreated = true;
    return new MockBean();
  }

  @autowired void setBean(@Qualifier("bean") MockBean bean) {
    beanHasBeenAutowired = true;
  }
}

class MultipleQualifierAutowiredBeanConfiguration extends AbstractInjectConfiguration {

  @Bean(name: "bean") MockBean createBean() => new MockBean();

  @Bean(name: "bean") MockBean createDuplicateBean() => new MockBean();

  @autowired void setBean(@Qualifier("bean") MockBean bean) {}
}

class ImplicitQualifierAutowiredBeanConfiguration extends AbstractInjectConfiguration {

  @bean MockBean getBean() => new MockBean();

  @Bean(name: "bean") MockBean createDuplicateBean() => new MockBean();

  @autowired void setBean(@Qualifier("bean") MockBean bean) {}
}

class MultiplePrimaryQualifierAutowiredBeanConfiguration extends AbstractInjectConfiguration {

  @Bean(name: "bean") @primary MockBean createBean() => new MockBean();

  @Bean(name: "bean") @primary MockBean createDuplicateBean() => new MockBean();

  @autowired void setBean(@Qualifier("bean") MockBean bean) {}
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
