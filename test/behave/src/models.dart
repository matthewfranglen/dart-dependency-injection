part of dependency_injection.test.behave;

// A function like before and after
typedef void ContextFunction(Map<String, dynamic> context);

// A function which is part of the test chain.
// The previous function links the chain of steps backwards, allowing tests such as expecting exceptions.
// It is expected that every test will call previous.
// The context object should be used to transmit state between steps.
typedef void StepFunction(Map<String, dynamic> context, ContextFunction previous);

typedef void _StepIndexFunction(StepIndex index);
typedef void _MethodMirrorFunction(MethodMirror method);
typedef void _ContextFunctionFunction(ContextFunction function);

class Scenario extends Object with GivenMixin, WhenMixin, ThenMixin {

  final Map<Type, StepIndex> _stepIndexByType;
  final List<ContextFunction> _before, _after;

  Scenario()
    : _before = [],
      _after = [],
      _stepIndexByType = {
        Given: new StepIndex(Given),
        When: new StepIndex(When),
        Then: new StepIndex(Then)
      };

  Step getStep(Type type, String statement) =>
    _stepIndexByType[type].steps[statement];

  void load(Object instance) {
    _stepIndexByType.values.forEach(_loadIntoIndex(instance));
  }

  ContextFunction asContextFunction() =>
    (Map<String, dynamic> context) {};

  void test(BaseState test) {
    Map<String, dynamic> context = {};

    _before.forEach(_invokeContextFunction(context));
    text.asContextFunction();
    _after.forEach(_invokeContextFunction(context));
  }

  _StepIndexFunction _loadIntoIndex(Object instance) =>
    (StepIndex index) {
      index.load(instance);
    };

  _ContextFunctionFunction _invokeContextFunction(Map<String, dynamic> context) =>
    (ContextFunction function) {
      function(context);
    };
}

class StepIndex {

  final Type type;
  final Map<String, Step> steps;

  StepIndex(this.type) : steps = {};

  void load(Object instance) {
    InstanceMirror mirror;

    mirror.type.declarations.values
      .where(_isMethod)
      .map(_castToMethodMirror)
      .where(DeclarationAnnotationFacade.filterByAnnotation(type))
      .forEach(_addStep(mirror));
  }

  static bool _isMethod(DeclarationMirror mirror) =>
    mirror is MethodMirror;

  static MethodMirror _castToMethodMirror(DeclarationMirror mirror) =>
    mirror as MethodMirror;

  _MethodMirrorFunction _addStep(InstanceMirror mirror) =>
    (MethodMirror method) {
      Step annotation =
        new DeclarationAnnotationFacade(method)
          .getAnnotationsOf(Step).first;

      steps[annotation.value] = new Step(mirror, method);
    };
}

class Step {

  final InstanceMirror _instance;
  final MethodMirror _method;

  Step(InstanceMirror instanceMirror, MethodMirror methodMirror)
    : _instance = instanceMirror,
      _method = methodMirror;

  void invoke(Map<String, dynamic> context, ContextFunction previous) {
    _instance.invoke(_method.simpleName, [context, previous]);
  }

  StepFunction asStepFunction() =>
    (Map<String, dynamic> context, ContextFunction previous) {
      invoke(context, previous);
    };

  ContextFunction asContextFunction(ContextFunction previous) =>
    (Map<String, dynamic> context) {
      invoke(context, previous);
    };
}

class BaseState {

  final Scenario scenario;
  final ContextFunction previous;
  final Step step;

  BaseState(this.scenario, this.previous, this.step);

  ContextFunction asContextFunction() =>
    step.asContextFunction(previous);

  void test() {
    scenario.test(this);
  }
}

class GivenState extends BaseState with WhenMixin, ThenMixin {

  GivenState(Scenario scenario, ContextFunction previous, String statement)
    : super(scenario, previous, scenario.getStep(Given, statement));

  GivenState and(String statement) =>
    new GivenState(scenario, asContextFunction(), statement);
}

class WhenState extends BaseState with ThenMixin {

  WhenState(Scenario scenario, ContextFunction previous, String statement)
    : super(scenario, previous, scenario.getStep(Given, statement));

  WhenState and(String statement) =>
    new WhenState(scenario, asContextFunction(), statement);
}

class ThenState extends BaseState {

  ThenState(Scenario scenario, ContextFunction previous, String statement)
    : super(scenario, previous, scenario.getStep(Given, statement));

  ThenState and(String statement) =>
    new ThenState(scenario, asContextFunction(), statement);
}

abstract class GivenMixin {

  Scenario get scenario;

  ContextFunction asContextFunction();

  GivenState given(String statement) =>
    new GivenState(scenario, asContextFunction(), statement);
}

abstract class WhenMixin {

  Scenario get scenario;
  ContextFunction get previous;
  Step get step;

  ContextFunction asContextFunction() =>
    step.asContextFunction(previous);

  WhenState when(String statement) =>
    new WhenState(scenario, asContextFunction(), statement);
}

abstract class ThenMixin {

  Scenario get scenario;
  ContextFunction get previous;
  Step get step;

  ContextFunction asContextFunction() =>
    step.asContextFunction(previous);

  ThenState then(String statement) =>
    new ThenState(scenario, asContextFunction(), statement);
}

// vim: set ai et sw=2 syntax=dart :
