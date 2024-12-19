import 'dart:ui';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../api/api_client.dart';
import '../../util/app_constants.dart';
import '../models/language_model.dart';

class LocalizationController extends GetxController implements GetxService {
  final SharedPreferences sharedPreferences;

  LocalizationController({required this.sharedPreferences}) {
    loadCurrentLanguage();
  }

  Locale _locale = Locale(AppConstants.languages[0].languageCode!, AppConstants.languages[0].countryCode);
  bool _isLtr = true;
  List<LanguageModel> _languages = [];
  int _selectedIndex = 0;

  Locale get locale => _locale;
  bool get isLtr => _isLtr;
  List<LanguageModel> get languages => _languages;
  int get selectedIndex => _selectedIndex;

  void setLanguage(Locale locale) {
    _locale = locale;
    _isLtr = _locale.languageCode != 'ar';  // Arapça dili haricindeki diller için sola dayalı düzen
    saveLanguage(_locale);
    Get.updateLocale(locale);  // GetX ile dili güncelle
    update();
  }

  void loadCurrentLanguage() {
    // Kaydedilen dil tercihini yükle
    String? languageCode = sharedPreferences.getString(AppConstants.languageCode);
    String? countryCode = sharedPreferences.getString(AppConstants.countryCode);

    // Eğer kaydedilmiş dil yoksa varsayılan dili kullan
    _locale = Locale(languageCode ?? AppConstants.languages[0].languageCode!,
        countryCode ?? AppConstants.languages[0].countryCode);
    _isLtr = _locale.languageCode != 'ar';

    // Seçili dilin indexini ayarla
    for (int index = 0; index < AppConstants.languages.length; index++) {
      if (AppConstants.languages[index].languageCode == _locale.languageCode) {
        _selectedIndex = index;
        break;
      }
    }

    // Mevcut dilleri yükle
    _languages = AppConstants.languages;
    update();
  }

  void saveLanguage(Locale locale) async {
    await sharedPreferences.setString(AppConstants.languageCode, locale.languageCode);
    await sharedPreferences.setString(AppConstants.countryCode, locale.countryCode!);
  }

  void setSelectIndex(int index) {
    _selectedIndex = index;
    update();
  }

  void searchLanguage(String query) {
    if (query.isEmpty) {
      _languages = AppConstants.languages;
    } else {
      _languages = AppConstants.languages.where((language) =>
          language.languageName!.toLowerCase().contains(query.toLowerCase())
      ).toList();
    }
    update();
  }
}

