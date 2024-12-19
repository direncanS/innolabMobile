import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vienna_life_quality/features/auth/controllers/auth_controller.dart';
import 'package:vienna_life_quality/features/home/controllers/quality_of_life_controller.dart';

import '../../helper/route_helper.dart';
import 'package:http/http.dart' as http;

class LocationController extends GetxController implements GetxService {
  Rx<Position?> currentPosition = Rx<Position?>(null);
  RxBool isLocationServiceEnabled = false.obs;
  RxBool isPermissionGranted = false.obs;
  var currentAddress = ''.obs;
  var subDistrictName = ''.obs;
  RxBool isInVienna = false.obs;
  GoogleMapController? mapController;
  final String googleApiKey = 'AIzaSyAaL7L4ytYOgXYkt5607MVEXi5BqtrSFkM';
  bool _isPermissionRequestInProgress = false;

  final AuthController authController = Get.find();

  final double northBoundary = 48.3237;
  final double southBoundary = 48.1176;
  final double eastBoundary = 16.5770;
  final double westBoundary = 16.1830;

  @override
  void onInit() {
    super.onInit();
    ever(currentAddress, (_) {
      update();
    });
    initLocation();
  }

  Future<void> initLocation() async {

    if (_isPermissionRequestInProgress) {
      debugPrint('Permission request already in progress.');
      return;
    }

    _isPermissionRequestInProgress = true;

    try{
      isLocationServiceEnabled.value = await Geolocator.isLocationServiceEnabled();
      if (!isLocationServiceEnabled.value) {
        Get.toNamed(RouteHelper.getInitialRoute());
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.toNamed(RouteHelper.getInitialRoute());
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Get.toNamed(RouteHelper.getInitialRoute());
        return;
      }

      currentPosition.value = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
      );

      debugPrint('Current position: ${currentPosition.value}');

      await updateLocationDetails();
      _moveCameraToCurrentPosition();
    } catch (e) {
      debugPrint('An error occurred while requesting location: $e');
    } finally {
      _isPermissionRequestInProgress = false;
    }
  }

  Future<void> updateLocationDetails() async {
    if (currentPosition.value != null) {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        currentPosition.value!.latitude,
        currentPosition.value!.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];

        currentAddress.value = (place.subLocality != null && place.subLocality!.trim().isNotEmpty)
            ? '${place.subLocality}, ${place.locality}'
            : '${place.locality}';

        isInVienna.value = _checkIfWithinViennaBounds(currentPosition.value!);
        subDistrictName.value = place.subLocality ?? '';

        update();
        Get.find<QualityOfLifeController>().fetchQualityOfLifeData(
          latitude: currentPosition.value!.latitude.toString(),
          longitude: currentPosition.value!.longitude.toString(),
          userType: authController.userType.value,
          subDistrictName: subDistrictName.value,
        );
        _moveCameraToCurrentPosition();
      }
    }
  }

  bool _checkIfWithinViennaBounds(Position position) {
    return position.latitude >= southBoundary &&
        position.latitude <= northBoundary &&
        position.longitude >= westBoundary &&
        position.longitude <= eastBoundary;
  }

  Future<List<String>> getAutocompleteSuggestions(String input) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$googleApiKey';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final predictions = data['predictions'] as List;
      return predictions.map((p) => p['description'] as String).toList();
    } else {
      throw Exception('Failed to fetch suggestions');
    }
  }

  Future<Position?> getPlaceCoordinates(String address) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$address&inputtype=textquery&fields=geometry&key=$googleApiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['candidates'] != null && data['candidates'].isNotEmpty) {
        final geometry = data['candidates'][0]['geometry']['location'];
        final latitude = geometry['lat'];
        final longitude = geometry['lng'];
        return Position(
          latitude: latitude,
          longitude: longitude,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          heading: 0,
          speed: 0,
          speedAccuracy: 0,
          altitudeAccuracy: 0,
          headingAccuracy: 0,
        );
      }
    }
    return null;
  }

  Future<void> updatePositionFromAddress(String address) async {
    try {
      Position? location;
      await updateLocationDetails();

      try {
        final locations = await locationFromAddress(address);
        if (locations.isNotEmpty) {
          location = Position(
            latitude: locations.first.latitude,
            longitude: locations.first.longitude,
            timestamp: DateTime.now(),
            accuracy: 0,
            altitude: 0,
            heading: 0,
            speed: 0,
            speedAccuracy: 0,
            altitudeAccuracy: 0,
            headingAccuracy: 0,
          );
        }
      } catch (geocodingError) {
        debugPrint('Geocoding is not available: $geocodingError');
      }

      if (location == null) {
        debugPrint('Google Places API for address: $address');
        location = await getPlaceCoordinates(address);
      }

      if (location != null) {
        currentPosition.value = location;
        currentAddress.value = address;

        isInVienna.value = _checkIfWithinViennaBounds(currentPosition.value!);

        debugPrint('The address is updated: $address');
        debugPrint('New coordinates: (${location.latitude}, ${location.longitude})');
        update();
        _moveCameraToCurrentPosition();
        Get.find<QualityOfLifeController>().fetchQualityOfLifeData(
          latitude: currentPosition.value!.latitude.toString(),
          longitude: currentPosition.value!.longitude.toString(),
          userType: authController.userType.value,
          subDistrictName: subDistrictName.value,
        );
      } else {
        debugPrint('The address is not found: $address');
        Get.snackbar(
          "The address is not found",
          "Please enter a valid address.",
          snackPosition: SnackPosition.bottom,
        );
      }
    } catch (e) {
      debugPrint('An error occurred while updating the position: $e');
      Get.snackbar(
        "Error",
        "An error occurred while updating the position.",
        snackPosition: SnackPosition.bottom,
      );
    }
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _moveCameraToCurrentPosition() {
    if (mapController != null && currentPosition.value != null) {
      mapController!.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(
            currentPosition.value!.latitude,
            currentPosition.value!.longitude,
          ),
        ),
      );
    }
  }
}
