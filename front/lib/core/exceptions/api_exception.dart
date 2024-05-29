import 'package:http/http.dart';

class ApiException extends Error {
  final String message;
  int? statusCode;
  Response? response;

  ApiException(
      {this.message = 'Une erreur est survenue',
      this.statusCode = 500,
      this.response});
}
