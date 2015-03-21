library dependency_injection.test;

import 'autowiring/test.dart' as autowiring;
import 'beans/test.dart' as beans;
import 'inheritance/test.dart' as inheritance;
import 'post-configure/test.dart' as post_configure;

void main() {
  beans.test();
  autowiring.test();
  inheritance.test();
  post_configure.test();
}

// vim: set ai et sw=2 syntax=dart :
