library dependency_injection.test;

import 'autowiring/test.dart' as autowiring;
import 'beans/test.dart' as beans;
import 'inheritance/test.dart' as inheritance;

void main() {
  beans.test();
  autowiring.test();
  inheritance.test();
}

// vim: set ai et sw=2 syntax=dart :
