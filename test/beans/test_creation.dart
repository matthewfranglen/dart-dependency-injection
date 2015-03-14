part of dependency_injection.test.beans;

void testCreation() {
  Scenario scenario = new Scenario("Beans are created");

  scenario.load(new _CreationSteps());

  scenario
    .given("a bean creating configuration")
    .when("I call configure() on the configuration")
    .then("the bean is created")
    .test();

  scenario
    .given("a duplicate bean creating configuration")
    .when("I call configure() on the configuration")
    .then("the beans are created")
    .test();
}

class _CreationSteps {

  @Given("a bean creating configuration")
  void makeSingleConfiguration(Map<String, dynamic> context) {
    _setConfiguration(context, new _CreationSingleConfiguration());
  }

  @Given("a duplicate bean creating configuration")
  void makeDuplicateConfiguration(Map<String, dynamic> context) {
    _setConfiguration(context, new _CreationDuplicateConfiguration());
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

  void _setConfiguration(Map<String, dynamic> context, _CreationConfiguration configuration) {
    context["configuration"] = configuration;
  }

  _CreationConfiguration _getConfiguration(Map<String, dynamic> context) =>
    context["configuration"];
}

// vim: set ai et sw=2 syntax=dart :
