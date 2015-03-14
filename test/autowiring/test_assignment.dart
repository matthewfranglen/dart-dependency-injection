part of dependency_injection.test.autowiring;

void testAssignment() {
  Scenario scenario = new Scenario("Autowired fields, setters and methods are set");

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

  scenario
    .given("an autowired configuration where the type is permissive")
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

  @Given("an autowired configuration where the type is permissive")
  void makePermissiveConfiguration(Map<String, dynamic> context) {
    _setConfiguration(context, new _AssignmentAutowireSuperTypeConfiguration());
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

// vim: set ai et sw=2 syntax=dart :
