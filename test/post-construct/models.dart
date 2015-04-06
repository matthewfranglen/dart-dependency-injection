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

// vim: set ai et sw=2 syntax=dart :
