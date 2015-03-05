part of dependency_injection;

class AbstractInjectConfiguration {

  BeanRepository _repo;
  BeanResolver _beans;

  AbstractInjectConfiguration() {
    _repo = new BeanRepository();
    _beans = new BeanResolver(_repo);
  }

  void addBean(BeanInstance bean) {
    _repo.add(bean);
  }

  void configure() {
    _registerBeans();
    _autowire();
  }

  void _registerBeans() {
    BeanLoader loader = new BeanLoader.fromObject(this);

    _repo.add(new BeanInstance(this));
    loader.load(_repo, _beans);
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

  BeanLoader(InstanceMirror configuration)
    : _beansAwaitingConstruction =
        configuration.type.declarations.values
          .where(_isMethod)
          .map(_castToMethodMirror)
          .where(DeclarationAnnotationFacade.filterByAnnotation(Bean))
          .map(_makeBeanMethod(configuration))
          .toList();

  static bool _isMethod(DeclarationMirror mirror) =>
    mirror is MethodMirror;

  static MethodMirror _castToMethodMirror(DeclarationMirror mirror) =>
    mirror as MethodMirror;

  static _BeanMethodConstructor _makeBeanMethod(InstanceMirror configurationClass) =>
    (MethodMirror method) => new BeanMethod(configurationClass, method);

  void load(BeanRepository repo, BeanResolver beans) {
    while (_beansAwaitingConstruction.isNotEmpty) {
      BeanMethod method = _beansAwaitingConstruction.firstWhere(
        (BeanMethod method) => method.canInvoke(beans)
      );
      repo.add(method.invoke(beans));
      _beansAwaitingConstruction.remove(method);
    }
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
      List<String> qualifierNames =
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

    return clazz.type.declarations.values
      .where(DeclarationAnnotationFacade.filterByAnnotation(Autowired))
      .map(_makeAutowiredInstance(clazz));
  }
}

typedef BeanMethod _BeanMethodConstructor(MethodMirror mirror);
typedef AutowiredInstance _AutowiredInstanceConstructor(DeclarationMirror mirror);

// vim: set ai et sw=2 syntax=dart :