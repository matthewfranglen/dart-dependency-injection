library dependency_injection.test.configuration_beans;

import 'package:unittest/unittest.dart';
import 'package:dependency_injection/dependency_injection.dart';
import 'package:behave/behave.dart';

part 'models.dart';
part 'test_configuration_bean.dart';
part 'test_dependency_loop.dart';

void test() {
  testConfigurationBean();
  testDependencyLoop();
}

// vim: set ai et sw=2 syntax=dart :
