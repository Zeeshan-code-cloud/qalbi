import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:qalbi/presentations/holy_quran/repository/surah_repository.dart';
import '../../presentations/duas_view/data/dua_dhikr_repo_imple.dart';
import '../../presentations/duas_view/domain/dua_adhkar_use_case.dart';
import '../../presentations/duas_view/domain/duas_adhkar_repo.dart';
import '../../presentations/duas_view/duas_controller.dart';
import '../../presentations/holy_quran/data/repo_imple.dart';
import '../../presentations/holy_quran/holly_quran_controller.dart';
import '../../presentations/holy_quran/repository/get_all_useCases.dart';
import '../network/api_const.dart';
import '../network/dio_client.dart';

class InitialBinding  extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies

    Get.lazyPut<DioClient>(() => DioClient());
    Get.put(DioClient(), permanent: true);

    //Bind the repo and repo_implementations
    Get.lazyPut<SurahRepository>(
          () => RepoImple(dioClient: Get.find<DioClient>()),
    );

    Get.lazyPut<Dio>(
          () => Dio(
        BaseOptions(
          baseUrl: ApiConst.duasList,
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
        ),
      ),
      tag: 'duaDio',
    );

    // Dio instance for Dhikr API
    Get.lazyPut<Dio>(
          () => Dio(
        BaseOptions(
          baseUrl: ApiConst.dhikrCollection(""),
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
        ),
      ),
      tag: 'dhikrDio',
    );

    Get.lazyPut<DuasAdhkarRepo>(
          () => DuaDhikrRepoImple(
        duaDio: Get.find<Dio>(tag: "duaDio"),
        dhikrDio: Get.find<Dio>(tag: "dhikrDio"),
      ),
    );
    Get.lazyPut(
          () => DuaAdhkarUseCase(duasAdhkarRepo: Get.find<DuasAdhkarRepo>()),
    );
    Get.lazyPut(
          () => DuasController(duaAdhkarUseCase: Get.find<DuaAdhkarUseCase>()),
      fenix: true,
    );

    Get.lazyPut(
          () => GetAllUseCases(surahRepository: Get.find<SurahRepository>()),
    );
    Get.lazyPut(
          () => HollyQuranController(getAllUseCases: Get.find<GetAllUseCases>()),
      fenix: true,
    );
  }


}