import 'dart:async';
import 'package:dependency_injection/dependency_injection.dart';
import 'package:unittest/unittest.dart';
import 'test_data.dart';

final String nl = "\n     ";

void main() {
  group('Given a @Configuration class instance${nl}', () {
    AutowiredBeanConfiguration configuration;

    setUp(() {
      configuration = new AutowiredBeanConfiguration();
    });
    test('When I configure the instance${nl} Then the bean is created',
      () => when(triggerConfiguration(configuration)).then(beansHaveBeenCreated)
    );
    test('When I configure the instance${nl} Then the bean is autowired',
      () => when(triggerConfiguration(configuration)).then(beansHaveBeenAutowired)
    );
  });

  group('Given a @Configuration class instance with an @Autowired setter${nl}', () {
    AutowiredSetterConfiguration configuration;

    setUp(() {
      configuration = new AutowiredSetterConfiguration();
    });
    test('When I configure the instance${nl} Then the bean is created',
      () => when(triggerConfiguration(configuration)).then(beansHaveBeenCreated)
    );
    test('When I configure the instance${nl} Then the bean is autowired',
      () => when(triggerConfiguration(configuration)).then(beansHaveBeenAutowired)
    );
  });

  group('Given a @Configuration class instance with an @Autowired field${nl}', () {
    AutowiredFieldConfiguration configuration;

    setUp(() {
      configuration = new AutowiredFieldConfiguration();
    });
    test('When I configure the instance${nl} Then the bean is created',
      () => when(triggerConfiguration(configuration)).then(beansHaveBeenCreated)
    );
    test('When I configure the instance${nl} Then the bean is autowired',
      () => when(triggerConfiguration(configuration)).then(beansHaveBeenAutowired)
    );
  });

  group('Given a @Configuration class instance with an @Autowired field and a @Bean method with misleading return type${nl}', () {
    LooseMethodTypeAutowireConfiguration configuration;

    setUp(() {
      configuration = new LooseMethodTypeAutowireConfiguration();
    });
    test('When I configure the instance${nl} Then the bean is created',
      () => when(triggerConfiguration(configuration)).then(beansHaveBeenCreated)
    );
    test('When I configure the instance${nl} Then the bean is autowired',
      () => when(triggerConfiguration(configuration)).then(beansHaveBeenAutowired)
    );
  });

  group('Given a @Configuration class instance with different @Bean type for @Autowired method${nl}', () {
    DifferentAutowireConfiguration configuration;

    setUp(() {
      configuration = new DifferentAutowireConfiguration();
    });
    test('When I configure the instance${nl} Then an exception is thrown',
      () {
        expect(() => configuration.configure(), throws);
      }
    );
  });

  group('Given a @Configuration class instance with ambiguous @Bean for @Autowired method${nl}', () {
    AmbiguousAutowireConfiguration configuration;

    setUp(() {
      configuration = new AmbiguousAutowireConfiguration();
    });
    test('When I configure the instance${nl} Then an exception is thrown',
      () {
        expect(() => configuration.configure(), throws);
      }
    );
  });

  group('Given a @Configuration class instance with two matching @Bean types${nl}', () {
    DuplicateBeanTypeConfiguration configuration;

    setUp(() {
      configuration = new DuplicateBeanTypeConfiguration();
    });
    test('When I configure the instance${nl} Then no exception is thrown',
      () {
        expect(() => configuration.configure(), returnsNormally);
      }
    );
  });

  group('Given a @Configuration class instance with a @Primary @Bean and another matching @Bean${nl}', () {
    PrimaryAutowireConfiguration configuration;

    setUp(() {
      configuration = new PrimaryAutowireConfiguration();
    });
    test('When I configure the instance${nl} Then no exception is thrown',
      () {
        expect(() => configuration.configure(), returnsNormally);
      }
    );
    test('When I configure the instance${nl} Then the beans are created',
      () => when(triggerConfiguration(configuration)).then(beansHaveBeenCreated)
    );
    test('When I configure the instance${nl} Then the bean is autowired',
      () => when(triggerConfiguration(configuration)).then(beansHaveBeenAutowired)
    );
  });

  group('Given a @Configuration class instance with two matching @Primary @Bean types${nl}', () {
    DuplicatePrimaryAutowireConfiguration configuration;

    setUp(() {
      configuration = new DuplicatePrimaryAutowireConfiguration();
    });
    test('When I configure the instance${nl} Then an exception is thrown',
      () {
        expect(() => configuration.configure(), throws);
      }
    );
  });

  group('Given a @Configuration class instance with an exception throwing @Bean${nl}', () {
    ExceptionThrowingBeanConfiguration configuration;

    setUp(() {
      configuration = new ExceptionThrowingBeanConfiguration();
    });
    test('When I configure the instance${nl} Then an exception is thrown',
      () {
        expect(() => configuration.configure(), throws);
      }
    );
  });

  group('Given a @Configuration class instance with an exception throwing @Autowired${nl}', () {
    ExceptionThrowingAutowireConfiguration configuration;

    setUp(() {
      configuration = new ExceptionThrowingAutowireConfiguration();
    });
    test('When I configure the instance${nl} Then an exception is thrown',
      () {
        expect(() => configuration.configure(), throws);
      }
    );
  });

  group('Given a @Configuration class instance with an optional @Autowired and no @Bean instances${nl}', () {
    OptionalAutowireConfiguration configuration;

    setUp(() {
      configuration = new OptionalAutowireConfiguration();
    });
    test('When I configure the instance${nl} Then no exception is thrown',
      () {
        expect(() => configuration.configure(), returnsNormally);
      }
    );
  });

  group('Given a @Configuration class instance with an optional @Autowired and multiple @Bean instances${nl}', () {
    DuplicateOptionalAutowireConfiguration configuration;

    setUp(() {
      configuration = new DuplicateOptionalAutowireConfiguration();
    });
    test('When I configure the instance${nl} Then no exception is thrown',
      () {
        expect(() => configuration.configure(), returnsNormally);
      }
    );
  });

  group('Given a @Configuration class instance with an optional @Autowired and one @Bean${nl}', () {
    ValidOptionalAutowiredBeanConfiguration configuration;

    setUp(() {
      configuration = new ValidOptionalAutowiredBeanConfiguration();
    });
    test('When I configure the instance${nl} Then the bean is created',
      () => when(triggerConfiguration(configuration)).then(beansHaveBeenCreated)
    );
    test('When I configure the instance${nl} Then the bean is autowired',
      () => when(triggerConfiguration(configuration)).then(beansHaveBeenAutowired)
    );
  });

  group('Given a @Configuration class instance with a @Qualifier @Autowired method and multiple @Bean instances with one named${nl}', () {
    QualifierAutowiredBeanConfiguration configuration;

    setUp(() {
      configuration = new QualifierAutowiredBeanConfiguration();
    });
    test('When I configure the instance${nl} Then no exception is thrown',
      () {
        expect(() => configuration.configure(), returnsNormally);
      }
    );
    test('When I configure the instance${nl} Then the beans are created',
      () => when(triggerConfiguration(configuration)).then(beansHaveBeenCreated)
    );
    test('When I configure the instance${nl} Then the bean is autowired',
      () => when(triggerConfiguration(configuration)).then(beansHaveBeenAutowired)
    );
  });

  group('Given a @Configuration class instance with a @Qualifier @Autowired setter and multiple @Bean instances with one named${nl}', () {
    QualifierSetterAutowiredBeanConfiguration configuration;

    setUp(() {
      configuration = new QualifierSetterAutowiredBeanConfiguration();
    });
    test('When I configure the instance${nl} Then no exception is thrown',
      () {
        expect(() => configuration.configure(), returnsNormally);
      }
    );
    test('When I configure the instance${nl} Then the beans are created',
      () => when(triggerConfiguration(configuration)).then(beansHaveBeenCreated)
    );
    test('When I configure the instance${nl} Then the bean is autowired',
      () => when(triggerConfiguration(configuration)).then(beansHaveBeenAutowired)
    );
  });

  group('Given a @Configuration class instance with a @Qualifier @Autowired variable and multiple @Bean instances with one named${nl}', () {
    QualifierFieldAutowiredBeanConfiguration configuration;

    setUp(() {
      configuration = new QualifierFieldAutowiredBeanConfiguration();
    });
    test('When I configure the instance${nl} Then no exception is thrown',
      () {
        expect(() => configuration.configure(), returnsNormally);
      }
    );
    test('When I configure the instance${nl} Then the beans are created',
      () => when(triggerConfiguration(configuration)).then(beansHaveBeenCreated)
    );
    test('When I configure the instance${nl} Then the bean is autowired',
      () => when(triggerConfiguration(configuration)).then(beansHaveBeenAutowired)
    );
  });

  group('Given a @Configuration class instance with a @Qualifier @Autowired variable and multiple named @Bean instances with one @Primary${nl}', () {
    PrimaryQualifierAutowiredBeanConfiguration configuration;

    setUp(() {
      configuration = new PrimaryQualifierAutowiredBeanConfiguration();
    });
    test('When I configure the instance${nl} Then no exception is thrown',
      () {
        expect(() => configuration.configure(), returnsNormally);
      }
    );
    test('When I configure the instance${nl} Then the beans are created',
      () => when(triggerConfiguration(configuration)).then(beansHaveBeenCreated)
    );
    test('When I configure the instance${nl} Then the bean is autowired',
      () => when(triggerConfiguration(configuration)).then(beansHaveBeenAutowired)
    );
  });

  group('Given a @Configuration class instance with a @Qualifier @Autowired variable and multiple named @Bean instances${nl}', () {
    MultipleQualifierAutowiredBeanConfiguration configuration;

    setUp(() {
      configuration = new MultipleQualifierAutowiredBeanConfiguration();
    });
    test('When I configure the instance${nl} Then an exception is thrown',
      () {
        expect(() => configuration.configure(), throws);
      }
    );
  });

  group('Given a @Configuration class instance with a @Qualifier @Autowired variable and multiple named and implicitly named @Bean instances${nl}', () {
    ImplicitQualifierAutowiredBeanConfiguration configuration;

    setUp(() {
      configuration = new ImplicitQualifierAutowiredBeanConfiguration();
    });
    test('When I configure the instance${nl} Then an exception is thrown',
      () {
        expect(() => configuration.configure(), throws);
      }
    );
  });

  group('Given a @Configuration class instance with a @Qualifier @Autowired variable and multiple named and @Primary @Bean instances${nl}', () {
    MultiplePrimaryQualifierAutowiredBeanConfiguration configuration;

    setUp(() {
      configuration = new MultiplePrimaryQualifierAutowiredBeanConfiguration();
    });
    test('When I configure the instance${nl} Then an exception is thrown',
      () {
        expect(() => configuration.configure(), throws);
      }
    );
  });

}

typedef dynamic Clause();

Future<dynamic> given(Clause clause) => new Future.value(clause());
Future<dynamic> when(Clause clause) => new Future.value(clause());

Clause triggerConfiguration(AbstractInjectConfiguration configuration) =>
  () {
    configuration.configure();
    return configuration;
  };

void fail(v) {
  throw new TestFailure('Test Failed');
}

void succeed(v) {}

void beansHaveBeenCreated(MockConfiguration configuration) {
  expect(configuration.beanHasBeenCreated, isTrue);
}

void beansHaveBeenAutowired(MockConfiguration configuration) {
  expect(configuration.beanHasBeenAutowired, isTrue);
}

// vim: set ai et sw=2 syntax=dart :
