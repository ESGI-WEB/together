import 'api_exception.dart';

class FeatureDisabledException extends ApiException {
  final String message;

  FeatureDisabledException({this.message = 'Cette fonctionnalité est désactivée, veuillez réessayer plus tard'});
}