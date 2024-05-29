import 'api_exception.dart';

class UnauthorizedException extends ApiException {
  final String message;

  UnauthorizedException({this.message = 'Accès non autorisé'});
}