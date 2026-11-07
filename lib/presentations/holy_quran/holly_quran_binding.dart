import 'package:get/get.dart';

import 'holly_quran_controller.dart';

class HollyQuranBinding  extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(() => HollyQuranController(),fenix: true);
  }

}