import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:smart_faker/smart_faker.dart';

class MockCommand extends Command<int> {
  MockCommand() {
    argParser
      ..addOption(
        'port',
        abbr: 'p',
        defaultsTo: '8080',
        help: 'Port to bind the mock server to.',
      )
      ..addOption(
        'locale',
        defaultsTo: 'en_US',
        help: 'Locale used for generated data.',
      )
      ..addOption(
        'scenario',
        defaultsTo: 'demo',
        allowed: ['demo', 'empty'],
        help: 'Pre-built scenario to bootstrap endpoints.',
      )
      ..addOption(
        'record',
        valueHelp: 'name',
        help: 'Enable recording under the given session name.',
      )
      ..addOption(
        'record-output',
        valueHelp: 'file',
        help:
            'Write captured recordings to the specified JSON file on shutdown.',
      )
      ..addOption(
        'replay-from',
        valueHelp: 'file',
        help: 'Load interactions from a JSON file and replay them.',
      )
      ..addOption(
        'duration',
        valueHelp: 'seconds',
        help:
            'Automatically stop the server after the given number of seconds.',
      );
  }

  @override
  String get description =>
      'Start the SmartFaker mock server with optional streaming and GraphQL endpoints.';

  @override
  String get name => 'mock';

  @override
  Future<int> run() async {
    final portValue = int.tryParse(argResults?['port'] as String? ?? '8080');
    if (portValue == null || portValue <= 0) {
      usageException('Invalid --port value.');
    }

    final locale = argResults?['locale'] as String? ?? 'en_US';
    final faker = SmartFaker(locale: locale);
    final mockServer = faker.createMockApi();

    final scenario = argResults?['scenario'] as String? ?? 'demo';
    if (scenario == 'demo') {
      _registerDemoScenario(mockServer, faker);
    }

    final recordSession = argResults?['record'] as String?;
    final recordOutput = argResults?['record-output'] as String?;
    if (recordOutput != null && recordSession == null) {
      usageException('--record-output requires --record.');
    }

    if (recordSession != null) {
      mockServer.startRecording(recordSession);
    }

    final replayPath = argResults?['replay-from'] as String?;
    if (replayPath != null) {
      final file = File(replayPath);
      if (!file.existsSync()) {
        usageException('Replay file not found: $replayPath');
      }
      final interactions = _loadRecordingsFromFile(file);
      mockServer.loadRecording('cli-replay', interactions);
      mockServer.startReplay('cli-replay', consume: false);
      stdout.writeln(
          'Loaded ${interactions.length} recorded interaction(s) from $replayPath');
    }

    final port = await mockServer.start(port: portValue);
    stdout.writeln('Mock server running on http://localhost:$port');
    stdout.writeln('Press Ctrl+C to stop.');

    final durationSeconds =
        int.tryParse(argResults?['duration'] as String? ?? '0');
    final completer = Completer<int>();

    Future<void> shutdown([String message = 'Shutting down...']) async {
      if (completer.isCompleted) return;
      stdout.writeln('\n$message');

      if (recordSession != null && recordOutput != null) {
        final recordings = mockServer.recordingsFor(recordSession);
        final jsonObject = _recordingsToJson(recordSession, recordings);
        final encoder = const JsonEncoder.withIndent('  ');
        await File(recordOutput).writeAsString(encoder.convert(jsonObject));
        stdout.writeln(
            'Recorded ${recordings.length} interaction(s) to $recordOutput');
      }

      await mockServer.stop();
      completer.complete(0);
    }

    final sigIntSub = ProcessSignal.sigint.watch().listen((_) => shutdown());
    final sigTermSub = ProcessSignal.sigterm.watch().listen((_) => shutdown());

    Timer? durationTimer;
    if (durationSeconds != null && durationSeconds > 0) {
      durationTimer = Timer(Duration(seconds: durationSeconds), () {
        shutdown('Stopping after ${durationSeconds}s...');
      });
    }

    final exitCode = await completer.future;
    await sigIntSub.cancel();
    await sigTermSub.cancel();
    durationTimer?.cancel();
    return exitCode;
  }

  void _registerDemoScenario(MockServer server, SmartFaker faker) {
    // Basic REST endpoints
    server.get('/api/users', (request) {
      return List.generate(
          5,
          (_) => {
                'id': faker.datatype.uuid(),
                'name': faker.person.fullName(),
                'email': faker.internet.email(),
                'createdAt': DateTime.now().toIso8601String(),
              });
    });

    server.post('/api/users', (request) async {
      final body =
          jsonDecode(await request.readAsString()) as Map<String, dynamic>?;
      final user = {
        'id': faker.datatype.uuid(),
        'name': body?['name'] ?? faker.person.fullName(),
        'email': body?['email'] ?? faker.internet.email(),
        'createdAt': DateTime.now().toIso8601String(),
      };
      final existing =
          List<Map<String, dynamic>>.from(server.state('users') ?? []);
      existing.add(user);
      server.state('users', existing);
      return user;
    });

    // GraphQL endpoint
    final graphQL = server.graphQL('/graphql');
    graphQL.query('viewer', (context) {
      return {
        'id': faker.datatype.uuid(),
        'name': faker.person.fullName(),
        'email': faker.internet.email(),
        'locale': context.faker.locale,
      };
    });
    graphQL.mutation('updateProfile', (context) {
      final name =
          context.variables['name'] as String? ?? faker.person.fullName();
      context.state['profile:name'] = name;
      return {'success': true, 'name': name};
    });

    // SSE demo stream
    server.sse('/events', (context) async* {
      yield SseEvent(
        event: 'notification',
        data: {
          'id': faker.datatype.uuid(),
          'message': faker.lorem.sentence(),
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
      await Future<void>.delayed(const Duration(milliseconds: 400));
      yield SseEvent(
        event: 'notification',
        data: {
          'id': faker.datatype.uuid(),
          'message': faker.lorem.sentence(),
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
    });

    // WebSocket echo
    server.webSocket('/ws', (session) {
      session.send({
        'type': 'welcome',
        'message': 'Connected to SmartFaker mock socket',
      });
      session.stream.listen((incoming) {
        session.send({
          'type': 'echo',
          'payload': incoming,
        });
      });
    });
  }

  Map<String, dynamic> _recordingsToJson(
    String session,
    List<RecordedInteraction> interactions,
  ) {
    return {
      'session': session,
      'generatedAt': DateTime.now().toIso8601String(),
      'interactions': interactions.map(_interactionToJson).toList(),
    };
  }

  List<RecordedInteraction> _loadRecordingsFromFile(File file) {
    final decoded = jsonDecode(file.readAsStringSync());
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Replay file must decode to a JSON object');
    }
    final interactions = decoded['interactions'];
    if (interactions is! List) {
      throw const FormatException(
          'Replay file is missing an "interactions" array');
    }
    return interactions
        .whereType<Map>()
        .map((raw) => _interactionFromJson(raw.cast<String, dynamic>()))
        .toList();
  }

  Map<String, dynamic> _interactionToJson(RecordedInteraction interaction) {
    return {
      'method': interaction.method,
      'path': interaction.path,
      'query': interaction.query,
      'statusCode': interaction.statusCode,
      'headers': interaction.headers,
      'body': interaction.body,
    };
  }

  RecordedInteraction _interactionFromJson(Map<String, dynamic> json) {
    return RecordedInteraction(
      method: json['method'] as String? ?? 'GET',
      path: json['path'] as String? ?? '/',
      query: json['query'] as String? ?? '',
      statusCode: json['statusCode'] as int? ?? 200,
      headers: (json['headers'] as Map?)
              ?.cast<String, dynamic>()
              .map((key, value) => MapEntry(key, value.toString())) ??
          const <String, String>{},
      body: json['body']?.toString() ?? '',
    );
  }
}
