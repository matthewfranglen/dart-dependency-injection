library dependency_injection.test.beans;

import 'package:unittest/unittest.dart';
import 'package:dependency_injection/dependency_injection.dart';
import 'package:behave/behave.dart';

part 'models.dart';
part 'test_autowiring.dart';
part 'test_creation.dart';

void test() {
  testCreation();
  testAutowiring();
}

// vim: set ai et sw=2 syntax=dart :
