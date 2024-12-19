import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class AppLayout {
  static final double _screenHeight = Get.height - Get.bottomBarHeight - Get.statusBarHeight;
  static final double _screenWidth = Get.width;

  static const double _referenceHeight = 932.0;
  static const double _referenceWidth = 430.0;

  // Cache the scale factors to avoid repeated calculations
  static final double _heightFactor = _screenHeight / _referenceHeight;
  static final double _widthFactor = _screenWidth / _referenceWidth;

  /// Gets scaled height based on the reference height
  static double getHeight(double pixels) {
    return pixels * _heightFactor;
  }

  /// Gets scaled width based on the reference width
  static double getWidth(double pixels) {
    return pixels * _widthFactor;
  }

  static const boxShadow = BoxShadow(
    color: Color.fromRGBO(0, 0, 0, 0.1),
    blurRadius: 30,
    offset: Offset(0, 0),
  );
}
