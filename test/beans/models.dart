part of dependency_injection.test.beans;

class _CreationConfiguration extends AbstractInjectConfiguration {
  bool beanHasBeenCreated;

  _CreationConfiguration()
    : beanHasBeenCreated = false;

  @bean String createBean() {
    beanHasBeenCreated = true;
    return 'bean';
  }
}

// vim: set ai et sw=2 syntax=dart :
