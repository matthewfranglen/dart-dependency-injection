part of dependency_injection;

/// Autowired annotates a method, setter or variable which takes a bean.
///
/// The type of the method, setter or variable is used to determine the bean received.
/// All [Bean] objects are tested to see if they can be assigned to the setter.
/// It is a critical error for multiple beans to be assignable.
/// It is a critical error for no beans to be assignable.
///
///     class Wizzler {
///       @Autowired()
///       Fobrinator fobrinator;
class Autowired {

  final bool required;

  const Autowired({bool required: true}) : this.required = required;
}

const Autowired autowired = const Autowired();

/// Qualifier annotates an [Autowired] method, setter or variable to indicate a preferred bean.
///
/// It is not possible to inject values into [Autowired] fields when the type
/// of the field matches multiple [Bean] instances. The [Qualifier] annotation
/// names the [Bean] to be injected when there are multiple injectable [Bean]
/// instances available.
///
///     class FizzBang {
///       @Autowired()
///       @Qualifier("wizzle")
///       Wizzler wizzler;
class Qualifier {

  final String value;

  const Qualifier(this.value);
}

/// Bean annotates a method which returns an injectable object.
///
/// The method parameters must all be [Bean] instances.
/// The method return type is used to determine the type of the bean.
/// All [Autowired] setters that are assignable will be set with the bean.
/// It is a critical error for multiple beans to be assignable to a single setter.
///
/// The bean can be marked as [Primary] to specify it as a preferred bean.
/// The bean can also be named, which allows the [Qualifier] annotation to
/// specify it as a preferred bean. This can help resolve multiple bean assignments.
///
///     @Bean()
///     Fobrinator getFobrinator() => new Fobrinator();
///
///     @Bean(name: "fob")
///     Fobrinator getFobrinator() => new Fobrinator();
///
///     @Bean()
///     @Primary()
///     Fobrinator getFobrinator() => new Fobrinator();
class Bean {

  final String name;

  const Bean({String name: null}) : this.name = name;
}

const Bean bean = const Bean();

/// Component annotates a class which is a discoverable bean.
///
/// When instances of a [Component] annotated class are discovered during
/// autoloading they are added to the [BeanRepository]. They are then eligible
/// for being injected into [Autowired] fields or methods.
///
/// The bean can be marked as [Primary] to specify it as a preferred bean.
/// The bean can also be named, which allows the [Qualifier] annotation to
/// specify it as a preferred bean. This can help resolve multiple bean assignments.
///
///     @Component()
///     class FluxCapacitor {
///
///     @Component(name: "fluxCapacitor")
///     class FluxCapacitor {
///
///     @Component()
///     @Primary()
///     class FluxCapacitor {
class Component {

  final String name;

  const Component({String name: null}) : this.name = name;
}

const Component component = const Component();

/// Configuration annotates a class which is a discoverable configuration.
///
/// When instances of a [Configuration] annotated class are discovered during
/// autoloading they are inspected and any [Bean] annotated methods are
/// invoked, storing the resulting beans in the [BeanRepository].
///
/// When a configuration creates a bean the bean type is inspected for this
/// annotation. This allows any bean to be a configuration, no matter the
/// discovery route.
///
/// The configuration annotation is a subclass of [Component] so every class
/// annotated with this is treated as a bean.
///
///     @Configuration()
///     class WarpDriveConfiguration {
///       @Bean() dynamic getHeisenburgCompensator() {}
///
///     @Component(name: "fluxCapacitor")
///     class WarpDriveConfiguration {
///       @Bean() dynamic getHeisenburgCompensator() {}
///
///     @Component()
///     @Primary()
///     class WarpDriveConfiguration {
///       @Bean() dynamic getHeisenburgCompensator() {}
class Configuration extends Component {

  const Configuration({String name: null}) : super(name: name);
}

const Configuration configuration = const Configuration();

/// Primary annotates a [Component] class or [Bean] method to indicate a preferred bean.
///
/// It is not possible to inject values into [Autowired] fields when the type
/// of the field matches multiple [Bean] instances. The [Primary] annotation
/// sets the [Bean] to be injected when there are multiple injectable [Bean]
/// instances available.
///
///     @Bean()
///     @Primary()
///     Snarfle getSnarfle() => new Snarfle();
///
///     @Component()
///     @Primary()
///     class Hoverboard {
class Primary {
  const Primary();
}

const Primary primary = const Primary();

// vim: set ai et sw=2 syntax=dart :
