import 'api_exception.dart';

class ConflictException extends ApiException {
  final String message;

  ConflictException({this.message = 'Conflit'});
}