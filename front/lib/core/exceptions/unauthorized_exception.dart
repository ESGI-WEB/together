import 'api_exception.dart';

class UnauthorizedException extends ApiException {
  UnauthorizedException({super.message = 'Accès non autorisé'});
}
