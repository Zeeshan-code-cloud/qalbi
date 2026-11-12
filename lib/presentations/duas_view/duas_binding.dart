// import 'package:dio/dio.dart';
// import 'package:get/get.dart';
// import 'package:qalbi/core/network/api_const.dart';
// import 'package:qalbi/presentations/duas_view/data/dua_dhikr_repo_imple.dart';
// import 'package:qalbi/presentations/duas_view/domain/dua_adhkar_use_case.dart';
// import 'package:qalbi/presentations/duas_view/domain/duas_adhkar_repo.dart';
//
// import 'duas_controller.dart';
//
// class DuasBinding extends Bindings {
//   @override
//   void dependencies() {
//     // TODO: implement dependencies
//     Get.lazyPut<Dio>(
//       () => Dio(
//         BaseOptions(
//           baseUrl: ApiConst.duasList,
//           connectTimeout: const Duration(seconds: 15),
//           receiveTimeout: const Duration(seconds: 15),
//         ),
//       ),
//       tag: 'duaDio',
//     );
//
//     // Dio instance for Dhikr API
//     Get.lazyPut<Dio>(
//       () => Dio(
//         BaseOptions(
//           baseUrl: ApiConst.dhikrList,
//           connectTimeout: const Duration(seconds: 15),
//           receiveTimeout: const Duration(seconds: 15),
//         ),
//       ),
//       tag: 'dhikrDio',
//     );
//
//     Get.lazyPut<DuasAdhkarRepo>(
//       () => DuaDhikrRepoImple(
//         duaDio: Get.find<Dio>(tag: "duaDio"),
//         dhikrDio: Get.find<Dio>(tag: "dhikrDio"),
//       ),
//     );
//     Get.lazyPut(
//       () => DuaAdhkarUseCase(duasAdhkarRepo: Get.find<DuasAdhkarRepo>()),
//     );
//     Get.lazyPut(
//       () => DuasController(duaAdhkarUseCase: Get.find<DuaAdhkarUseCase>()),
//       fenix: true,
//     );
//   }
// }
