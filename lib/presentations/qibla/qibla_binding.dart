import 'package:get/get.dart';
import 'package:qalbi/presentations/qibla/qibla_controller.dart';
import 'package:qalbi/presentations/qibla/qibla_repository.dart';
import 'package:qalbi/presentations/qibla/qibla_repository_imple.dart';

import 'get_qibla_use_case.dart';

class QiblaBinding  extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<QiblaRepository>(
          () => QiblaRepositoryImpl(),
    );

    Get.lazyPut<GetQiblaDirectionUseCase>(
          () => GetQiblaDirectionUseCase(
        repository: Get.find<QiblaRepository>(),
      ),
    );

    Get.lazyPut<QiblaController>(
          () => QiblaController(
        getQiblaDirectionUseCase:
        Get.find<GetQiblaDirectionUseCase>(),
      ),
      fenix: true,
    );
  }

}