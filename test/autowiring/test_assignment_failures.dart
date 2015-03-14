part of dependency_injection.test.autowiring;

void testAssignmentFailures() {
  Scenario scenario = new Scenario("Autowiring beans can fail");

  scenario.load(new _AssignmentFailureSteps());

  scenario
    .given("a configuration with an autowire that matches no bean")
    .when("I call configure() on the configuration")
    .then("an exception is thrown")
    .test();

  scenario
    .given("a configuration with two beans for an autowire")
    .when("I call configure() on the configuration")
    .then("an exception is thrown")
    .test();

  scenario
    .given("a configuration with two primary beans for an autowire")
    .when("I call configure() on the configuration")
    .then("an exception is thrown")
    .test();

  scenario
    .given("a configuration with an exception throwing autowire method")
    .when("I call configure() on the configuration")
    .then("an exception is thrown")
    .test();
}

class _AssignmentFailureSteps {

  @Given("a configuration with an autowire that matches no bean")
  void makeIncompatibleTypeConfiguration(Map<String, dynamic> context) {
    _setConfiguration(context, new _AssignmentFailureIncompatibleTypeConfiguration());
  }

  @Given("a configuration with two beans for an autowire")
  void makeMultipleBeanConfiguration(Map<String, dynamic> context) {
    _setConfiguration(context, new _AssignmentFailureMultipleBeanConfiguration());
  }

  @Given("a configuration with two primary beans for an autowire")
  void makeMultiplePrimaryBeanConfiguration(Map<String, dynamic> context) {
    _setConfiguration(context, new _AssignmentFailureMultiplePrimaryBeanConfiguration());
  }

  @Given("a configuration with an exception throwing autowire method")
  void makeExceptionThrowingConfiguration(Map<String, dynamic> context) {
    _setConfiguration(context, new _AssignmentFailureExceptionThrowingConfiguration());
  }

  @When("I call configure() on the configuration")
  void callConfigure(Map<String, dynamic> context) {
    _getConfiguration(context).configure();
  }

  @Then("an exception is thrown")
  void testExceptionThrown(Map<String, dynamic> context, ContextFunction previous) {
    expect(() => previous(context), throws);
  }

  void _setConfiguration(Map<String, dynamic> context, AbstractInjectConfiguration configuration) {
    context["configuration"] = configuration;
  }

  AbstractInjectConfiguration _getConfiguration(Map<String, dynamic> context) =>
    context["configuration"];
}

// vim: set ai et sw=2 syntax=dart :
