import 'package:get/get.dart';
import 'package:qalbi/core/network/dio_client.dart';
import 'package:qalbi/presentations/holy_quran/data/repo_imple.dart';
import 'package:qalbi/presentations/holy_quran/repository/get_all_useCases.dart';
import 'package:qalbi/presentations/holy_quran/repository/surah_repository.dart';

import 'holly_quran_controller.dart';

class HollyQuranBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<DioClient>(() => DioClient());

    //Bind the repo and repo_implementations
    Get.lazyPut<SurahRepository>(
      () => RepoImple(dioClient: Get.find<DioClient>()),
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
