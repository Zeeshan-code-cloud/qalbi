import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:qalbi/core/adhan_notification_service/adhan_notification_service.dart';
import 'package:qalbi/core/network/api_const.dart';
import 'package:qalbi/presentations/home_view/data/prayer_times_repository_impl.dart';
import 'package:qalbi/presentations/home_view/domain/repository/prayer_times_repository.dart';
import 'package:qalbi/presentations/home_view/domain/use_case/get_prayer_times_usecase.dart';

import 'home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<Dio>(tag: 'adhan')) {
      Get.lazyPut<Dio>(
        () => Dio(BaseOptions(
          baseUrl: ApiConst.adhanBaseUrl,
          connectTimeout: const Duration(seconds: 20),
          receiveTimeout: const Duration(seconds: 20),
        )),
        tag: 'adhan',
      );
    }
    if (!Get.isRegistered<PrayerTimesRepository>()) {
      Get.lazyPut<PrayerTimesRepository>(
        () => PrayerTimesRepositoryImpl(dio: Get.find<Dio>(tag: 'adhan')),
      );
    }
    if (!Get.isRegistered<GetPrayerTimesUseCase>()) {
      Get.lazyPut<GetPrayerTimesUseCase>(
        () => GetPrayerTimesUseCase(
          repository: Get.find<PrayerTimesRepository>(),
        ),
      );
    }
    if (!Get.isRegistered<HomeController>()) {
      Get.lazyPut<HomeController>(
        () => HomeController(
          getPrayerTimesUseCase: Get.find<GetPrayerTimesUseCase>(),
          notificationService: Get.find<AdhanNotificationService>(),
        ),
        fenix: true,
      );
    }
  }
}
