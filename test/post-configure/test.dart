library dependency_injection.test.post_configure;

import 'package:unittest/unittest.dart';
import 'package:dependency_injection/dependency_injection.dart';
import 'package:behave/behave.dart';

part 'models.dart';
part 'test_autowire.dart';

void test() {
  testAutowire();
}

// vim: set ai et sw=2 syntax=dart :
