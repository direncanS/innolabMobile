import 'package:get/get.dart';
import 'package:vienna_life_quality/common/controllers/location_controller.dart';
import 'package:vienna_life_quality/features/auth/controllers/auth_controller.dart';

import '../domain/models/quality_of_life_response_model.dart';
import '../domain/repositories/quality_of_life_repository.dart';

class QualityOfLifeController extends GetxController implements GetxService {
  final QualityOfLifeRepository repository;
  var qualityOfLifeData = Rxn<QualityOfLifeResponse>();
  var isLoading = false.obs;

  QualityOfLifeController({required this.repository});

  final LocationController locationController = Get.find();
  final AuthController authController = Get.find();

  @override
  void onInit() async {
    super.onInit();

    await locationController.initLocation();

    if (locationController.currentPosition.value != null) {
      fetchQualityOfLifeData(
        latitude: locationController.currentPosition.value!.latitude.toString(),
        longitude:
            locationController.currentPosition.value!.longitude.toString(),
        userType: authController.userType.value,
        subDistrictName: locationController.subDistrictName.value,
      );
    } else {
      print("Current position is null");
    }
  }

  Future<void> fetchQualityOfLifeData(
      {required String latitude,
      required String longitude,
      required String userType,
      required String subDistrictName}) async {
    isLoading.value = true;
    if (locationController.currentPosition.value != null) {
      try {
        qualityOfLifeData.value = await repository.fetchQualityOfLifeData(
          latitude: latitude,
          longitude: longitude,
          userType: userType,
          subDistrictName: subDistrictName,
        );
      } catch (e) {
        print('Error fetching quality of life data: $e');
      } finally {
        isLoading.value = false;
      }
    }
  }

  String recommendation(String userType) {
    if (qualityOfLifeData.value != null) {
      if (qualityOfLifeData.value!.qualityOfLifeScore >= 90) {
        return '90_score_recommendation'.trParams({'userType': userType});
      } else if (qualityOfLifeData.value!.qualityOfLifeScore >= 80) {
        return '80_score_recommendation'.trParams({'userType': userType});
      } else if (qualityOfLifeData.value!.qualityOfLifeScore >= 70) {
        return '70_score_recommendation'.trParams({'userType': userType});
      } else if (qualityOfLifeData.value!.qualityOfLifeScore >= 60) {
        return '60_score_recommendation'.trParams({'userType': userType});
      } else if (qualityOfLifeData.value!.qualityOfLifeScore >= 50) {
        return '50_score_recommendation'.trParams({'userType': userType});
      } else if (qualityOfLifeData.value!.qualityOfLifeScore >= 40) {
        return '40_score_recommendation'.trParams({'userType': userType});
      } else if (qualityOfLifeData.value!.qualityOfLifeScore >= 30) {
        return '30_score_recommendation'.trParams({'userType': userType});
      } else if (qualityOfLifeData.value!.qualityOfLifeScore >= 20) {
        return '20_score_recommendation'.trParams({'userType': userType});
      } else {
        return 'no_score_recommendation'.tr;
      }
    } else {
      return 'no_data'.tr;
    }
  }
}
