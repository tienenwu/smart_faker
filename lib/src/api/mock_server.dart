import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../core/smart_faker.dart';

typedef GraphQLResolver = FutureOr<dynamic> Function(GraphQLContext context);

/// Context passed to GraphQL resolvers.
class GraphQLContext {
  GraphQLContext({
    required this.faker,
    required this.variables,
    required this.request,
    required this.state,
  });

  final SmartFaker faker;
  final Map<String, dynamic> variables;
  final Request request;
  final Map<String, dynamic> state;
}

class _GraphQLOperationDetails {
  _GraphQLOperationDetails(
      {required this.operationType, required this.rootField});

  final String operationType;
  final String rootField;
}

/// Handles GraphQL requests with simple resolver mapping.
class GraphQLMockEndpoint {
  GraphQLMockEndpoint(this._faker, this._stateStore);

  final SmartFaker _faker;
  final Map<String, dynamic> _stateStore;
  final Map<String, GraphQLResolver> _queryResolvers = {};
  final Map<String, GraphQLResolver> _mutationResolvers = {};

  /// Register a query resolver (root field name).
  void query(String field, GraphQLResolver resolver) {
    _queryResolvers[field] = resolver;
  }

  /// Register a mutation resolver (root field name).
  void mutation(String field, GraphQLResolver resolver) {
    _mutationResolvers[field] = resolver;
  }

  Future<Response> handle(Request request) async {
    if (request.method != 'POST') {
      return Response(405, body: 'GraphQL endpoint only supports POST');
    }

    final payloadRaw = await request.readAsString();
    Map<String, dynamic> payload;
    try {
      payload = jsonDecode(payloadRaw) as Map<String, dynamic>;
    } catch (_) {
      return Response(400,
          body: jsonEncode({
            'errors': ['Invalid JSON payload']
          }));
    }

    final query = payload['query'] as String?;
    if (query == null || query.isEmpty) {
      return Response(400,
          body: jsonEncode({
            'errors': ['Missing GraphQL query']
          }));
    }

    final variables =
        (payload['variables'] as Map?)?.cast<String, dynamic>() ?? {};
    final operationDetails = _resolveOperation(query);

    final resolverMap = operationDetails.operationType == 'mutation'
        ? _mutationResolvers
        : _queryResolvers;
    final resolver = resolverMap[operationDetails.rootField];

    if (resolver == null) {
      return Response(
        400,
        body: jsonEncode({
          'errors': [
            'No resolver registered for ${operationDetails.operationType} field '
                '${operationDetails.rootField}'
          ],
        }),
        headers: {'content-type': 'application/json'},
      );
    }

    try {
      final context = GraphQLContext(
        faker: _faker,
        variables: variables,
        request: request,
        state: _stateStore,
      );
      final result = await resolver(context);
      return Response.ok(
        jsonEncode({
          'data': {
            operationDetails.rootField: result,
          },
        }),
        headers: {'content-type': 'application/json'},
      );
    } catch (error, stackTrace) {
      return Response(
        500,
        body: jsonEncode({
          'errors': [
            {'message': error.toString(), 'stack': stackTrace.toString()},
          ],
        }),
        headers: {'content-type': 'application/json'},
      );
    }
  }

  _GraphQLOperationDetails _resolveOperation(String query) {
    final cleaned = query.replaceAll(RegExp(r'#.*'), '');
    final operationMatch =
        RegExp(r'(query|mutation|subscription)\s+([a-zA-Z0-9_]+)')
            .firstMatch(cleaned);
    var operationType = 'query';
    if (operationMatch != null) {
      operationType = operationMatch.group(1)!;
    } else if (cleaned.trim().startsWith('mutation')) {
      operationType = 'mutation';
    }

    final fieldMatch = RegExp(r'\{\s*([a-zA-Z0-9_]+)').firstMatch(cleaned);
    final rootField = fieldMatch?.group(1) ?? 'data';

    return _GraphQLOperationDetails(
      operationType: operationType,
      rootField: rootField,
    );
  }
}

/// Event representation for Server-Sent Events endpoints.
class SseEvent {
  const SseEvent({
    required this.data,
    this.event,
    this.id,
    this.retry,
  });

  final dynamic data;
  final String? event;
  final String? id;
  final int? retry;

  String serialize() {
    final buffer = StringBuffer();
    if (id != null) {
      buffer.writeln('id: $id');
    }
    if (event != null) {
      buffer.writeln('event: $event');
    }
    final payload = data is String ? data : jsonEncode(data);
    buffer.writeln('data: $payload');
    if (retry != null) {
      buffer.writeln('retry: $retry');
    }
    buffer.writeln();
    return buffer.toString();
  }
}

/// Context passed to SSE generators.
class SseContext {
  SseContext({
    required this.faker,
    required this.request,
    required this.state,
  });

  final SmartFaker faker;
  final Request request;
  final Map<String, dynamic> state;
}

/// Wrapper for WebSocket connections with SmartFaker helpers.
class MockWebSocketSession {
  MockWebSocketSession(this._channel, this.faker, this.state);

  final WebSocketChannel _channel;
  final SmartFaker faker;
  final Map<String, dynamic> state;

  Stream<dynamic> get stream => _channel.stream;

  void send(dynamic data) {
    if (data is String || data is List<int>) {
      _channel.sink.add(data);
    } else {
      _channel.sink.add(jsonEncode(data));
    }
  }

  Future<void> close([int? code, String? reason]) {
    return _channel.sink.close(code, reason);
  }
}

class RecordedInteraction {
  RecordedInteraction({
    required this.method,
    required this.path,
    required this.query,
    required this.statusCode,
    required this.headers,
    required this.body,
  });

  final String method;
  final String path;
  final String query;
  final int statusCode;
  final Map<String, String> headers;
  final String body;

  bool matches(Request request) {
    return method == request.method &&
        path == request.url.path &&
        query == request.url.query;
  }

  Response toResponse() {
    return Response(
      statusCode,
      body: body,
      headers: headers,
      encoding: utf8,
    );
  }
}

class RecordedSession {
  RecordedSession(this.interactions, {this.consume = true});

  final List<RecordedInteraction> interactions;
  final bool consume;
  int _cursor = 0;

  RecordedInteraction? match(Request request) {
    if (_cursor >= interactions.length) {
      return null;
    }
    final interaction = interactions[_cursor];
    if (!interaction.matches(request)) {
      return null;
    }
    if (consume) {
      _cursor++;
    }
    return interaction;
  }

  void reset() {
    _cursor = 0;
  }
}

/// Mock API server for generating fake API responses
class MockServer {
  final SmartFaker _faker;
  final Router _router = Router();
  final Map<String, dynamic> _stateStore = {};
  final Map<String, GraphQLMockEndpoint> _graphQLEndpoints = {};
  final Map<String, List<RecordedInteraction>> _recordings = {};
  String? _activeRecordingName;
  RecordedSession? _activeReplaySession;
  HttpServer? _server;

  /// Configuration options for the mock server
  final MockServerOptions options;

  /// Whether the server is currently running
  bool get isRunning => _server != null;

  /// The port the server is running on
  int? get port => _server?.port;

  /// Create a new mock server instance
  MockServer({
    SmartFaker? faker,
    MockServerOptions? options,
  })  : _faker = faker ?? SmartFaker(),
        options = options ?? MockServerOptions();

  /// Start the mock server on the specified port
  /// If port is 0, a random available port will be assigned
  Future<int> start({int port = 0}) async {
    if (_server != null) {
      throw StateError('Server is already running on port ${_server!.port}');
    }

    final handler = Pipeline()
        .addMiddleware(_corsMiddleware())
        .addMiddleware(_replayMiddleware())
        .addMiddleware(_delayMiddleware())
        .addMiddleware(_errorSimulationMiddleware())
        .addMiddleware(_recordingMiddleware())
        .addMiddleware(logRequests())
        .addHandler(_router);

    _server = await shelf_io.serve(handler, 'localhost', port);

    print('Mock API Server started on http://localhost:${_server!.port}');
    return _server!.port;
  }

  /// Stop the mock server
  Future<void> stop() async {
    if (_server == null) return;

    await _server!.close(force: true);
    _server = null;
    _stateStore.clear();
    _activeRecordingName = null;
    _activeReplaySession = null;

    print('Mock API Server stopped');
  }

  /// Register a GET endpoint
  void get(String path, FutureOr<dynamic> Function(Request) handler) {
    _router.get(path, (Request request) async {
      final result = await handler(request);
      return _createResponse(result);
    });
  }

  /// Register a POST endpoint
  void post(String path, FutureOr<dynamic> Function(Request) handler) {
    _router.post(path, (Request request) async {
      final result = await handler(request);
      return _createResponse(result);
    });
  }

  /// Register a PUT endpoint
  void put(String path, FutureOr<dynamic> Function(Request) handler) {
    _router.put(path, (Request request) async {
      final result = await handler(request);
      return _createResponse(result);
    });
  }

  /// Register a DELETE endpoint
  void delete(String path, FutureOr<dynamic> Function(Request) handler) {
    _router.delete(path, (Request request) async {
      final result = await handler(request);
      return _createResponse(result);
    });
  }

  /// Register a PATCH endpoint
  void patch(String path, FutureOr<dynamic> Function(Request) handler) {
    _router.patch(path, (Request request) async {
      final result = await handler(request);
      return _createResponse(result);
    });
  }

  /// Register a GraphQL endpoint (POST-only).
  GraphQLMockEndpoint graphQL(String path) {
    final endpoint = GraphQLMockEndpoint(_faker, _stateStore);
    _graphQLEndpoints[path] = endpoint;
    _router.post(path, (Request request) => endpoint.handle(request));
    return endpoint;
  }

  /// Register a Server-Sent Events endpoint.
  void sse(
    String path,
    Stream<SseEvent> Function(SseContext context) generator,
  ) {
    _router.get(path, (Request request) {
      final context = SseContext(
        faker: _faker,
        request: request,
        state: _stateStore,
      );

      final eventStream = generator(context);
      final controller = StreamController<List<int>>();
      late final StreamSubscription<SseEvent> subscription;
      subscription = eventStream.listen(
        (event) {
          controller.add(utf8.encode(event.serialize()));
        },
        onError: controller.addError,
        onDone: () => controller.close(),
        cancelOnError: true,
      );

      controller.onCancel = () async {
        await subscription.cancel();
      };

      return Response.ok(
        controller.stream,
        headers: {
          'content-type': 'text/event-stream',
          'cache-control': 'no-cache',
          'connection': 'keep-alive',
          'access-control-allow-origin': '*',
        },
      );
    });
  }

  /// Register a WebSocket endpoint.
  void webSocket(
    String path,
    void Function(MockWebSocketSession session) onConnection,
  ) {
    final handler = webSocketHandler((WebSocketChannel channel) {
      final session = MockWebSocketSession(channel, _faker, _stateStore);
      onConnection(session);
    });

    _router.get(path, handler);
  }

  /// Get or set state in the state store
  /// Useful for simulating CRUD operations
  dynamic state(String key, [dynamic value]) {
    if (value != null) {
      _stateStore[key] = value;
    }
    return _stateStore[key];
  }

  /// Clear all state
  void clearState() {
    _stateStore.clear();
  }

  /// Start recording responses under the provided session name.
  void startRecording(String name) {
    _activeRecordingName = name;
    _recordings[name] = <RecordedInteraction>[];
  }

  /// Stop active recording (if any).
  void stopRecording() {
    _activeRecordingName = null;
  }

  /// Retrieve recorded interactions for a session.
  List<RecordedInteraction> recordingsFor(String name) {
    return List.unmodifiable(_recordings[name] ?? const []);
  }

  /// Remove stored recordings for the given session name.
  void clearRecording(String name) {
    _recordings.remove(name);
  }

  /// Loads recorded interactions into the server under the given [name].
  void loadRecording(String name, List<RecordedInteraction> interactions) {
    _recordings[name] = List<RecordedInteraction>.from(interactions);
  }

  /// Begin replaying a recorded session.
  void startReplay(String name, {bool consume = true}) {
    final interactions = _recordings[name];
    if (interactions == null) {
      throw ArgumentError('No recordings found for session "$name"');
    }
    _activeReplaySession = RecordedSession(
      List<RecordedInteraction>.from(interactions),
      consume: consume,
    );
  }

  /// Stop replaying a recorded session.
  void stopReplay() {
    _activeReplaySession = null;
  }

  bool get isRecording => _activeRecordingName != null;

  bool get isReplaying => _activeReplaySession != null;

  /// Create a response from dynamic data
  Response _createResponse(dynamic data) {
    if (data is Response) return data;

    final headers = {
      'content-type': 'application/json',
      ...options.defaultHeaders,
    };

    if (data is Map || data is List) {
      return Response.ok(
        jsonEncode(data),
        headers: headers,
      );
    }

    return Response.ok(
      data.toString(),
      headers: headers,
    );
  }

  Middleware _replayMiddleware() {
    return (Handler next) {
      return (Request request) async {
        final session = _activeReplaySession;
        if (session != null) {
          final match = session.match(request);
          if (match != null) {
            return match.toResponse();
          }
        }
        return next(request);
      };
    };
  }

  Middleware _recordingMiddleware() {
    return (Handler next) {
      return (Request request) async {
        final response = await next(request);
        final recordingName = _activeRecordingName;
        if (recordingName == null) {
          return response;
        }
        return _recordResponse(response, request, recordingName);
      };
    };
  }

  Future<Response> _recordResponse(
    Response response,
    Request request,
    String recordingName,
  ) async {
    final buffer = <int>[];
    await for (final chunk in response.read()) {
      buffer.addAll(chunk);
    }

    final bodyString = utf8.decode(buffer);

    final interactions =
        _recordings.putIfAbsent(recordingName, () => <RecordedInteraction>[]);
    interactions.add(RecordedInteraction(
      method: request.method,
      path: request.url.path,
      query: request.url.query,
      statusCode: response.statusCode,
      headers: Map<String, String>.from(response.headers),
      body: bodyString,
    ));

    return Response(
      response.statusCode,
      body: bodyString,
      headers: response.headers,
      encoding: utf8,
      context: response.context,
    );
  }

  /// CORS middleware for cross-origin requests
  Middleware _corsMiddleware() {
    return (Handler handler) {
      return (Request request) async {
        if (request.method == 'OPTIONS') {
          return Response.ok(
            '',
            headers: {
              'Access-Control-Allow-Origin': '*',
              'Access-Control-Allow-Methods':
                  'GET, POST, PUT, DELETE, PATCH, OPTIONS',
              'Access-Control-Allow-Headers': 'Content-Type, Authorization',
            },
          );
        }

        final response = await handler(request);
        return response.change(headers: {
          'Access-Control-Allow-Origin': '*',
        });
      };
    };
  }

  /// Delay middleware to simulate network latency
  Middleware _delayMiddleware() {
    return (Handler handler) {
      return (Request request) async {
        if (options.minDelay > 0 || options.maxDelay > 0) {
          final random = Random();
          final delay = options.minDelay +
              random.nextInt(options.maxDelay - options.minDelay + 1);
          await Future.delayed(Duration(milliseconds: delay));
        }
        return handler(request);
      };
    };
  }

  /// Error simulation middleware
  Middleware _errorSimulationMiddleware() {
    return (Handler handler) {
      return (Request request) async {
        if (options.errorRate > 0) {
          final random = Random();
          if (random.nextDouble() < options.errorRate) {
            // Randomly select an error type
            final errors = [
              Response.internalServerError(
                  body: jsonEncode({
                'error': 'Internal Server Error',
                'message': 'Something went wrong',
              })),
              Response.notFound(jsonEncode({
                'error': 'Not Found',
                'message': 'Resource not found',
              })),
              Response(408,
                  body: jsonEncode({
                    'error': 'Request Timeout',
                    'message': 'Request took too long',
                  })),
              Response(429,
                  body: jsonEncode({
                    'error': 'Too Many Requests',
                    'message': 'Rate limit exceeded',
                  })),
            ];

            return errors[random.nextInt(errors.length)];
          }
        }
        return handler(request);
      };
    };
  }

  /// Get SmartFaker instance for generating data
  SmartFaker get faker => _faker;
}

/// Configuration options for MockServer
class MockServerOptions {
  /// Minimum delay in milliseconds for responses
  final int minDelay;

  /// Maximum delay in milliseconds for responses
  final int maxDelay;

  /// Error rate (0.0 to 1.0) for simulating errors
  final double errorRate;

  /// Default headers to add to all responses
  final Map<String, String> defaultHeaders;

  /// Create mock server options
  const MockServerOptions({
    this.minDelay = 0,
    this.maxDelay = 0,
    this.errorRate = 0.0,
    this.defaultHeaders = const {},
  });
}

/// Extension to add mock API functionality to SmartFaker
extension MockApiExtension on SmartFaker {
  /// Create a new mock API server
  MockServer createMockApi({MockServerOptions? options}) {
    return MockServer(faker: this, options: options);
  }
}
