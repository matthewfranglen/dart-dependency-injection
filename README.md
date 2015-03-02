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

      @autowired void configureSomeClass(SomeClass someClassBean, AnotherClass anotherClassBean) {}
    }

The bean methods do not have to create the bean, they merely have to return it. This means you can use them to return DOM elements:

    class Configuration extends AbstractInjectConfiguration {
      @bean Element getBody() => document.querySelector('body');
    }

If you use this approach then you may wish to review the *polymer_dependency_injection* package, which can scan the DOM looking for annotated polymer elements. It loads those elements as beans and allows them to be autowired.

### Autowiring

Autowiring allows a method, setter or field to be provided with a bean. Every bean and the AbstractInjectConfiguration subclass are eligible for autowiring.

### Being Specific with Primary and Qualifier

...

Example Code
------------

...
