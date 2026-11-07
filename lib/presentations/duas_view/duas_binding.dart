import 'package:get/get.dart';

import 'duas_controller.dart';

class DuasBinding  extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(() => DuasController(),fenix: true);
  }

}