import 'package:get/get.dart';
import 'package:qalbi/presentations/calender_view/calender_controller.dart';
import 'package:qalbi/presentations/duas_view/duas_controller.dart';
import 'package:qalbi/presentations/holy_quran/holly_quran_controller.dart';
import 'package:qalbi/presentations/home_view/home_controller.dart';

import '../setting_view/setting_controller.dart';
import 'bottom_nav_controller.dart';

class BottomNavBinding  extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(() => BottomNavController(),fenix: true);
    Get.lazyPut(() => HomeController(),fenix: true);
    Get.lazyPut(() => HollyQuranController(),fenix: true);
    Get.lazyPut(() => DuasController(),fenix: true);
    Get.lazyPut(() => CalenderController(),fenix: true);
    Get.lazyPut(() => SettingController(),fenix: true);

  }

}