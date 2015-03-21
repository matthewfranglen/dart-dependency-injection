library dependency_injection.test.inheritance;

import 'package:unittest/unittest.dart';
import 'package:dependency_injection/dependency_injection.dart';
import 'package:behave/behave.dart';

part 'models.dart';
part 'test_extend.dart';
part 'test_implement.dart';
part 'test_with.dart';

void test() {
  testExtend();
  testImplement();
  testWith();
}

// vim: set ai et sw=2 syntax=dart :
