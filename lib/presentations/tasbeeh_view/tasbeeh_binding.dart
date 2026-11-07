 import 'package:get/get.dart';
import 'package:qalbi/presentations/tasbeeh_view/tasbeeh_controller.dart';

class TasbeehBinding  extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(() => TasbeehController(),fenix: true);
  }

}