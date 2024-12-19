import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:vienna_life_quality/util/app_constants.dart';
import 'dart:convert';
import '../models/quality_of_life_response_model.dart';

class QualityOfLifeRepository {
  QualityOfLifeRepository();

  Future<QualityOfLifeResponse> fetchQualityOfLifeData({
    required String latitude,
    required String longitude,
    required String userType,
    required String subDistrictName,
  }) async {

    final body = {
      'latitude': latitude,
      'longitude': longitude,
      'user-type': userType,
      'subdistrict_name': '',
    };

    print('fetchQualityOfLifeData body: $body');

    final response = await http.post(
        Uri.parse(
            '${AppConstants.baseUrl}${AppConstants.calculateQualityOfLifeUri}'),
        body: body);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      debugPrint('Quality of life data loaded successfully ${response.body}');
      return QualityOfLifeResponse.fromJson(data);
    } else {
      throw Exception('Failed to load quality of life data');
    }
  }
}
