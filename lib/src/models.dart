part of dependency_injection;

class BeanRepository {

  final List<BeanInstance> beans;

  BeanRepository() : beans = [];

  void add(BeanInstance bean) {
    beans.add(bean);
  }

  bool hasAssignableBean(TypeMirror target) => beans.any(_isAssignable(target));

  Iterable<BeanInstance> getAssignableBeans(TypeMirror target) {
    Iterable<BeanInstance> assignableBeans = beans.where(_isAssignable(target));

    if (assignableBeans.length > 1 && assignableBeans.any(_isPrimary)) {
      return assignableBeans.where(_isPrimary);
    }
    return assignableBeans;
  }

  _BeanInstanceFilter _isAssignable(TypeMirror target) =>
    (BeanInstance bean) => bean.isAssignableTo(target);

  bool _isPrimary(BeanInstance bean) => bean.isPrimary;
}

class BeanMethod {

  final InstanceMirror _clazz;
  final MethodMirror _method;

  BeanMethod(this._clazz, MethodMirror method)
    : _method = method;

  bool canInvoke(BeanResolver beans) =>
    _method.parameters.every(beans.canResolve);

  BeanInstance invoke(BeanResolver beans) =>
    new BeanInstance.fromDeclaration(_method, _invoke(beans));

  dynamic _invoke(BeanResolver beans) =>
    _clazz.invoke(_method.simpleName, _getParameters(beans)).reflectee;

  List<dynamic> _getParameters(BeanResolver beans) =>
    _method.parameters
      .map(beans.resolve)
      .toList();
}

class BeanInstance {

  final String name;
  final dynamic instance;
  final ClassMirror _class;
  final bool isPrimary;

  BeanInstance(dynamic instance)
    : this.fromDeclaration(reflect(instance).type, instance);

  BeanInstance.fromDeclaration(DeclarationMirror declaration, dynamic instance)
    : this.instance = instance,
      name = _deriveBeanName(declaration),
      isPrimary = _isPrimary(declaration),
      _class = reflect(instance).type;

  bool isAssignableTo(TypeMirror target) => patch.isSubtypeOf(_class, target);

  static bool _isPrimary(DeclarationMirror declaration) =>
    new DeclarationAnnotationFacade(declaration)
      .hasAnnotationOf(Primary);

  static String _deriveBeanName(DeclarationMirror declaration) {
    String name = _getAnnotationName(declaration);

    return name != null ? name : _calculateBeanName(declaration);
  }

  static String _getAnnotationName(DeclarationMirror declaration) {
    Iterable<Bean> annotations =
      new DeclarationAnnotationFacade(declaration)
        .getAnnotationsOf(Bean);

    if (annotations.isEmpty) {
      return null;
    }
    return annotations.first.name;
  }

  static String _calculateBeanName(DeclarationMirror declaration) {
    String name =
      patch.getSymbolValue(declaration.simpleName)
        .replaceFirst(new RegExp("^(get|make|build)"), "");

    return name.substring(0, 1).toLowerCase() + name.substring(1);
  }
}

abstract class AutowiredInstance {

  static bool _isMethod(DeclarationMirror mirror) =>
    mirror is MethodMirror;

  static bool _isField(DeclarationMirror mirror) =>
    mirror is VariableMirror;

  static bool _isRequired(DeclarationMirror mirror) =>
    _getAutowiredAnnotations(mirror).any((Autowired annotation) => annotation.required);

  static Iterable<Autowired> _getAutowiredAnnotations(DeclarationMirror mirror) =>
    new DeclarationAnnotationFacade(mirror)
      .getAnnotationsOf(Autowired);

  factory AutowiredInstance(InstanceMirror clazz, DeclarationMirror declaration) {
    if (_isMethod(declaration)) {
      return new AutowiredMethod(clazz, declaration, required: _isRequired(declaration));
    }
    else if (_isField(declaration)) {
      return new AutowiredField(clazz, declaration, required: _isRequired(declaration));
    }
    throw new Exception("Unknown declaration type ${declaration.runtimeType}");
  }

  bool get required;

  void autowire(BeanResolver beans);

  String toString();
}

class AutowiredMethod implements AutowiredInstance {

  final InstanceMirror _clazz;
  final MethodMirror _method;
  final bool required;

  static TypeMirror _getParameterType(ParameterMirror parameter) => parameter.type;

  static String _getTypeName(TypeMirror type) =>
    patch.getSymbolValue(type.simpleName);

  AutowiredMethod(this._clazz, this._method, {this.required: true});

  String get _clazzName => _getTypeName(_clazz.type);
  String get _methodName => patch.getSymbolValue(_method.simpleName);
  String get _parameterNames =>
    _method.parameters
      .map(_getParameterType)
      .map(_getTypeName)
      .join(', ');

  void autowire(BeanResolver beans) {
    patch.invoke(_clazz, _method, _getParameters(beans));
  }

  String toString() => "@Autowire ${_clazzName}.${_methodName}(${_parameterNames})";

  List<dynamic> _getParameters(BeanResolver beans) =>
    _method.parameters
      .map(beans.resolve)
      .toList();
}

class AutowiredField implements AutowiredInstance {

  final InstanceMirror _clazz;
  final VariableMirror _field;
  final bool required;

  AutowiredField(this._clazz, this._field, {this.required: true});

  String get _clazzName => patch.getSymbolValue(_clazz.type.simpleName);
  String get _fieldName => patch.getSymbolValue(_field.simpleName);

  void autowire(BeanResolver beans) {
    _clazz.setField(_field.simpleName, beans.resolve(_field));
  }

  String toString() => "@Autowire ${_clazzName}.${_fieldName}";
}

typedef bool _BeanInstanceFilter(BeanInstance bean);

// vim: set ai et sw=2 syntax=dart :
