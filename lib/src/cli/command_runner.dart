import 'package:args/command_runner.dart';

import 'build_command.dart';
import 'generate_command.dart';
import 'mock_command.dart';

class SmartFakerCommandRunner extends CommandRunner<int> {
  SmartFakerCommandRunner()
      : super('smart_faker', 'SmartFaker command-line utilities.') {
    argParser.addFlag(
      'version',
      negatable: false,
      help: 'Print the CLI version.',
    );

    addCommand(GenerateCommand());
    addCommand(MockCommand());
    addCommand(BuildCommand());
  }

  static const String cliVersion = '0.5.0';

  @override
  Future<int?> run(Iterable<String> args) async {
    final topLevelResults = parse(args);
    if (topLevelResults['version'] == true) {
      print('smart_faker CLI v$cliVersion');
      return 0;
    }
    return await runCommand(topLevelResults);
  }
}
