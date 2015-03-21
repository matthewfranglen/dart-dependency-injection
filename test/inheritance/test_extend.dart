part of dependency_injection.test.inheritance;

void testExtend() {
  Feature feature = new Feature("Autowired fields, setters and methods from extended class are set");

  feature.load(new _ExtendSteps());

  feature.scenario("A configuration which extends another")
    .given("a configuration with a superclass with beans")
    .when("I call configure() on the configuration")
    .then("the bean is created")
    .and("the bean is autowired")
    .test();

  feature.scenario("A configuration which extends another")
    .given("a configuration with a superclass with autowires")
    .when("I call configure() on the configuration")
    .then("the bean is created")
    .and("the bean is autowired")
    .test();

  feature.scenario("A configuration which extends another")
    .given("a configuration with a superclass with beans and autowires")
    .when("I call configure() on the configuration")
    .then("the bean is created")
    .and("the bean is autowired")
    .test();
}

class _ExtendSteps {

  @Given("a configuration with a superclass with beans")
  void makeBeanConfiguration(Map<String, dynamic> context) {
    _setConfiguration(context, new _ExtendBeanConfiguration());
  }

  @Given("a configuration with a superclass with autowires")
  void makeAutowireConfiguration(Map<String, dynamic> context) {
    _setConfiguration(context, new _ExtendAutowireConfiguration());
  }

  @Given("a configuration with a superclass with beans and autowires")
  void makeBeanAutowireConfiguration(Map<String, dynamic> context) {
    _setConfiguration(context, new _ExtendBeanAutowireConfiguration());
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
