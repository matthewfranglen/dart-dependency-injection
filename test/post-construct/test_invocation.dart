part of dependency_injection.test.post_construct;

void testInvocation() {
  Feature feature = new Feature("Beans are initialized after construction and autowiring");

  feature.load(new _InvocationSteps());

  feature.scenario("A bean with a post construct method")
    .given("a configuration with a bean containing a @PostConstruct method")
    .when("I call configure() on the configuration")
    .then("the bean @PostConstruct method is invoked")
    .test();

  feature.scenario("A configuration with a post construct method")
    .given("a configuration containing a @PostConstruct method")
    .when("I call configure() on the configuration")
    .then("the @PostConstruct method is invoked")
    .test();

  feature.scenario("A configuration with a post construct method with an argument")
    .given("a configuration containing a @PostConstruct method")
    .when("I call configure() on the configuration")
    .then("the @PostConstruct method is invoked")
    .test();
}

class _InvocationSteps {

  @Given("a configuration with a bean containing a @PostConstruct method")
  void makeConfiguration(Map<String, dynamic> context) {
    _PostConstructConfiguration configuration = new _PostConstructConfiguration();
    context["configuration"] = configuration;
  }

  @Given("a configuration containing a @PostConstruct method")
  void makeConfigurationWithMethod(Map<String, dynamic> context) {
    _PostConstructConfigurationWithMethod configuration = new _PostConstructConfigurationWithMethod();
    context["configuration"] = configuration;
  }

  @Given("a configuration containing a @PostConstruct method with an argument")
  void makeConfigurationWithArgument(Map<String, dynamic> context) {
    _PostConstructConfigurationWithMethod configuration = new _PostConstructConfigurationWithMethod();
    context["configuration"] = configuration;
  }

  @When("I call configure() on the configuration")
  void callConfigure(Map<String, dynamic> context) {
    (context["configuration"] as AbstractInjectConfiguration)
      .configure();
  }

  @Then("the bean @PostConstruct method is invoked")
  void testBeanInitialized(Map<String, dynamic> context) {
    _PostConstructConfiguration configuration = context["configuration"] as _PostConstructConfiguration;
    expect(configuration.postConstructBean.postConstructMethodCalled, isTrue);
  }

  @Then("the @PostConstruct method is invoked")
  void testConfigurationInitialized(Map<String, dynamic> context) {
    _PostConstructConfigurationWithMethod configuration = context["configuration"] as _PostConstructConfigurationWithMethod;
    expect(configuration.postConstructMethodCalled, isTrue);
  }
}

// vim: set ai et sw=2 syntax=dart :
