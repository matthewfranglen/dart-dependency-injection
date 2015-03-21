part of dependency_injection.test.post_configure;

void testAutowire() {
  Feature feature = new Feature("Beans are autowired after configuration");

  feature.load(new _AutowireSteps());

  feature.scenario("A bean with an autowired field")
    .given("a configured configuration")
    .when("I autowire a bean with an autowired field")
    .then("the bean is internally autowired")
    .test();

  feature.scenario("A bean with an autowired setter")
    .given("a configured configuration")
    .when("I autowire a bean with an autowired setter")
    .then("the bean is internally autowired")
    .test();

  feature.scenario("A bean with an autowired method")
    .given("a configured configuration")
    .when("I autowire a bean with an autowired method")
    .then("the bean is internally autowired")
    .test();
}

class _AutowireSteps {

  @Given("a configured configuration")
  void makeConfiguration(Map<String, dynamic> context) {
    _AutowiredConfiguration config = new _AutowiredConfiguration();
    config.configure();

    _setConfiguration(context, config);
  }

  @When("I autowire a bean with an autowired field")
  void autowireFieldBean(Map<String, dynamic> context) {
    _setBean(context, new _AutowiredFieldBean());
    _getConfiguration(context).autowireBean(_getBean(context));
  }

  @When("I autowire a bean with an autowired setter")
  void autowireSetterBean(Map<String, dynamic> context) {
    _setBean(context, new _AutowiredSetterBean());
    _getConfiguration(context).autowireBean(_getBean(context));
  }

  @When("I autowire a bean with an autowired method")
  void autowireMethodBean(Map<String, dynamic> context) {
    _setBean(context, new _AutowiredMethodBean());
    _getConfiguration(context).autowireBean(_getBean(context));
  }

  @Then("the bean is internally autowired")
  void testBeanAutowired(Map<String, dynamic> context) {
    expect(_getBean(context).beanHasBeenAutowired, isTrue);
  }

  void _setConfiguration(Map<String, dynamic> context, _AutowiredConfiguration configuration) {
    context["configuration"] = configuration;
  }

  _AutowiredConfiguration _getConfiguration(Map<String, dynamic> context) =>
    context["configuration"];

  void _setBean(Map<String, dynamic> context, _AutowiredBean bean) {
    context["bean"] = bean;
  }

  _AutowiredBean _getBean(Map<String, dynamic> context) =>
    context["bean"];
}

// vim: set ai et sw=2 syntax=dart :
