import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

typedef FakeResponder = ({int statusCode, dynamic body}) Function(RequestOptions options);

/// Minimal hand-rolled [HttpClientAdapter] for testing SyncService's request/response
/// handling without a live backend - routes by (method, path) to a canned JSON response.
class FakeHttpClientAdapter implements HttpClientAdapter {
  final Map<String, FakeResponder> _routes = {};
  final List<RequestOptions> capturedRequests = [];

  void on(String method, String path, FakeResponder responder) {
    _routes['$method $path'] = responder;
  }

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    capturedRequests.add(options);
    final responder = _routes['${options.method} ${options.path}'];
    if (responder == null) {
      throw StateError('No fake route registered for ${options.method} ${options.path}');
    }
    final result = responder(options);
    return ResponseBody.fromString(
      jsonEncode(result.body),
      result.statusCode,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
