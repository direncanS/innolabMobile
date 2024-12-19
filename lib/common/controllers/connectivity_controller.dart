import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../helper/route_helper.dart';

class ConnectivityController extends GetxController with WidgetsBindingObserver {
  final Connectivity _connectivity = Connectivity();
  RxBool isConnected = true.obs;
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  String? lastFailedRoute;

  void checkConnection() async {
    debugPrint('Checking connection...');
    List<ConnectivityResult> results = await _connectivity.checkConnectivity();
    _updateConnectionStatus(results);
  }

  @override
  void onInit() {
    super.onInit();
    debugPrint('ConnectivityController onInit');
    WidgetsBinding.instance.addObserver(this);
    _checkInitialConnection();
    _connectivitySubscription = _connectivity.onConnectivityChanged
        .map((result) => result)  // Tek sonucu listeye çevirir
        .listen((List<ConnectivityResult> results) {
      _updateConnectionStatus(results);
    });
  }

  Future<void> _checkInitialConnection() async {
    debugPrint('Checking initial connection...');
    List<ConnectivityResult> results = await _connectivity.checkConnectivity();
    _updateConnectionStatus(results);
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    debugPrint('Updating connection status...');
    bool hasConnection = results.isNotEmpty && results.any((result) => result != ConnectivityResult.none);
    isConnected.value = hasConnection;
    debugPrint('hasConnection: $hasConnection');
    debugPrint('isConnected: ${isConnected.value}');
    debugPrint('lastFailedRoute: $lastFailedRoute');

    if (!hasConnection && isConnected.value) {
      isConnected.value = false;
      lastFailedRoute = Get.currentRoute;
      _navigateToNoInternetScreen();
    } else if (hasConnection && !isConnected.value) {
      isConnected.value = true;
      Get.back();

      if (lastFailedRoute != null && lastFailedRoute != RouteHelper.splash) {
        Get.toNamed(lastFailedRoute!);
      } else {
        Get.toNamed(RouteHelper.userTypeScreen);
      }
      lastFailedRoute = null;
    }
  }

  void _navigateToNoInternetScreen() {
    debugPrint('Navigating to NoInternetScreen...');
    if (Get.currentRoute != RouteHelper.noInternet) {
      Get.toNamed(RouteHelper.noInternet);
    }
  }

  @override
  void onClose() {
    _connectivitySubscription.cancel();
    WidgetsBinding.instance.removeObserver(this);
    debugPrint('ConnectivityController onClose');
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkInitialConnection();
    }
  }
}
