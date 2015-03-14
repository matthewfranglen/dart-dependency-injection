part of dependency_injection.test.autowiring;

void testPrimary() {
  Scenario scenario = new Scenario("Autowired fields prefer primary beans");

  scenario.load(new _PrimarySteps());

  scenario
    .given("an autowired configuration with two beans, one of which is primary")
    .when("I call configure() on the configuration")
    .then("the beans are created")
    .and("the bean is autowired")
    .test();
}

class _PrimarySteps {

  @Given("an autowired configuration with two beans, one of which is primary")
  void makeFieldConfiguration(Map<String, dynamic> context) {
    _setConfiguration(context, new _PrimaryConfiguration());
  }

  @When("I call configure() on the configuration")
  void callConfigure(Map<String, dynamic> context) {
    _getConfiguration(context).configure();
  }

  @Then("the bean is created")
  @Then("the beans are created")
  void testBeanCreated(Map<String, dynamic> context) {
    expect(_getConfiguration(context).beanHasBeenCreated, isTrue);
  }

  @Then("the bean is autowired")
  void testBeanAutowired(Map<String, dynamic> context) {
    expect(_getConfiguration(context).beanHasBeenAutowired, isTrue);
  }

  void _setConfiguration(Map<String, dynamic> context, _PrimaryConfiguration configuration) {
    context["configuration"] = configuration;
  }

  _PrimaryConfiguration _getConfiguration(Map<String, dynamic> context) =>
    context["configuration"];
}

// vim: set ai et sw=2 syntax=dart :
