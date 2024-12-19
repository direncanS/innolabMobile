// ignore: unused_import
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:vienna_life_quality/common/screens/no_internet_screen.dart';
import 'package:vienna_life_quality/features/home/screens/home_screen.dart';

import '../common/controllers/connectivity_controller.dart';
import '../features/auth/screens/choose_user_type_screen.dart';
import '../features/splash/screens/splash_screen.dart';
import 'bindings.dart';

class RouteHelper {
  static const String initial = '/';
  static const String splash = '/splash';
  static const String userTypeScreen = '/user-type';
  static const String noInternet = '/no-internet';
  static const String home = '/home';

  static const String dashboard = '/dashboard';
  static const String signIn = '/sign-in';
  static const String onBoarding = '/on-boarding';
  static const String userProfile = '/profile';
  static const String generalSettings = '/general-settings';
  static const String notificationSettings = '/notification-settings';
  static const String privacySettings = '/privacy-settings';
  static const String createPost = '/create-post';
  static const String findFriendsScreen = "/find-friends";
  static const String referAndEarnScreen = "/refer-and-earn";

  static String getInitialRoute({bool fromSplash = false}) =>
      '$initial?from-splash=$fromSplash';

  static String getSplashRoute() => splash;

  static String getUserTypeScreenRoute() => userTypeScreen;

  static String getDashboardRoute({required int pageIndex}) =>
      '$dashboard?page-index=$pageIndex';

  static String getNoInternetRoute() => noInternet;

  static String getHomeRoute() => home;

  static List<GetPage> routes = [
    GetPage(
      name: splash,
      page: () => getRoute(SplashScreen()),
    ),

    GetPage(
        name: userTypeScreen,
        page: () => getRoute(ChooseUserTypeScreen())
    ),

    GetPage(
        name: noInternet,
        page: () => getRoute(NoInternetScreen())
    ),

    GetPage(
        name: home,
        page: () => getRoute(HomeScreen()),
    ),
  ];

  static getRoute(Widget? navigateTo, {bool byPuss = false}) {
    // Connectivity check
    bool isConnected = Get.find<ConnectivityController>().isConnected.value;

    // Eğer bağlantı yoksa NoInternetScreen'e yönlendirilir.
    if (!isConnected) {
      return NoInternetScreen();
    }

    // Version ve bakım modları için gerekli kontroller burada yapılabilir
    return navigateTo;
  }

}
