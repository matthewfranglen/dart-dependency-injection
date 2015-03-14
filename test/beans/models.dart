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

// vim: set ai et sw=2 syntax=dart :
