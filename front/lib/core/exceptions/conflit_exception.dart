import 'api_exception.dart';

class ConflictException extends ApiException {
  ConflictException({
    super.message = 'Conflit, cet élément existe déjà.',
    super.statusCode = 409,
    super.response,
  });
}
