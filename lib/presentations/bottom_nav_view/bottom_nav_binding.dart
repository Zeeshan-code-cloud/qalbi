import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:qalbi/core/network/api_const.dart';
import 'package:qalbi/presentations/calender_view/calender_binding.dart';
import 'package:qalbi/presentations/duas_view/data/dua_dhikr_repo_imple.dart';
import 'package:qalbi/presentations/duas_view/domain/dua_adhkar_use_case.dart';
import 'package:qalbi/presentations/duas_view/domain/duas_adhkar_repo.dart';
import 'package:qalbi/presentations/duas_view/duas_controller.dart';
import 'package:qalbi/core/network/dio_client.dart';
import 'package:qalbi/presentations/holy_quran/data/repo_imple.dart';
import 'package:qalbi/presentations/holy_quran/holly_quran_controller.dart';
import 'package:qalbi/presentations/holy_quran/repository/get_all_useCases.dart';
import 'package:qalbi/presentations/holy_quran/repository/surah_repository.dart';
import 'package:qalbi/presentations/home_view/home_binding.dart';
import '../setting_view/setting_controller.dart';
import 'bottom_nav_controller.dart';

class BottomNavBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    if (!Get.isRegistered<DioClient>()) {
      Get.lazyPut<DioClient>(() => DioClient());
    }
    if (!Get.isRegistered<SurahRepository>()) {
      Get.lazyPut<SurahRepository>(
        () => RepoImple(dioClient: Get.find<DioClient>()),
      );
    }
    if (!Get.isRegistered<GetAllUseCases>()) {
      Get.lazyPut<GetAllUseCases>(
        () => GetAllUseCases(surahRepository: Get.find<SurahRepository>()),
      );
    }

    Get.lazyPut<DuasAdhkarRepo>(() => Get.find<DuaDhikrRepoImple>());
    if (!Get.isRegistered<DuaAdhkarUseCase>()) {
      Get.lazyPut(
        () => DuaAdhkarUseCase(duasAdhkarRepo: Get.find<DuasAdhkarRepo>()),
      );
    }
    Get.lazyPut(() => BottomNavController(), fenix: true);
    HomeBinding().dependencies();
    Get.lazyPut(
      () => HollyQuranController(getAllUseCases: Get.find<GetAllUseCases>()),
      fenix: true,
    );

    if (Get.isRegistered<Dio>()) {
      Get.lazyPut(
        () => Dio(
          BaseOptions(
            baseUrl: ApiConst.baseUrl,
            receiveTimeout: Duration(seconds: 20),
            connectTimeout: Duration(seconds: 20),
          ),
        ),
        tag: "dua",
      );
    }

    if (Get.isRegistered<Dio>()) {
      Get.lazyPut(
        () => Dio(
          BaseOptions(
            baseUrl: ApiConst.dhikrCollection(""),
            receiveTimeout: Duration(seconds: 20),
            connectTimeout: Duration(seconds: 20),
          ),
        ),
        tag: "dhikr",
      );
    }

    if (!Get.isRegistered<DuasAdhkarRepo>()) {
      Get.lazyPut<DuasAdhkarRepo>(
        () => DuaDhikrRepoImple(
          duaDio: Get.find<Dio>(tag: "dua"),
          dhikrDio: Get.find<Dio>(tag: "dhikr"),
        ),
      );
    }
    if (!Get.isRegistered<DuaAdhkarUseCase>()) {
      Get.lazyPut(
        () => DuaAdhkarUseCase(duasAdhkarRepo: Get.find<DuasAdhkarRepo>()),
      );
    }
    Get.lazyPut(
      () => DuasController(duaAdhkarUseCase: Get.find<DuaAdhkarUseCase>()),
      fenix: true,
    );

    CalenderBinding().dependencies();
    Get.lazyPut(() => SettingController(), fenix: true);
  }
}
