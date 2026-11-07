import 'package:get/get.dart';
import 'package:qalbi/presentations/setting_view/setting_controller.dart';

class SettingBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(() => SettingController(),fenix: true);
  }
 }