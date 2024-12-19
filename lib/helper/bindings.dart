import 'package:get/get.dart';
import 'package:vienna_life_quality/common/controllers/location_controller.dart';
import 'package:vienna_life_quality/features/auth/controllers/auth_controller.dart';

import '../features/home/controllers/quality_of_life_controller.dart';
import '../features/home/domain/repositories/quality_of_life_repository.dart';

class HomeScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QualityOfLifeController>(() => QualityOfLifeController(repository: QualityOfLifeRepository()));
  }
}
