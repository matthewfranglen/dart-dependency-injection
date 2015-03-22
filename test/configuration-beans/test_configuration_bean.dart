part of dependency_injection.test.configuration_beans;

void testConfigurationBean() {
  Feature feature = new Feature("@Configuration beans can create beans");

  feature.load(new _ConfigurationBeanSteps());

  feature.scenario("A bean configuration")
    .given("a configuration with a @Configuration bean")
    .when("I call configure() on the configuration")
    .then("the @Configuration bean beans are created")
    .test();
}

class _ConfigurationBeanSteps {

  @Given("a configuration with a @Configuration bean")
  void makeBeanConfiguration(Map<String, dynamic> context) {
    _setConfiguration(context, new _ConfigurationBeanConfiguration());
  }

  @When("I call configure() on the configuration")
  void callConfigure(Map<String, dynamic> context) {
    _getConfiguration(context).configure();
  }

  @Then("the @Configuration bean beans are created")
  void testBeanAutowired(Map<String, dynamic> context) {
    expect(_getConfiguration(context).field, equals("inner-bean"));
  }

  void _setConfiguration(Map<String, dynamic> context, _ConfigurationBeanConfiguration configuration) {
    context["configuration"] = configuration;
  }

  _ConfigurationBeanConfiguration _getConfiguration(Map<String, dynamic> context) =>
    context["configuration"];
}

// vim: set ai et sw=2 syntax=dart :

