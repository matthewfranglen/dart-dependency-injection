part of dependency_injection;

/// Controls the creation and registration of all [Bean] instances and populates [Autowired] fields, methods and setters.
///
/// Application configuration is performed by a subclass of this class.
/// Application configuration is the process of creating all beans and
/// providing beans for every autowired field.
///
/// This class must contain all the [Bean] creating methods. Such a method must
/// return a value and be annotated with _@Bean()_ or _@bean_. The type of the
/// bean is taken from the value of the returned object, not from the method
/// definition.
///
/// The configuration class will create all beans and inject them when it is
/// configured. You trigger this configuration by calling [configure].
///
/// A _Configuration Bean_ is a [Bean] which has a type with the
/// [Configuration] annotation. Configuration Beans can contain [Bean] creating
/// methods just like the [AbstractInjectConfiguration] subclass. The beans
/// created by a configuration bean are available to all classes for
/// autowiring. The configuration bean and all beans it creates are eligible
/// for autowiring.
///
/// Autowiring allows a method, setter or field to be provided with a bean.
/// Every bean and the [AbstractInjectConfiguration] subclass are eligible for
/// autowiring. Autowiring assigns by type. This is done by testing that the
/// bean can be assigned to the autowired field. When you define a method or
/// setter as autowired all of the parameters will be set to the appropriate
/// bean and then the method will be invoked.
///
/// When there are multiple beans that can be assigned to an autowired field
/// then the autowiring fails. If there are no beans then the autowiring also
/// fails. When the autowiring fails an exception is thrown.
///
/// For more details see the [Autowired] and [Bean] annotations.
///
///     class Configuration extends AbstractInjectConfiguration {
///       // This will get invoked and the result will be available as a bean
///       @bean ExampleSubClass makeBean() => new ExampleSubClass();
///
///       // This will get invoked with the bean created by makeBean
///       @bean ExampleMixin makeMixin(ExampleSubClass otherBean) => new ExampleMixin();
///
///       // This will get invoked with autowired arguments
///       @autowired void autowiredMethod(ExampleSubClass bean, ExampleMixin mixin) {}
///
///       // This will also get invoked with autowired arguments
///       @autowired set mixin(ExampleMixin mixin) {}
///
///       // This will NOT get set - no bean can be assigned to the parameter
///       @autowired String missingType;
///
///       // This will NOT get invoked - both beans can be assigned to the parameter
///       @autowired void ambiguousMethod(ExampleClass bean) {}
///     }
///     class ExampleClass {}
///     class ExampleSubClass extends ExampleClass {}
///     class ExampleMixin extends Object with ExampleClass {}
///
///     // This creates all the beans and autowires all fields, methods and setters.
///     // Since the ambiguousMethod cannot be autowired this will throw an exception.
///     new Configuration().configure();
class AbstractInjectConfiguration {

  BeanRepository _repo;
  BeanResolver _beans;

  AbstractInjectConfiguration() {
    _repo = new BeanRepository();
    _beans = new BeanResolver(_repo);
  }

  void addBean(Object bean) {
    BeanInstance wrappedBean = new BeanInstance(bean);
    _repo.add(wrappedBean);

    if (BeanLoader.isConfigurationBean(wrappedBean)) {
      _registerBeans(wrappedBean);
    }
  }

  void autowireBean(Object bean) {
    new AutowiredLoader()
      .load(bean)
      .forEach(_performAutowire);
  }

  void configure() {
    BeanInstance configurationBean = new BeanInstance(this);
    _repo.add(configurationBean);
    _registerBeans(configurationBean);
    _autowire();
  }

  void _registerBeans(BeanInstance configuration) {
    new BeanLoader.fromObject(configuration.instance)
      .load(_repo, _beans);
  }

  void _autowire() {
    AutowiredLoader loader = new AutowiredLoader();

    _repo.beans
      .map((BeanInstance bean) => bean.instance)
      .expand((Object bean) => loader.load(bean))
      .forEach(_performAutowire);
  }

  void _performAutowire(AutowiredInstance autowire) {
    if (autowire.required) {
      _autowireBean(autowire);
    }
    else {
      _optionallyAutowireBean(autowire);
    }
  }

  void _autowireBean(AutowiredInstance autowire) {
    autowire.autowire(_beans);
  }

  void _optionallyAutowireBean(AutowiredInstance autowire) {
    try {
      _autowireBean(autowire);
    }
    catch (exception) {
      print("Did not autowire ${autowire}: ${exception.message}");
    }
  }
}

class BeanLoader {

  final List<BeanMethod> _beansAwaitingConstruction;

  BeanLoader.fromObject(Object configuration) : this(reflect(configuration));

  BeanLoader(InstanceMirror configuration) :
    _beansAwaitingConstruction = [] {
      _findBeansAwaitingConstruction(configuration, configuration.type);
  }

  static bool isConfigurationBean(BeanInstance bean) =>
    new InstanceAnnotationFacade(bean.instance).hasAnnotationOf(Configuration);

  void _findBeansAwaitingConstruction(InstanceMirror configuration, ClassMirror type) {
    if (_isNotMixinEnhanced(type)) {
      type.declarations.values
        .where(_isMethod)
        .map(_castToMethodMirror)
        .where(DeclarationAnnotationFacade.filterByAnnotation(Bean))
        .map(_makeBeanMethod(configuration))
        .forEach(_beansAwaitingConstruction.add);
    }

    if (type.superclass != null) {
      _findBeansAwaitingConstruction(configuration, type.superclass);
    }
    type.superinterfaces.forEach((ClassMirror interface) {
      _findBeansAwaitingConstruction(configuration, interface);
    });
  }

  static bool _isNotMixinEnhanced(ClassMirror type) =>
    type.mixin == type;

  static bool _isMethod(DeclarationMirror mirror) =>
    mirror is MethodMirror;

  static MethodMirror _castToMethodMirror(DeclarationMirror mirror) =>
    mirror as MethodMirror;

  static _BeanMethodConstructor _makeBeanMethod(InstanceMirror configurationClass) =>
    (MethodMirror method) => new BeanMethod(configurationClass, method);

  void load(BeanRepository repo, BeanResolver beans) {
    while (_beansAwaitingConstruction.isNotEmpty) {
      BeanMethod method = _getNextInvokableBeanMethod(beans);
      BeanInstance bean = method.invoke(beans);
      repo.add(bean);
      if (isConfigurationBean(bean)) {
        _scanConfigurationBean(bean);
      }
      _beansAwaitingConstruction.remove(method);
    }
  }

  BeanMethod _getNextInvokableBeanMethod(BeanResolver beans) =>
    _beansAwaitingConstruction.firstWhere(
      (BeanMethod method) => method.canInvoke(beans)
    );

  void _scanConfigurationBean(BeanInstance bean) {
    InstanceMirror mirror = reflect(bean.instance);
    _findBeansAwaitingConstruction(mirror, mirror.type);
  }
}

class BeanResolver {

  final BeanRepository _repo;

  BeanResolver(this._repo);

  bool canResolve(VariableMirror target) => _repo.hasAssignableBean(target.type);

  dynamic resolve(VariableMirror target) =>
    _resolve(target.type, _getQualifiers(target));

  Iterable<Qualifier> _getQualifiers(VariableMirror target) =>
    new DeclarationAnnotationFacade(target)
      .getAnnotationsOf(Qualifier);

  dynamic _resolve(TypeMirror target, Iterable<Qualifier> qualifiers) {
    Iterable<BeanInstance> beans = _repo.getAssignableBeans(target);

    if (beans.isEmpty) {
      _noBeansFailure(target);
    }
    if (beans.length == 1) {
      return beans.first.instance;
    }

    if (beans.any((BeanInstance bean) => bean.isPrimary)) {
      beans = beans.where((BeanInstance bean) => bean.isPrimary);
    }

    if (qualifiers.isNotEmpty) {
      Iterable<String> qualifierNames =
        qualifiers.map((Qualifier qualifier) => qualifier.value);

      beans = beans.where((BeanInstance bean) => qualifierNames.contains(bean.name));
    }

    if (beans.isEmpty) {
      throw _noBeansFailure(target);
    }
    if (beans.length > 1) {
      throw _multipleBeansFailure(target);
    }
    return beans.first.instance;
  }

  Exception _noBeansFailure(TypeMirror target) =>
    new Exception("No @Bean for ${_getTypeName(target)}");

  Exception _multipleBeansFailure(TypeMirror target) =>
    new Exception("Multiple @Beans for ${_getTypeName(target)}");

  String _getTypeName(TypeMirror type) =>
    patch.getSymbolValue(type.simpleName);
}

class AutowiredLoader {

  AutowiredLoader();

  static _AutowiredInstanceConstructor _makeAutowiredInstance(InstanceMirror clazz) =>
    (DeclarationMirror declaration) => new AutowiredInstance(clazz, declaration);

  Iterable<AutowiredInstance> load(Object object) {
    InstanceMirror clazz = reflect(object);
    List<DeclarationMirror> result = [];

    _findAutowires(clazz.type, result);
    return result.map(_makeAutowiredInstance(clazz));
  }

  void _findAutowires(ClassMirror type, List<DeclarationMirror> autowires) {
    autowires.addAll(
      type.declarations.values
        .where(DeclarationAnnotationFacade.filterByAnnotation(Autowired))
    );

    if (type.superclass != null) {
      _findAutowires(type.superclass, autowires);
    }
    type.superinterfaces.forEach((ClassMirror interface) {
      _findAutowires(interface, autowires);
    });
  }
}

typedef BeanMethod _BeanMethodConstructor(MethodMirror mirror);
typedef AutowiredInstance _AutowiredInstanceConstructor(DeclarationMirror mirror);

// vim: set ai et sw=2 syntax=dart :
