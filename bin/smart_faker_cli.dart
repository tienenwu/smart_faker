import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:smart_faker/src/cli/command_runner.dart';

Future<void> main(List<String> arguments) async {
  final commandRunner = SmartFakerCommandRunner();
  try {
    final result = await commandRunner.run(arguments) ?? 0;
    exit(result);
  } on UsageException catch (e) {
    stderr.writeln(e.message);
    stderr.writeln(e.usage);
    exit(64);
  }
}
