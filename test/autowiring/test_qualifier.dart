part of dependency_injection.test.autowiring;

void testQualifier() {
  Feature feature = new Feature("Autowired fields prefer primary beans");

  feature.load(new _QualifierSteps());

  feature.scenario("A qualified autowire and a named bean")
    .given("a qualified autowired configuration with two beans, one of which is named")
    .when("I call configure() on the configuration")
    .then("the beans are created")
    .and("the bean is autowired")
    .test();

  feature.scenario("A qualified autowire and a named primary bean")
    .given("a qualified autowired configuration with two named beans, one of which is primary")
    .when("I call configure() on the configuration")
    .then("the beans are created")
    .and("the bean is autowired")
    .test();
}

class _QualifierSteps {

  @Given("a qualified autowired configuration with two beans, one of which is named")
  void makeNamedConfiguration(Map<String, dynamic> context) {
    _setConfiguration(context, new _QualifiedNamedConfiguration());
  }

  @Given("a qualified autowired configuration with two named beans, one of which is primary")
  void makePrimaryConfiguration(Map<String, dynamic> context) {
    _setConfiguration(context, new _QualifiedPrimaryConfiguration());
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

  @Then("the bean is autowired")
  void testBeanAutowired(Map<String, dynamic> context) {
    expect(_getConfiguration(context).beanHasBeenAutowired, isTrue);
  }

  void _setConfiguration(Map<String, dynamic> context, _QualifiedConfiguration configuration) {
    context["configuration"] = configuration;
  }

  _QualifiedConfiguration _getConfiguration(Map<String, dynamic> context) =>
    context["configuration"];
}

// vim: set ai et sw=2 syntax=dart :
