import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController implements GetxService {

  final SharedPreferences sharedPreferences = Get.find();
  final RxString userType = ''.obs;
  final RxString userTypeText = ''.obs;

  void setUserType(String type) {
    debugPrint('Setted user type: $type');
    sharedPreferences.setString('userType', type);
    userType.value = type;
  }

  String getUserType() {
    switch (userType.value) {
      case 'parent':
        userTypeText.value = 'parent'.tr;
        return 'parent'.tr;
      case 'student':
        userTypeText.value = 'student'.tr;
        return 'student'.tr;
      case 'retiree':
        userTypeText.value = 'retiree'.tr;
        return 'retiree'.tr;
      default:
        return '';
    }
  }

}