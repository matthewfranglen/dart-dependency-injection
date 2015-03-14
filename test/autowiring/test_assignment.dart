part of dependency_injection.test.autowiring;

void testAssignment() {
  Scenario scenario = new Scenario("Autowired fields are set");

  scenario.load(new _AssignmentSteps());

  scenario
    .given("a field autowired configuration")
    .when("I call configure() on the configuration")
    .then("the bean is created")
    .and("the bean is autowired")
    .test();

  scenario
    .given("a setter autowired configuration")
    .when("I call configure() on the configuration")
    .then("the bean is created")
    .and("the bean is autowired")
    .test();

  scenario
    .given("a method autowired configuration")
    .when("I call configure() on the configuration")
    .then("the bean is created")
    .and("the bean is autowired")
    .test();
}

class _AssignmentSteps {

  @Given("a field autowired configuration")
  void makeFieldConfiguration(Map<String, dynamic> context) {
    _setConfiguration(context, new _AssignmentAutowireFieldConfiguration());
  }

  @Given("a setter autowired configuration")
  void makeSetterConfiguration(Map<String, dynamic> context) {
    _setConfiguration(context, new _AssignmentAutowireSetterConfiguration());
  }

  @Given("a method autowired configuration")
  void makeMethodConfiguration(Map<String, dynamic> context) {
    _setConfiguration(context, new _AssignmentAutowireMethodConfiguration());
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

  void _setConfiguration(Map<String, dynamic> context, _AssignmentConfiguration configuration) {
    context["configuration"] = configuration;
  }

  _AssignmentConfiguration _getConfiguration(Map<String, dynamic> context) =>
    context["configuration"];
}

abstract class _AssignmentConfiguration extends AbstractInjectConfiguration {
  bool get beanHasBeenCreated;
  bool get beanHasBeenAutowired;
}

class _AssignmentAutowireFieldConfiguration extends _AssignmentConfiguration {

  bool beanHasBeenCreated;

  @autowired String mockBean;

  _AssignmentAutowireFieldConfiguration()
    : beanHasBeenCreated = false,
      mockBean = null;

  @bean String createBean() {
    beanHasBeenCreated = true;
    return 'bean';
  }

  bool get beanHasBeenAutowired => mockBean != null;
}

class _AssignmentAutowireSetterConfiguration extends _AssignmentConfiguration {

  bool beanHasBeenCreated, beanHasBeenAutowired;

  _AssignmentAutowireSetterConfiguration()
    : beanHasBeenCreated = false,
      beanHasBeenAutowired = false;

  @bean String createBean() {
    beanHasBeenCreated = true;
    return 'bean';
  }

  @autowired set mockBean(String bean) {
    beanHasBeenAutowired = true;
  }
}

class _AssignmentAutowireMethodConfiguration extends _AssignmentConfiguration {

  bool beanHasBeenCreated, beanHasBeenAutowired;

  _AssignmentAutowireMethodConfiguration()
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
