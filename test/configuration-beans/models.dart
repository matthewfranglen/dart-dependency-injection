part of dependency_injection.test.configuration_beans;

class _ConfigurationBeanConfiguration extends AbstractInjectConfiguration {

  @autowired String field;

  @bean _CreatedBeanConfiguration makeConfiguration() => new _CreatedBeanConfiguration();
}

@configuration
class _CreatedBeanConfiguration {

  @bean String makeBean() => "inner-bean";
}

// vim: set ai et sw=2 syntax=dart :
