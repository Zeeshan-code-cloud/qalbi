import 'package:get/get.dart';
import 'package:qalbi/presentations/zakat/zakat_controller.dart';

class ZakatBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(() => ZakatController(),fenix: true);
  }

}