import 'package:get/get.dart';
import 'package:qalbi/presentations/home_view/home_binding.dart';
import 'package:qalbi/presentations/setting_view/setting_controller.dart';

class SettingBinding extends Bindings {
  @override
  void dependencies() {
    HomeBinding().dependencies();
    if (!Get.isRegistered<SettingController>()) {
      Get.lazyPut<SettingController>(() => SettingController(), fenix: true);
    }
  }
}
