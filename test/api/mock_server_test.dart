import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:smart_faker/smart_faker.dart';

void main() {
  group('MockServer advanced capabilities', () {
    late MockServer server;
    late SmartFaker faker;

    setUp(() {
      faker = SmartFaker(seed: 123);
      server = MockServer(faker: faker);
    });

    tearDown(() async {
      await server.stop();
    });

    test('supports GraphQL endpoint', () async {
      server.graphQL('/graphql')
        ..query('greeting', (context) {
          return 'Hello ${context.faker.person.firstName()}';
        })
        ..mutation('updateName', (context) {
          final input = context.variables['name'] as String? ?? 'Unknown';
          context.state['lastName'] = input;
          return {'success': true};
        });

      final port = await server.start();

      final client = HttpClient();
      final request =
          await client.postUrl(Uri.parse('http://localhost:$port/graphql'));
      request.headers.set(HttpHeaders.contentTypeHeader, 'application/json');
      request.add(utf8.encode(jsonEncode({'query': 'query { greeting }'})));
      final response = await request.close();
      expect(response.statusCode, 200);
      final responseBody = await utf8.decodeStream(response);
      final decoded = jsonDecode(responseBody) as Map<String, dynamic>;
      expect(decoded['data']['greeting'], isA<String>());

      final mutationRequest =
          await client.postUrl(Uri.parse('http://localhost:$port/graphql'));
      mutationRequest.headers
          .set(HttpHeaders.contentTypeHeader, 'application/json');
      mutationRequest.add(utf8.encode(jsonEncode({
        'query': 'mutation UpdateName { updateName { success } }',
        'variables': {'name': 'River'},
      })));
      final mutationResponse = await mutationRequest.close();
      expect(mutationResponse.statusCode, 200);
      final mutationBody = await utf8.decodeStream(mutationResponse);
      final mutationDecoded = jsonDecode(mutationBody) as Map<String, dynamic>;
      expect(mutationDecoded['data']['updateName']['success'], isTrue);
      expect(server.state('lastName'), equals('River'));
    });

    test('supports server-sent events', () async {
      server.sse('/stream', (context) async* {
        yield const SseEvent(data: {'message': 'hello'});
        yield const SseEvent(data: {'message': 'world'});
      });

      final port = await server.start();

      final client = HttpClient();
      final request =
          await client.getUrl(Uri.parse('http://localhost:$port/stream'));
      final response = await request.close();
      expect(response.statusCode, 200);
      final content = await utf8.decodeStream(response);
      expect(content.contains('data: {"message":"hello"}'), isTrue);
      expect(content.contains('data: {"message":"world"}'), isTrue);
    });

    test('supports WebSocket endpoints', () async {
      server.webSocket('/ws', (session) {
        session.send({'message': 'ping'});
      });

      final port = await server.start();

      final socket = await WebSocket.connect('ws://localhost:$port/ws');
      final message = await socket.first as String;
      final decoded = jsonDecode(message);
      expect(decoded['message'], 'ping');
      await socket.close();
    });

    test('records and replays responses', () async {
      server.get('/data', (_) {
        return {
          'id': faker.random.uuid(),
          'value': faker.internet.email(),
        };
      });

      server.startRecording('session1');
      final port = await server.start();

      final client = HttpClient();
      final uri = Uri.parse('http://localhost:$port/data');
      final originalResponse = await (await client.getUrl(uri)).close();
      final originalBody = await utf8.decodeStream(originalResponse);
      server.stopRecording();

      server.startReplay('session1');
      final replayResponse = await (await client.getUrl(uri)).close();
      final replayBody = await utf8.decodeStream(replayResponse);
      expect(replayBody, equals(originalBody));
      server.stopReplay();
    });
  });
}
