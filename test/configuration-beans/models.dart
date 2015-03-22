part of dependency_injection.test.configuration_beans;

class _ConfigurationBeanConfiguration extends AbstractInjectConfiguration {

  @autowired String field = null;

  @bean _CreatedBeanConfiguration makeConfiguration() => new _CreatedBeanConfiguration();

  bool get configurationBeanBeansCreated => field != null;
}

class _BlankConfiguration extends AbstractInjectConfiguration {}

@configuration
class _CreatedBeanConfiguration {

  @autowired String field = null;

  @bean String makeBean() => "inner-bean";

  bool get configurationBeanBeansCreated => field != null;
}

// vim: set ai et sw=2 syntax=dart :
