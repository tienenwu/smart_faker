import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';

class BuildCommand extends Command<int> {
  BuildCommand() {
    argParser
      ..addFlag(
        'watch',
        abbr: 'w',
        negatable: false,
        help: 'Run build_runner in watch mode.',
      )
      ..addFlag(
        'delete-conflicting-outputs',
        defaultsTo: true,
        help: 'Pass --delete-conflicting-outputs to build_runner.',
      )
      ..addMultiOption(
        'extra-args',
        help: 'Additional arguments forwarded to build_runner.',
      );
  }

  @override
  String get description => 'Convenience wrapper around dart run build_runner.';

  @override
  String get name => 'build';

  @override
  Future<int> run() async {
    final watch = argResults?['watch'] as bool? ?? false;
    final deleteConflicting =
        argResults?['delete-conflicting-outputs'] as bool? ?? true;
    final extra = (argResults?['extra-args'] as List?)?.cast<String>() ??
        const <String>[];

    final arguments = <String>[
      'run',
      'build_runner',
      watch ? 'watch' : 'build'
    ];
    if (deleteConflicting) {
      arguments.add('--delete-conflicting-outputs');
    }
    arguments.addAll(extra);

    stdout.writeln('Executing: dart ${arguments.join(' ')}');

    final process = await Process.start('dart', arguments);
    unawaited(stdout.addStream(process.stdout));
    unawaited(stderr.addStream(process.stderr));

    final exitCode = await process.exitCode;
    if (exitCode != 0) {
      stderr.writeln('build_runner terminated with exit code $exitCode');
    }
    return exitCode;
  }
}
