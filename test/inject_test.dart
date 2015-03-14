import 'dart:async';
import 'package:dependency_injection/dependency_injection.dart';
import 'package:unittest/unittest.dart';
import 'test_data.dart';

final String nl = "\n     ";

void main() {

  group('Given a @Configuration class instance with a @Bean that has an @Autowired field${nl}', () {
    BeanAutowiringConfiguration configuration;

    setUp(() {
      configuration = new BeanFieldAutowiringConfiguration();
    });
    test('When I configure the instance${nl} Then the bean field is autowired',
      () => when(triggerConfiguration(configuration)).then(beansHaveBeenInternallyAutowired)
    );
  });

  group('Given a @Configuration class instance with a @Bean that has an @Autowired setter${nl}', () {
    BeanAutowiringConfiguration configuration;

    setUp(() {
      configuration = new BeanSetterAutowiringConfiguration();
    });
    test('When I configure the instance${nl} Then the bean setter is autowired',
      () => when(triggerConfiguration(configuration)).then(beansHaveBeenInternallyAutowired)
    );
  });

  group('Given a @Configuration class instance with a @Bean that has an @Autowired method${nl}', () {
    BeanAutowiringConfiguration configuration;

    setUp(() {
      configuration = new BeanMethodAutowiringConfiguration();
    });
    test('When I configure the instance${nl} Then the bean method is autowired',
      () => when(triggerConfiguration(configuration)).then(beansHaveBeenInternallyAutowired)
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

void beansHaveBeenInternallyAutowired(BeanAutowiringConfiguration configuration) {
  expect(configuration.autowiredBean.beanHasBeenAutowired, isTrue);
}

// vim: set ai et sw=2 syntax=dart :
