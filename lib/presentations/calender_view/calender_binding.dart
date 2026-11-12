import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:qalbi/core/network/api_const.dart';
import 'package:qalbi/presentations/calender_view/data/repository/islamic_calendar_repo_impl.dart';
import 'package:qalbi/presentations/calender_view/domain/repository/islamic_calendar_repo.dart';
import 'package:qalbi/presentations/calender_view/use_cases/get_islamic_events_usecase.dart';
import 'package:qalbi/presentations/calender_view/use_cases/get_month_calendar_usecase.dart';

import 'calender_controller.dart';

class CalenderBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<Dio>(tag: 'calender')) {
      Get.lazyPut<Dio>(
        () => Dio(
          BaseOptions(
            baseUrl: ApiConst.islamicCalenderBaseUrl,
            connectTimeout: const Duration(seconds: 20),
            receiveTimeout: const Duration(seconds: 20),
          ),
        ),
        tag: 'calender',
      );
    }

    if (!Get.isRegistered<IslamicCalendarRepo>()) {
      Get.lazyPut<IslamicCalendarRepo>(
        () => IslamicCalendarRepoImpl(dio: Get.find<Dio>(tag: 'calender')),
      );
    }

    if (!Get.isRegistered<GetMonthCalendarUseCase>()) {
      Get.lazyPut<GetMonthCalendarUseCase>(
        () => GetMonthCalendarUseCase(
          repository: Get.find<IslamicCalendarRepo>(),
        ),
      );
    }

    if (!Get.isRegistered<GetIslamicEventsUseCase>()) {
      Get.lazyPut<GetIslamicEventsUseCase>(
        () => GetIslamicEventsUseCase(
          repository: Get.find<IslamicCalendarRepo>(),
        ),
      );
    }

    if (!Get.isRegistered<CalenderController>()) {
      Get.lazyPut<CalenderController>(
        () => CalenderController(
          getIslamicEventsUseCase: Get.find<GetIslamicEventsUseCase>(),
          getMonthCalendarUseCase: Get.find<GetMonthCalendarUseCase>(),
        ),
        fenix: true,
      );
    }
  }
}
