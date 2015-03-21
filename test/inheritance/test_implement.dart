part of dependency_injection.test.inheritance;

void testImplement() {
  Feature feature = new Feature("Autowired fields, setters and methods from implemented interface are set");

  feature.load(new _ImplementSteps());

  feature.scenario("A configuration which implements another")
    .given("a configuration with an interface with beans")
    .when("I call configure() on the configuration")
    .then("the bean is created")
    .and("the bean is autowired")
    .test();

  feature.scenario("A configuration which implements another")
    .given("a configuration with an interface with autowires")
    .when("I call configure() on the configuration")
    .then("the bean is created")
    .and("the bean is autowired")
    .test();

  feature.scenario("A configuration which implements another")
    .given("a configuration with an interface with beans and autowires")
    .when("I call configure() on the configuration")
    .then("the bean is created")
    .and("the bean is autowired")
    .test();
}

class _ImplementSteps {

  @Given("a configuration with an interface with beans")
  void makeImplementBeanConfiguration(Map<String, dynamic> context) {
    _setConfiguration(context, new _ImplementBeanConfiguration());
  }

  @Given("a configuration with an interface with autowires")
  void makeImplementAutowireConfiguration(Map<String, dynamic> context) {
    _setConfiguration(context, new _ImplementAutowireConfiguration());
  }

  @Given("a configuration with an interface with beans and autowires")
  void makeImplementBeanAutowireConfiguration(Map<String, dynamic> context) {
    _setConfiguration(context, new _ImplementBeanAutowireConfiguration());
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
