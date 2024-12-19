import 'package:get/get.dart';
import 'package:get/get_common/get_reset.dart';
import 'package:get/get_core/src/get_main.dart';

import '../common/models/language_model.dart';
import 'images.dart';

class AppConstants {
  static const String appName = 'Vienna Life';
  static const double appVersion = 1.0;

  static const String fontFamily = 'Poppins';
  static const String baseUrl = 'https://vienna.asiste.com.tr';

  static const String calculateQualityOfLifeUri = '/api/calculate-quality-of-life';

  /// Shared Key
  static const String userType = 'user_type';
  static const String theme = 'theme';
  static const String token = 'token';
  static const String countryCode = 'country_code';
  static const String languageCode = 'language_code';

  static List<LanguageModel> languages = [
    LanguageModel(imageUrl: Images.turkish, languageName: 'Deutsch', countryCode: 'DE', languageCode: 'de'),
    LanguageModel(imageUrl: Images.turkish, languageName: 'English', countryCode: 'US', languageCode: 'en'),
    LanguageModel(imageUrl: Images.turkish, languageName: 'Türkçe', countryCode: 'TR', languageCode: 'tr'),
  ];

}