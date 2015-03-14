part of dependency_injection.test.behave;

typedef void ContextFunction(Map<String, dynamic> context);

typedef void _StepIndexFunction(StepIndex index);
typedef void _MethodMirrorFunction(MethodMirror method);
typedef void _ContextFunctionFunction(ContextFunction function);

class Scenario extends Object {

  final String description;
  final Map<Type, StepIndex> _stepIndexByType;
  final List<ContextFunction> _before, _after;

  Scenario(this.description)
    : _before = [],
      _after = [],
      _stepIndexByType = {
        Given: new StepIndex(Given),
        When: new StepIndex(When),
        Then: new StepIndex(Then)
      };

  Step getStep(Type type, String statement) =>
    _stepIndexByType[type].getStep(statement);

  GivenState given(String statement) =>
    new GivenState(this, null, "Given", statement);

  WhenState when(String statement) =>
    new WhenState(this, null, "When", statement);

  ThenState then(String statement) =>
    new ThenState(this, null, "Then", statement);

  void load(Object instance) {
    _stepIndexByType.values.forEach(_loadIntoIndex(instance));
  }

  ContextFunction asContextFunction() =>
    (Map<String, dynamic> context) {};

  void test(BaseState test) {
    Map<String, dynamic> context = {};

    unittest.test(createTestName(test), () {
      _before.forEach(_invokeContextFunction(context));
      test.asContextFunction()(context);
      _after.forEach(_invokeContextFunction(context));
    });
  }

  _StepIndexFunction _loadIntoIndex(Object instance) =>
    (StepIndex index) {
      index.load(instance);
    };

  _ContextFunctionFunction _invokeContextFunction(Map<String, dynamic> context) =>
    (ContextFunction function) {
      function(context);
    };

  String createTestName(BaseState test) =>
    "Scenario: ${description}\n${test.description}";
}

class StepIndex {

  final Type type;
  final Map<String, Step> steps;

  StepIndex(this.type) : steps = {};

  void load(Object instance) {
    InstanceMirror instanceMirror = reflect(instance);

    instanceMirror.type.declarations.values
      .where(_isMethod)
      .map(_castToMethodMirror)
      .where(DeclarationAnnotationFacade.filterByAnnotation(type))
      .forEach(_addStep(instanceMirror));
  }

  Step getStep(String statement) {
    if (steps.containsKey(statement)) {
      return steps[statement];
    }
    throw new Exception("Method @${type}('${statement}') not defined");
  }

  static bool _isMethod(DeclarationMirror mirror) =>
    mirror is MethodMirror;

  static MethodMirror _castToMethodMirror(DeclarationMirror mirror) =>
    mirror as MethodMirror;

  _MethodMirrorFunction _addStep(InstanceMirror mirror) =>
    (MethodMirror method) {
      new DeclarationAnnotationFacade(method)
        .getAnnotationsOf(type)
        .forEach((BehaveAnnotation annotation) {
          steps[annotation.value] = new Step(mirror, method);
        });
    };
}

class Step {

  final InstanceMirror _instance;
  final MethodMirror _method;

  Step(InstanceMirror instanceMirror, MethodMirror methodMirror)
    : _instance = instanceMirror,
      _method = methodMirror;

  void invoke(Map<String, dynamic> context, ContextFunction previous) {
    if (_method.parameters.length == 1) {
      // Methods that don't take the previous argument just want it called prior to invocation
      previous(context);
      _instance.invoke(_method.simpleName, [context]);
    }
    else {
      _instance.invoke(_method.simpleName, [context, previous]);
    }
  }

  ContextFunction asContextFunction(ContextFunction previous) =>
    (Map<String, dynamic> context) {
      invoke(context, previous);
    };
}

class BaseState {

  final Scenario scenario;
  final BaseState previous;
  final Step step;
  final String prefix;
  final String statement;

  BaseState(this.scenario, this.previous, this.step, this.prefix, this.statement);

  ContextFunction asContextFunction() =>
    step.asContextFunction(_asContextFunction(previous));

  static ContextFunction _asContextFunction(BaseState state) =>
    state != null ? state.asContextFunction() : _emptyContextFunction;

  static void _emptyContextFunction(Map<String, dynamic> context) {}

  void test() {
    scenario.test(this);
  }

  String get _previousDescription {
    if (previous == null) {
      return '';
    }
    return "${previous.description}";
  }

  String get description =>
    "${_previousDescription}${prefix.padLeft(9)} ${statement}\n";
}

class GivenState extends BaseState with WhenMixin, ThenMixin {

  GivenState(Scenario scenario, BaseState previous, String prefix, String statement)
    : super(scenario, previous, scenario.getStep(Given, statement), prefix, statement);

  GivenState and(String statement) =>
    new GivenState(scenario, this, "And", statement);
}

class WhenState extends BaseState with ThenMixin {

  WhenState(Scenario scenario, BaseState previous, String prefix, String statement)
    : super(scenario, previous, scenario.getStep(When, statement), prefix, statement);

  WhenState and(String statement) =>
    new WhenState(scenario, this, "And", statement);
}

class ThenState extends BaseState {

  ThenState(Scenario scenario, BaseState previous, String prefix, String statement)
    : super(scenario, previous, scenario.getStep(Then, statement), prefix, statement);

  ThenState and(String statement) =>
    new ThenState(scenario, this, "And", statement);
}

abstract class GivenMixin implements BaseState {

  Scenario get scenario;

  GivenState given(String statement) =>
    new GivenState(scenario, null, "Given", statement);
}

abstract class WhenMixin implements BaseState {

  Scenario get scenario;

  WhenState when(String statement) =>
    new WhenState(scenario, this, "When", statement);
}

abstract class ThenMixin implements BaseState {

  Scenario get scenario;

  ThenState then(String statement) =>
    new ThenState(scenario, this, "Then", statement);
}

// vim: set ai et sw=2 syntax=dart :
