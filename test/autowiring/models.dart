part of dependency_injection.test.autowiring;

abstract class _AssignmentConfiguration extends AbstractInjectConfiguration {
  bool get beanHasBeenCreated;
  bool get beanHasBeenAutowired;
}

class _AssignmentAutowireFieldConfiguration extends _AssignmentConfiguration {

  bool beanHasBeenCreated;

  @autowired String mockBean;

  _AssignmentAutowireFieldConfiguration()
    : beanHasBeenCreated = false,
      mockBean = null;

  @bean String createBean() {
    beanHasBeenCreated = true;
    return 'bean';
  }

  bool get beanHasBeenAutowired => mockBean != null;
}

class _AssignmentAutowireSetterConfiguration extends _AssignmentConfiguration {

  bool beanHasBeenCreated, beanHasBeenAutowired;

  _AssignmentAutowireSetterConfiguration()
    : beanHasBeenCreated = false,
      beanHasBeenAutowired = false;

  @bean String createBean() {
    beanHasBeenCreated = true;
    return 'bean';
  }

  @autowired set mockBean(String bean) {
    beanHasBeenAutowired = true;
  }
}

class _AssignmentAutowireMethodConfiguration extends _AssignmentConfiguration {

  bool beanHasBeenCreated, beanHasBeenAutowired;

  _AssignmentAutowireMethodConfiguration()
    : beanHasBeenCreated = false,
      beanHasBeenAutowired = false;

  @bean String createBean() {
    beanHasBeenCreated = true;
    return 'bean';
  }

  @autowired void autowireBean(String bean) {
    beanHasBeenAutowired = true;
  }
}

class _AssignmentAutowireSuperTypeConfiguration extends _AssignmentConfiguration {

  bool beanHasBeenCreated;

  @autowired num field;

  _AssignmentAutowireSuperTypeConfiguration()
    : beanHasBeenCreated = false,
      field = null;

  @bean int createBean() {
    beanHasBeenCreated = true;
    return 1;
  }

  bool get beanHasBeenAutowired => field != null;
}

class _AssignmentFailureIncompatibleTypeConfiguration extends AbstractInjectConfiguration {

  @autowired num field;

  _AssignmentFailureIncompatibleTypeConfiguration() : field = null;

  @bean String createBean() {
    return 'bean';
  }
}

class _AssignmentFailureMultipleBeanConfiguration extends AbstractInjectConfiguration {

  @autowired String field;

  _AssignmentFailureMultipleBeanConfiguration() : field = null;

  @bean String createBean() {
    return 'bean';
  }

  @bean String createDuplicateBean() {
    return 'bean';
  }
}

class _AssignmentFailureMultiplePrimaryBeanConfiguration extends AbstractInjectConfiguration {

  @autowired String field;

  _AssignmentFailureMultiplePrimaryBeanConfiguration() : field = null;

  @bean @primary String createBean() {
    return 'primary bean';
  }

  @bean @primary String createDuplicateBean() {
    return 'primary bean';
  }
}

class _PrimaryConfiguration extends AbstractInjectConfiguration {

  bool _primaryBeanHasBeenCreated, _beanHasBeenCreated, beanHasBeenAutowired;

  _PrimaryConfiguration()
    : _primaryBeanHasBeenCreated = false,
      _beanHasBeenCreated = false,
      beanHasBeenAutowired = false;

  bool get beanHasBeenCreated => _primaryBeanHasBeenCreated && _beanHasBeenCreated;

  @bean @primary String createBean() {
    _primaryBeanHasBeenCreated = true;
    return 'primary bean';
  }

  @bean String createDuplicateBean() {
    _beanHasBeenCreated = true;
    return 'bean';
  }

  @autowired set method(String bean) {
    beanHasBeenAutowired = true;
  }
}

// vim: set ai et sw=2 syntax=dart :
