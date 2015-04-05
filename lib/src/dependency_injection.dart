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

  /// This triggers the creation of all beans and the autowiring of all methods, setters and fields.
  ///
  /// All [bean] annotated methods on this configuration are invoked. The
  /// object returned by the method is registered as a bean. If any of them
  /// return a configuration bean then all contained [bean] annotated methods
  /// are invoked. This can repeat to any depth.
  ///
  /// The [bean] annotated methods can have parameters. All parameters are
  /// resolved using the existing registered beans. If it is not possible to
  /// resolve the parameters for a [bean] annotated method then this method
  /// will throw an exception.
  ///
  /// Once all beans have been created autowiring starts. Every [bean] is
  /// inspected for methods, setters and fields with the [autowired]
  /// annotation. Those methods and setters are invoked and the fields are set
  /// with arguments resolved from the loaded beans.
  ///
  /// The resolution of a bean for an autowire works based on [Type]. If the
  /// [Type] of the bean can be assigned to the [Type] of the autowired
  /// argument or field then the bean will be used to invoke the method or
  /// setter or to set the field.
  ///
  /// If there are no eligible beans for an autowired argument or field then an
  /// exception will be thrown.
  ///
  /// If there are multiple eligible beans for an autowired argument or field
  /// then an exception will be thrown. To resolve this situation use the
  /// [Primary] and [Qualifier] annotations.
  void configure() {
    BeanInstance configurationBean = new BeanInstance(this);
    _repo.add(configurationBean);
    _registerBeans(configurationBean);
    _autowire();
  }

  /// Adds a bean to the [BeanRepository].
  ///
  /// The bean passed to this object is registered manually and as such does
  /// not need to come from a [Bean] annotated method.
  ///
  /// If the bean is added before [configure] is called then it will be
  /// autowired. To manually autowire the bean call [autowireBean].
  ///
  ///     new Configuration()
  ///       ..addBean(object)
  ///       ..configure();
  void addBean(Object bean) {
    BeanInstance wrappedBean = new BeanInstance(bean);
    _repo.add(wrappedBean);

    if (BeanLoader.isConfigurationBean(wrappedBean)) {
      _registerBeans(wrappedBean);
    }
  }

  /// Autowire all annotated methods, setters and fields on the provided object.
  ///
  /// The object passed to this is fully autowired in the same way that the
  /// beans are autowired when [configure] is called. The object passed to this
  /// does not need to be a registered bean.
  ///
  /// It is not a good idea to call this on an object which is registered as a
  /// bean before the [configure] method is called. Such a bean would end up
  /// getting autowired two times.
  ///
  /// Autowiring a configuration bean with this method does not trigger the
  /// creation or autowiring of the contained beans.
  ///
  ///     new Configuration()
  ///       ..configure()
  ///       ..autowireBean(object);
  void autowireBean(Object bean) {
    new AutowiredLoader()
      .load(bean)
      .forEach(_performAutowire);
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

/// Used to create beans from [Bean] annotated methods and load them into the [BeanRepository].
///
///     BeanRepository repo;
///     BeanResolver beans;
///
///     new BeanLoader(reflect(object))
///       .load(repo, beans);
class BeanLoader {

  final List<BeanMethod> _beansAwaitingConstruction;

  BeanLoader.fromObject(Object configuration) : this(reflect(configuration));

  /// Inspects the configuration provided registering any [BeanMethod] available.
  ///
  ///     new BeanLoader(reflect(object));
  BeanLoader(InstanceMirror configuration) :
    _beansAwaitingConstruction = [] {
      _findBeansAwaitingConstruction(configuration, configuration.type);
  }

  static bool isConfigurationBean(BeanInstance bean) =>
    new InstanceAnnotationFacade(bean.instance).hasAnnotationOf(Configuration);

  /// Loads every [BeanMethod] registered in the loader.
  ///
  /// This handles beans which require other beans by performing a simple
  /// topological sort. If there are any cycles between bean creating methods
  /// then the sort will fail.
  ///
  /// The order in which each [BeanMethod] is invoked is not fixed. If multiple
  /// beans can be created of the same Type and another [BeanMethod] requires
  /// that Type as a parameter then bean loading may nor may not fail. You
  /// should not rely upon the order in which the beans are created.
  ///
  ///     BeanRepository repo;
  ///     BeanResolver beans;
  ///
  ///     new BeanLoader(reflect(object))
  ///       .load(repo, beans);
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

  static bool _isNotMixinEnhanced(ClassMirror type) {
    // TODO: On firefox the ClassMirror.mixin getter is unimplemented.
    // This functionality is currently used to spot mixin application. Mixin
    // application seems to alter the class heirarchy leading to some doubling
    // of the Types. This method was used to ignore the classes in the
    // heirarchy that are the result of the combination of the mixin and the
    // base class. Another way will need to be found to handle this.
    try {
      return type.mixin == type;
    }
    catch (exception) {
      return true;
    }
  }

  static bool _isMethod(DeclarationMirror mirror) =>
    mirror is MethodMirror;

  static MethodMirror _castToMethodMirror(DeclarationMirror mirror) =>
    mirror as MethodMirror;

  static _BeanMethodConstructor _makeBeanMethod(InstanceMirror configurationClass) =>
    (MethodMirror method) => new BeanMethod(configurationClass, method);

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

  BeanMethod _getNextInvokableBeanMethod(BeanResolver beans) =>
    _beansAwaitingConstruction.firstWhere(
      (BeanMethod method) => method.canInvoke(beans)
    );

  void _scanConfigurationBean(BeanInstance bean) {
    InstanceMirror mirror = reflect(bean.instance);
    _findBeansAwaitingConstruction(mirror, mirror.type);
  }
}

/// Used to resolve available beans for a field or parameter.
///
///     BeanRepository repo;
///
///     new BeanResolver(repo)
///       .canResolve(variableMirror);
class BeanResolver {

  final BeanRepository _repo;

  BeanResolver(this._repo);

  /// Test if there is at least one available bean that can be assigned to the variable.
  ///
  /// This does not test that assignment would be successful. If multiple beans
  /// are assignable then this method will return true but the [resolve] method
  /// will throw an exception. The [Primary] and [Qualifier] annotations can be
  /// used to assist the resolution process.
  ///
  ///     BeanRepository repo;
  ///
  ///     new BeanResolver(repo)
  ///       .canResolve(variableMirror);
  bool canResolve(VariableMirror target) =>
    _repo.hasAssignableBean(target.type);

  /// Returns the bean that can be assigned to the variable or throws an exception.
  ///
  /// This tests every bean in the repository to determine if any can be
  /// assigned. If there are no matching beans then an exception is thrown. If
  /// there is a single matching bean then it is returned. If there are
  /// multiple matching beans then they can be further filtered to find the one
  /// best bean to use. If such filtering fails then an exception is thrown.
  ///
  /// The filtering of multiple beans uses the [Primary] and [Qualifier]
  /// annotations. If any of the beans has a [Primary] annotation then every
  /// bean without that annotation is filtered. If the target variable has a
  /// [Qualifier] annotation then every bean that does not have a matching name
  /// is filtered. Both of these filtering steps are performed at the same
  /// time. If a single bean remains after the filtering then it is returned.
  /// If many beans remain, or if all beans have been filtered, then an
  /// exception is thrown.
  ///
  ///     BeanRepository repo;
  ///
  ///     new BeanResolver(repo)
  ///       .resolve(variableMirror);
  // TODO: Perform filtering in all possible ways to get a single bean. Prefer Qualifier over Primary.
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

/// Used to create [AutowiredInstance] objects from the [Autowired] methods, setters and fields on objects.
///
///     new new AutowiredLoader()
///       .load(object);
class AutowiredLoader {

  AutowiredLoader();

  /// Inspects the object to find every [Autowired] method, setter and field returning them as [AutowiredInstance] objects.
  ///
  ///     new new AutowiredLoader()
  ///       .load(object);
  Iterable<AutowiredInstance> load(Object object) {
    InstanceMirror clazz = reflect(object);
    List<DeclarationMirror> result = [];

    _findAutowires(clazz.type, result);
    return result.map(_makeAutowiredInstance(clazz));
  }

  static _AutowiredInstanceConstructor _makeAutowiredInstance(InstanceMirror clazz) =>
    (DeclarationMirror declaration) => new AutowiredInstance(clazz, declaration);

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
