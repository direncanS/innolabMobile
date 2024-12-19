import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:vienna_life_quality/common/controllers/localization_controller.dart';
import 'package:vienna_life_quality/common/controllers/location_controller.dart';
import 'package:vienna_life_quality/features/auth/controllers/auth_controller.dart';
import 'package:vienna_life_quality/features/home/controllers/quality_of_life_controller.dart';
import 'package:vienna_life_quality/features/home/domain/repositories/quality_of_life_repository.dart';
import 'package:vienna_life_quality/features/splash/controllers/splash_controller.dart';

import '../api/api_client.dart';
import '../common/controllers/connectivity_controller.dart';
import '../common/models/language_model.dart';
import '../util/app_constants.dart';

Future<Map<String, Map<String, String>>> init() async {
  /// Core
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.lazyPut(() => sharedPreferences);
  Get.lazyPut(() => ApiClient(appBaseUrl: AppConstants.baseUrl, sharedPreferences: Get.find()));

  /// Repository
  //Get.lazyPut(() => AuthRepository(apiClient: Get.find()));
  Get.lazyPut(() => QualityOfLifeRepository());

  /// Controller
  Get.put(ConnectivityController(), permanent: true);
  Get.lazyPut(() => LocationController());
  Get.lazyPut(() => SplashController());
  Get.lazyPut(() => LocalizationController(sharedPreferences: sharedPreferences));
  Get.lazyPut(() => AuthController());
  Get.lazyPut(() => QualityOfLifeController(repository: Get.find()));

  /// Retrieving localized data
  Map<String, Map<String, String>> languages = {};
  for(LanguageModel languageModel in AppConstants.languages) {
    String jsonStringValues =  await rootBundle.loadString('assets/language/${languageModel.languageCode}.json');
    Map<String, dynamic> mappedJson = jsonDecode(jsonStringValues);
    Map<String, String> json = {};
    mappedJson.forEach((key, value) {
      json[key] = value.toString();
    });
    languages['${languageModel.languageCode}_${languageModel.countryCode}'] = json;
  }
  return languages;
}
