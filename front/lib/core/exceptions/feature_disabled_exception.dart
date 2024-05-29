import 'api_exception.dart';

class FeatureDisabledException extends ApiException {
  FeatureDisabledException({super.message = 'Cette fonctionnalité est désactivée, veuillez réessayer plus tard'});
}