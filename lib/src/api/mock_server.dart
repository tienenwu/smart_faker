import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';

import '../core/smart_faker.dart';

/// Mock API server for generating fake API responses
class MockServer {
  final SmartFaker _faker;
  final Router _router = Router();
  final Map<String, dynamic> _stateStore = {};
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
        .addMiddleware(_delayMiddleware())
        .addMiddleware(_errorSimulationMiddleware())
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
