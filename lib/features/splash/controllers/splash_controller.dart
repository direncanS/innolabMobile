import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vienna_life_quality/common/controllers/location_controller.dart';

import '../../../helper/route_helper.dart';
import '../domain/repositories/splash_repo.dart';

class SplashController extends GetxController implements GetxService {
  SplashController();

  var isConfigLoaded = false.obs;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  Future<void> checkFirstSeen() async {
    /*SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);

    if (_seen) {
      checkLoginStatus();
    } else {
      await prefs.setBool('seen', true);
      Get.toNamed(RouteHelper.getUserTypeScreenRoute());
    }*/
    await Future.delayed(const Duration(seconds: 1));
    Get.offAndToNamed(RouteHelper.getUserTypeScreenRoute());
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var _isLoggedIn = prefs.getString('access_token') != null;
    if (_isLoggedIn) {
      Get.toNamed(RouteHelper.getDashboardRoute(pageIndex: 0));
    } else {
      Get.toNamed(RouteHelper.getUserTypeScreenRoute());
    }
  }

  @override
  void onInit() {
    super.onInit();
    _requestPermissions();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    Get.find<LocationController>().initLocation();
  }

  @override
  void onReady() {
    super.onReady();
    checkFirstSeen();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  void _updateConnectionStatus(List<ConnectivityResult> result) {
    if (result.contains(ConnectivityResult.none)) {
      Get.toNamed(RouteHelper.getNoInternetRoute());
    } else {
      checkFirstSeen();
    }
  }

  Future<void> _requestPermissions() async {
    var permissionStatus = await Geolocator.checkPermission();
    if (permissionStatus == LocationPermission.denied) {
      permissionStatus = await Geolocator.requestPermission();
      if (permissionStatus == LocationPermission.denied) {
        // Handle permission denied by displaying a message or disabling location-based features
        Get.snackbar(
          'Permission Denied',
          'Location permission is required for some app features to work properly.',
          snackPosition: SnackPosition.bottom,
        );
      }
    }
  }
}
