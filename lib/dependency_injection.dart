library dependency_injection;

import 'dart:mirrors';
import 'package:logging/logging.dart';
import 'package:annotate/annotate.dart';
import 'package:patch_mirrors/patch_mirrors.dart' as patch;

part 'src/annotations.dart';
part 'src/dependency_injection.dart';
part 'src/models.dart';

final Logger _log = new Logger('dependency_injection');

// vim: set ai et sw=2 syntax=dart :
