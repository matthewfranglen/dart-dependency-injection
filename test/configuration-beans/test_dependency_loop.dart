part of dependency_injection.test.configuration_beans;

void testDependencyLoop() {
  Feature feature = new Feature("References between beans created by different configurations");

  feature.load(new _DependencyLoopSteps());

  feature.scenario("A base configuration with a bean that references a bean created by a configuration")
    .given("a configuration with bean dependencies between configuration and configuration bean")
    .when("I call configure() on the configuration")
    .then("the dependent bean is created")
    .test();
}

class _DependencyLoopSteps {

  @Given("a configuration with bean dependencies between configuration and configuration bean")
  void makeBeanConfiguration(Map<String, dynamic> context) {
    context["configuration"] = new _DependencyLoopConfiguration();
  }

  @When("I call configure() on the configuration")
  void callConfigure(Map<String, dynamic> context) {
    (context["configuration"] as AbstractInjectConfiguration)
      .configure();
  }

  @Then("the dependent bean is created")
  void testContainedBeanAutowired(Map<String, dynamic> context) {
    _DependencyLoopConfiguration config =
      context["configuration"] as _DependencyLoopConfiguration;

    expect(config.dependentBeanCreated, isTrue);
  }
}

// vim: set ai et sw=2 syntax=dart :

