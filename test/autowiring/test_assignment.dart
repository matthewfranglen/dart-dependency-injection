part of dependency_injection.test.autowiring;

void testAssignment() {
  Scenario scenario = new Scenario("Autowired fields are set");

  scenario.load(new _AssignmentSteps());

  scenario
    .given("a configuration")
    .when("I call configure() on the configuration")
    .then("the bean is created")
    .test();

  scenario
    .given("a configuration")
    .when("I call configure() on the configuration")
    .then("the bean is autowired")
    .test();
}

class _AssignmentSteps {

  @Given("a configuration")
  void makeConfiguration(Map<String, dynamic> context, ContextFunction previous) {
    previous(context);
    _setConfiguration(context, new _AssignmentConfiguration());
  }

  @When("I call configure() on the configuration")
  void callConfigure(Map<String, dynamic> context, ContextFunction previous) {
    previous(context);
    _getConfiguration(context).configure();
  }

  @Then("the bean is created")
  void testBeanCreated(Map<String, dynamic> context, ContextFunction previous) {
    previous(context);
    expect(_getConfiguration(context).beanHasBeenCreated, isTrue);
  }

  @Then("the bean is autowired")
  void testBeanAutowired(Map<String, dynamic> context, ContextFunction previous) {
    previous(context);
    expect(_getConfiguration(context).beanHasBeenAutowired, isTrue);
  }

  void _setConfiguration(Map<String, dynamic> context, _AssignmentConfiguration configuration) {
    context["configuration"] = configuration;
  }

  _AssignmentConfiguration _getConfiguration(Map<String, dynamic> context) =>
    context["configuration"];
}

class _AssignmentConfiguration extends AbstractInjectConfiguration {

  bool beanHasBeenCreated, beanHasBeenAutowired;

  _AssignmentConfiguration()
    : beanHasBeenCreated = false,
      beanHasBeenAutowired = false;

  @bean String createBean() {
    beanHasBeenCreated = true;
    return 'bean';
  }

  @autowired void autowireBean(String bean) {
    beanHasBeenAutowired = true;
  }
}

// vim: set ai et sw=2 syntax=dart :
