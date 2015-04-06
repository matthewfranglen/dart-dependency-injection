part of dependency_injection.test.post_construct;

class _PostConstructConfiguration extends AbstractInjectConfiguration {

  @autowired _PostConstructBean postConstructBean;

  @bean _PostConstructBean makeBean() =>
    new _PostConstructBean();
}

class _PostConstructBean {

  bool postConstructMethodCalled = false;

  @postConstruct void initialize() {
    postConstructMethodCalled = true;
  }
}

class _PostConstructConfigurationWithMethod extends AbstractInjectConfiguration {

  bool postConstructMethodCalled = false;

  @postConstruct void initialize() {
    postConstructMethodCalled = true;
  }
}

class _PostConstructConfigurationWithArgument extends AbstractInjectConfiguration {

  bool postConstructMethodCalled = false;

  @bean String makeBean() => 'bean';

  @postConstruct void initialize(String bean) {
    postConstructMethodCalled = true;
  }
}

// vim: set ai et sw=2 syntax=dart :
