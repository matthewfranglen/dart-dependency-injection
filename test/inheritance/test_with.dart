part of dependency_injection.test.inheritance;

void testWith() {
  Feature feature = new Feature("Autowired fields, setters and methods from mixin are set");

  feature.load(new _WithSteps());

  feature.scenario("A configuration which applies another as a mixin")
    .given("a configuration with a mixin with beans")
    .when("I call configure() on the configuration")
    .then("the bean is created")
    .and("the bean is autowired")
    .test();

  feature.scenario("A configuration which applies another as a mixin")
    .given("a configuration with a mixin with autowires")
    .when("I call configure() on the configuration")
    .then("the bean is created")
    .and("the bean is autowired")
    .test();

  feature.scenario("A configuration which applies another as a mixin")
    .given("a configuration with a mixin with beans and autowires")
    .when("I call configure() on the configuration")
    .then("the bean is created")
    .and("the bean is autowired")
    .test();
}

class _WithSteps {

  @Given("a configuration with a mixin with beans")
  void makeWithBeanConfiguration(Map<String, dynamic> context) {
    _setConfiguration(context, new _WithBeanConfiguration());
  }

  @Given("a configuration with a mixin with autowires")
  void makeWithAutowireConfiguration(Map<String, dynamic> context) {
    _setConfiguration(context, new _WithAutowireConfiguration());
  }

  @Given("a configuration with a mixin with beans and autowires")
  void makeWithBeanAutowireConfiguration(Map<String, dynamic> context) {
    _setConfiguration(context, new _WithBeanAutowireConfiguration());
  }

  @When("I call configure() on the configuration")
  void callConfigure(Map<String, dynamic> context) {
    _getConfiguration(context).configure();
  }

  @Then("the bean is created")
  void testBeanCreated(Map<String, dynamic> context) {
    expect(_getConfiguration(context).beanHasBeenCreated, isTrue);
  }

  @Then("the bean is autowired")
  void testBeanAutowired(Map<String, dynamic> context) {
    expect(_getConfiguration(context).beanHasBeenAutowired, isTrue);
  }

  void _setConfiguration(Map<String, dynamic> context, _BaseConfiguration configuration) {
    context["configuration"] = configuration;
  }

  _BaseConfiguration _getConfiguration(Map<String, dynamic> context) =>
    context["configuration"];
}

// vim: set ai et sw=2 syntax=dart :
