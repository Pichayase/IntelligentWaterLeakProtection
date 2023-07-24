import 'package:http/http.dart';

class HttpException implements Exception {
  Response response;
  HttpException(this.response);

  @override
  String toString() {
    return response.body;
  }
}

class ValidateException implements Exception {
  final String title;
  final String message;

  ValidateException({required this.title, required this.message});
}

class NoClientCredentialException implements Exception {
  dynamic error;
  NoClientCredentialException([this.error]);
}

class SystemInconsistencyException implements Exception {
  final String title;
  final String message;

  SystemInconsistencyException({required this.title, required this.message});
}

class ForbiddenException implements Exception {
  final String title;
  final String message;
  final String? url;

  ForbiddenException({
    required this.title,
    required this.message,
    this.url,
  });
}

class UnauthorizedException implements Exception {
  final String title;
  final String message;
  final String? url;

  UnauthorizedException({
    required this.title,
    required this.message,
    this.url,
  });
}

class PDFException implements Exception {
  final String? message;
  PDFException(this.message);
}
