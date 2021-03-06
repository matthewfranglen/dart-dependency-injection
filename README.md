Dart Dependency Injection
=========================

This provides dependency injection using a Configuration to define Beans which can be injected into Autowired fields.

This is very similar to the Spring Dependency Injection using Annotations and Java Configuration.

Synopsis
--------

Create the configuration by extending AbstractInjectConfiguration. Define some methods which return Beans:

    class Configuration extends AbstractInjectConfiguration {
      @bean SomeClass makeSomeClass() => new SomeClass();

      @bean AnotherClass makeAnotherClass() => new AnotherClass();
    }

Within those classes you can define Autowired fields. The AbstractInjectConfiguration subclass can also be Autowired:

    class Configuration extends AbstractInjectConfiguration {

      ...

      @autowired void setSomeClass(SomeClass bean) {}
    }

    class SomeClass {
      @autowired void setAnotherClass(AnotherClass bean) {}
    }

You then trigger loading the beans and autowiring the fields by calling _configure_ on an instance of the AbstractInjectConfiguration:

    new Configuration().configure();

You can only use the Bean annotation on methods. The arguments to those methods are autowired, allowing you to reference other beans:

    class Configuration extends AbstractInjectConfiguration {
      @bean SomeClass makeSomeClass() => new SomeClass();

      @bean AnotherClass makeAnotherClass(SomeClass bean) {
        AnotherClass instance = new AnotherClass();
        instance.setSomeClass(bean);
        return instance;
      }
    }

Methods, setters, and fields can be autowired. A method that is autowired can accept multiple beans:

    class Configuration extends AbstractInjectConfiguration {
      ...

      @autowired AnotherClass field;
      @autowired set setter(AnotherClass value) {}
      @autowired void method(SomeClass someBean, AnotherClass anotherBean) {}
    }

The object returned by a bean method is inspected. If it has autowired fields then they will be populated. If the bean class has the configuration annotation then it can create other beans:

    class Configuration extends AbstractInjectConfiguration {
      @bean AnotherConfiguration makeConfigurationBean() => new AnotherConfiguration();
    }

    @configuration class AnotherConfiguration {
      @autowired AnotherClass field;

      @bean AnotherClass makeBean() => new AnotherClass();
    }

Initialization can be done after all beans have been created and all autowires have been performed. Just define a method that has the postConstruct annotation:

    class ExampleBean {
      @postConstruct void initialize() {}
    }

    class Configuration extends AbstractInjectConfiguration {
      @bean ExampleBean getBean() => new ExampleBean();
    }

The postConstruct methods can take beans as arguments, just like the autowires:

    class ExampleBean {
      @postConstruct void initialize(AnotherClass anotherBean) {}
    }

Description
-----------

Every time you create an instance of a class by using the _new_ keyword you tightly couple your code to that class, and you will not be able to substitute that implementation with a different one. However if you write your class to use an interface, and inject the object to use, then you can change implementations by changing only the injection configuration.

Testing benefits greatly from this approach. A class can be isolated from other classes by mocking the interfaces that it requires. This allows for effective and simple unit tests that only test the class. This is in comparison to integration tests which test the class and all of the classes it uses, to confirm that they are behaving as a whole.

This also allows for greater reuse of classes. You can take a class (and the interfaces it uses) from one project and start using it in another project. If you have every dependency that the class requires then it can start working with minimal configuration.

This library allows you to define _Beans_, which are the values which can be injected, and to _Autowire_ fields or methods, injecting those _Beans_ into the fields and methods. All of this is controlled using a configuration which defines the _Beans_ to use.

### Configuration

The configuration is performed by a class which you define which must extend AbstractInjectConfiguration. This class must contain all the _Bean_ creating methods. Such a method must return a value and be annotated with _@Bean()_ or _@bean_:

    class Configuration extends AbstractInjectConfiguration {
      @bean SomeClass makeSomeClass() => new SomeClass();
    }

The type of the bean is taken from the value of the returned object, not from the method definition. So this is an equivalent configuration:

    class Configuration extends AbstractInjectConfiguration {
      @bean Object makeSomeClass() => new SomeClass();
    }

The configuration class will create all beans and inject them when it is configured. You trigger this configuration by calling _configure_:

    new Configuration().configure();

### Beans

A _Bean_ is a value which can be injected into an appropriate container. It is returned by a method on the AbstractInjectConfiguration subclass.

Unlike Spring the methods that return Bean objects do not become singleton methods. If you manually call a bean method you may receive a different object to the bean that has been used for autowiring. Since the AbstractInjectConfiguration subclass can be autowired, you can inject the bean into the configuration if you need access to it:

    class Configuration extends AbstractInjectConfiguration {
      @autowired SomeClass someClassBean;
      @bean Object makeSomeClass() => new SomeClass();
    }

    Configuration config = new Configuration()
    config.configure();
    print(config.someClassBean);

If you need beans to perform additional configuration then you can create an autowired configuration method on the AbstractInjectConfiguration subclass. That method will be invoked with all of the required beans:

    class Configuration extends AbstractInjectConfiguration {
      @bean Object makeSomeClass() => new SomeClass();
      @bean AnotherClass makeAnotherClass() => new AnotherClass();

      @autowired void configureSomeClass(SomeClass someBean, AnotherClass anotherBean) {}
    }

The bean methods do not have to create the bean, they merely have to return it. This means you can use them to return DOM elements:

    class Configuration extends AbstractInjectConfiguration {
      @bean Element getBody() => document.querySelector('body');
    }

If you use this approach then you may wish to review the *polymer_dependency_injection* package, which can scan the DOM looking for annotated polymer elements. It loads those elements as beans and allows them to be autowired.

### Configuration Beans

A _Configuration Bean_ is a _Bean_ which has a type with the _Configuration_ annotation. Configuration Beans can contain _Bean_ creating methods just like the AbstractInjectConfiguration subclass.

The beans created by a configuration bean are available to all classes for autowiring. The configuration bean and all beans it creates are eligible for autowiring.

    class Configuration extends AbstractInjectConfiguration {
      @autowired AnotherClass field;

      @bean AnotherConfiguration makeConfigurationBean() => new AnotherConfiguration();
    }

    @configuration class AnotherConfiguration {
      @autowired Configuration baseConfiguration;

      @bean AnotherClass makeBean() => new AnotherClass();
    }

### Autowiring

Autowiring allows a method, setter or field to be provided with a bean. Every bean and the AbstractInjectConfiguration subclass are eligible for autowiring.

Autowiring assigns by type. This is done by testing that the bean can be assigned to the autowired field. For example:

    class ExampleClass {}
    class ExampleSubClass extends ExampleClass {}
    class ExampleMixin extends Object with ExampleClass {}

    class Configuration extends AbstractInjectConfiguration {
      @bean ExampleSubClass makeBean() => new ExampleSubClass();

      // This will get autowired
      @autowired ExampleClass field;

      // This will NOT get autowired - ExampleSubClass is not assignable to ExampleMixin
      @autowired ExampleMixin mixinField;
    }

When you define a method or setter as autowired all of the parameters will be set to the appropriate bean and then the method will be invoked. For example:

    class Configuration extends AbstractInjectConfiguration {
      @bean ExampleSubClass makeBean() => new ExampleSubClass();
      @bean ExampleMixin makeMixin() => new ExampleMixin();

      // This will get invoked with autowired arguments
      @autowired void autowiredMethod(ExampleSubClass bean, ExampleMixin mixin) {}

      // This will also get invoked with autowired arguments
      @autowired set mixin(ExampleMixin mixin) {}

      // This will NOT get invoked - both beans can be assigned to the parameter
      @autowired void ambiguousMethod(ExampleClass bean) {}
    }

When there are multiple beans that can be assigned to an autowired field then the autowiring fails. If there are no beans then the autowiring also fails. When the autowiring fails an exception is thrown. If you want a field to be assigned only if a bean is available then you can set it to optional:

    class Configuration extends AbstractInjectConfiguration {

      // This will not get invoked - but that will not throw an exception
      @Autowired(required: false) void missingBean(ExampleClass bean) {}
    }

When there are multiple beans that match a field you can indicate a preferred bean. This is covered in the next section.


### Being Specific with Primary and Qualifier

Multiple beans cannot be assigned to an autowired field. When there are multiple beans that match a field there are two ways to indicate a preferred bean. If there is a single preferred bean then the autowiring can proceed.

The first way is to change the bean to indicate that it is preferred. This is done using the primary annotation:

    class ExampleClass {}

    class Configuration extends AbstractInjectConfiguration {
      @bean @primary ExampleClass primaryBean() => new ExampleClass();
      @bean ExampleClass bean() => new ExampleClass();

      // This is autowired with the bean created by primaryBean
      @autowired ExampleClass field;
    }

The second way is to change the autowired field to indicate which bean is preferred. This is done by naming the bean and using the qualifier annotation:

    class Configuration extends AbstractInjectConfiguration {
      @Bean(name="chosen") ExampleClass preferredBean() => new ExampleClass()
      @bean ExampleClass bean() => new ExampleClass();

      // This is autowired with the bean created by preferredBean
      @autowired @Qualifier("chosen") ExampleClass field;

      // For methods you need to add the Qualifier to the parameter
      @autowired void method(@Qualifier("chosen") ExampleClass argument) {}

      // Setters also need the Qualifier on the parameter
      @autowired set value(@Qualifier("chosen") ExampleClass argument) {}
    }

Beans are automatically assigned names based on the name of the method that creates them. If the name starts with _get_, _make_ or _build_ then that is removed. The first letter of the name is changed to lower case. For example:

    class Configuration extends AbstractInjectConfiguration {
      // The name is set, so the method name is not inspected
      @Bean(name="namedBean") String notInspected() => "Named Bean";

      // The method name starts with get so the bean name is firstBean
      @bean String getFirstBean() => "First Bean";

      // The method name starts with make so the bean name is secondBean
      @bean String makeSecondBean() => "Second Bean";

      // The method name starts with build so the bean name is thirdBean
      @bean String buildThirdBean() => "Third Bean";

      // The method name starts with a capital letter so the bean name is fourthBean
      @bean String FourthBean() => "Forth Bean";

      // The bean name is fifthBean
      @bean String fifthBean() => "Fifth Bean";

      // This gets autowired without issue
      @autowired void method(@Qualifier("namedBean") String value) {}
    }

### Post Construction Initialization

Some initialization must wait for all autowiring to be completed. When this is the case the _PostConstruct_ annotation can be used to mark a method to be invoked once bean construction and autowiring has completed. For example:

    class Configuration extends AbstractInjectConfiguration {
      @postConstruct void initialize() {}
    }

Every loaded bean will be searched for methods with this annotation when _configure_ is called. The initialization method can take bean parameters, just like autowired methods:

    class ExampleBean {
      @postConstruct void initialize(String host) {}
    }

    class Configuration extends AbstractInjectConfiguration {
      @bean String getHost() => "example.com";
      @bean ExampleBean getBean() => new ExampleBean();
    }

Example Code
------------

Example code is available in the _example_ directory.
