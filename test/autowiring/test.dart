library dependency_injection.test.autowiring;

import 'package:unittest/unittest.dart';
import 'package:dependency_injection/dependency_injection.dart';
import '../behave/behave.dart';

part 'models.dart';
part 'test_assignment.dart';
part 'test_assignment_failures.dart';
part 'test_optional.dart';
part 'test_primary.dart';
part 'test_qualifier.dart';
part 'test_value.dart';

void test() {
  testAssignment();
  testAssignmentFailures();
  testOptional();
  testPrimary();
}

// vim: set ai et sw=2 syntax=dart :
