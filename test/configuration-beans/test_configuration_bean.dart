part of dependency_injection.test.configuration_beans;

void testConfigurationBean() {
  Feature feature = new Feature("@Configuration beans can create beans");

  feature.load(new _ConfigurationBeanSteps());

  feature.scenario("A bean configuration")
    .given("a configuration with a @Configuration bean")
    .when("I call configure() on the configuration")
    .then("the contained @Configuration bean beans are created")
    .test();

  feature.scenario("A bean configuration post-configure")
    .given("a configured configuration")
    .when("I call addBean with a @Configuration bean")
    .then("the provided @Configuration bean beans are created")
    .test();
}

class _ConfigurationBeanSteps {

  @Given("a configuration with a @Configuration bean")
  void makeBeanConfiguration(Map<String, dynamic> context) {
    context["configuration"] = new _ConfigurationBeanConfiguration();
  }

  @Given("a configured configuration")
  void makeBlankConfiguration(Map<String, dynamic> context) {
    context["configuration"] =
      new _BlankConfiguration()
        ..configure();
  }

  @When("I call configure() on the configuration")
  void callConfigure(Map<String, dynamic> context) {
    (context["configuration"] as AbstractInjectConfiguration)
      .configure();
  }

  @When("I call addBean with a @Configuration bean")
  void callAddBean(Map<String, dynamic> context) {
    _CreatedBeanConfiguration bean = new _CreatedBeanConfiguration();
    _BlankConfiguration configuration =
      context["configuration"] as _BlankConfiguration;

    configuration.addBean(bean);
    configuration.autowireBean(bean);
    context["bean"] = bean;
  }

  @Then("the contained @Configuration bean beans are created")
  void testContainedBeanAutowired(Map<String, dynamic> context) {
    _ConfigurationBeanConfiguration config =
      context["configuration"] as _ConfigurationBeanConfiguration;

    expect(config.configurationBeanBeansCreated, isTrue);
  }

  @Then("the provided @Configuration bean beans are created")
  void testProvidedBeanAutowired(Map<String, dynamic> context) {
    _CreatedBeanConfiguration config =
      context["bean"] as _CreatedBeanConfiguration;

    expect(config.configurationBeanBeansCreated, isTrue);
  }
}

// vim: set ai et sw=2 syntax=dart :

