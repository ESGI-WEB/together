import 'dart:convert';
import 'package:front/core/exceptions/api_exception.dart';
import 'package:front/core/models/feature.dart';
import 'api_services.dart';

class FeatureFlippingServices {
  static Future<Feature> getFeatureFlipping(String featureName) async {
    final response = await ApiServices.get('/features/$featureName');

    if (response.statusCode == 404) {
      throw ApiException(message: 'Feature flipping not found', statusCode: 404, response: response);
    }

    if (response.statusCode != 200) {
      throw ApiException(message: 'Failed to get feature flipping', statusCode: response.statusCode, response: response);
    }

    return Feature.fromJson(jsonDecode(response.body));
  }
}
