part of dependency_injection.test.beans;

void testAutowiring() {
  Feature feature = new Feature("Beans are autowired");

  feature.load(new _AutowiringSteps());

  feature.scenario("A bean with an autowired field")
    .given("a configuration with a bean that has an autowired field")
    .when("I call configure() on the configuration")
    .then("the bean is created")
    .and("the bean is internally autowired")
    .test();

  feature.scenario("A bean with an autowired setter")
    .given("a configuration with a bean that has an autowired setter")
    .when("I call configure() on the configuration")
    .then("the bean is created")
    .and("the bean is internally autowired")
    .test();

  feature.scenario("A bean with an autowired method")
    .given("a configuration with a bean that has an autowired method")
    .when("I call configure() on the configuration")
    .then("the bean is created")
    .and("the bean is internally autowired")
    .test();
}

class _AutowiringSteps {

  @Given("a configuration with a bean that has an autowired field")
  void makeFieldConfiguration(Map<String, dynamic> context) {
    _setConfiguration(context, new _AutowiredBeanFieldConfiguration());
  }

  @Given("a configuration with a bean that has an autowired setter")
  void makeSetterConfiguration(Map<String, dynamic> context) {
    _setConfiguration(context, new _AutowiredBeanSetterConfiguration());
  }

  @Given("a configuration with a bean that has an autowired method")
  void makeMethodConfiguration(Map<String, dynamic> context) {
    _setConfiguration(context, new _AutowiredBeanMethodConfiguration());
  }

  @When("I call configure() on the configuration")
  void callConfigure(Map<String, dynamic> context) {
    _getConfiguration(context).configure();
  }

  @Then("the bean is created")
  void testBeanCreated(Map<String, dynamic> context) {
    expect(_getConfiguration(context).beanHasBeenCreated, isTrue);
  }

  @Then("the bean is internally autowired")
  void testBeanAutowired(Map<String, dynamic> context) {
    expect(_getConfiguration(context).autowiredBean.beanHasBeenAutowired, isTrue);
  }

  void _setConfiguration(Map<String, dynamic> context, _AutowiredBeanConfiguration configuration) {
    context["configuration"] = configuration;
  }

  _AutowiredBeanConfiguration _getConfiguration(Map<String, dynamic> context) =>
    context["configuration"];
}

// vim: set ai et sw=2 syntax=dart :
