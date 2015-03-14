part of dependency_injection.test.autowiring;

void testOptional() {
  Scenario scenario = new Scenario("Optional autowired fields can be skipped");

  scenario.load(new _OptionalSteps());

  scenario
    .given("a configuration with an optional autowire and no assignable beans")
    .when("I call configure() on the configuration")
    .then("no exception is thrown")
    .and("the bean is not autowired")
    .test();

  scenario
    .given("a configuration with an optional autowire and two assignable beans")
    .when("I call configure() on the configuration")
    .then("no exception is thrown")
    .and("the bean is not autowired")
    .test();

  scenario
    .given("a configuration with an optional autowire and an assignable bean")
    .when("I call configure() on the configuration")
    .then("the bean is created")
    .and("the bean is autowired")
    .test();
}

class _OptionalSteps {

  @Given("a configuration with an optional autowire and no assignable beans")
  void makeOptionalAutowireConfiguration(Map<String, dynamic> context) {
    _setConfiguration(context, new _OptionalNoBeanConfiguration());
  }

  @Given("a configuration with an optional autowire and two assignable beans")
  void makeOptionalAutowireDuplicateBeanConfiguration(Map<String, dynamic> context) {
    _setConfiguration(context, new _OptionalDuplicateBeanConfiguration());
  }

  @Given("a configuration with an optional autowire and an assignable bean")
  void makeOptionalAutowireValidConfiguration(Map<String, dynamic> context) {
    _setConfiguration(context, new _OptionalValidConfiguration());
  }

  @When("I call configure() on the configuration")
  void callConfigure(Map<String, dynamic> context) {
    _getConfiguration(context).configure();
  }

  @Then("no exception is thrown")
  void testNoExceptionThrown(Map<String, dynamic> context, ContextFunction previous) {
    expect(() => previous(context), returnsNormally);
  }

  @Then("the bean is created")
  void testBeanCreated(Map<String, dynamic> context) {
    _OptionalValidConfiguration configuration = context["configuration"];
    expect(configuration.beanHasBeenCreated, isTrue);
  }

  @Then("the bean is autowired")
  void testBeanAutowired(Map<String, dynamic> context) {
    expect(_getConfiguration(context).beanHasBeenAutowired, isTrue);
  }

  @Then("the bean is not autowired")
  void testBeanNotAutowired(Map<String, dynamic> context) {
    expect(_getConfiguration(context).beanHasBeenAutowired, isFalse);
  }

  void _setConfiguration(Map<String, dynamic> context, _OptionalConfiguration configuration) {
    context["configuration"] = configuration;
  }

  _OptionalConfiguration _getConfiguration(Map<String, dynamic> context) =>
    context["configuration"];
}

// vim: set ai et sw=2 syntax=dart :
