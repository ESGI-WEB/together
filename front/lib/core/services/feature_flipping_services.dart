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

  static Future<List<Feature>> getFeatureFlippings() async {
    final response = await ApiServices.get('/features');

    if (response.statusCode != 200) {
      throw ApiException(message: 'Failed to get feature flippings', statusCode: response.statusCode, response: response);
    }

    final List<dynamic> data = jsonDecode(response.body);
    return data.map((e) => Feature.fromJson(e)).toList();
  }

  static Future<Feature> updateFeatureFlipping(Feature feature) async {
    final response = await ApiServices.patch('/features/${feature.slug}', feature.toJson());

    if (response.statusCode != 200) {
      throw ApiException(message: 'Failed to update feature flipping', statusCode: response.statusCode, response: response);
    }

    return Feature.fromJson(jsonDecode(response.body));
  }
}
