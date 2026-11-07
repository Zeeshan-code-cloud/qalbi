import 'package:get/get.dart';
import 'package:qalbi/presentations/qibla/qibla_controller.dart';

class QiblaBinding  extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(() => QiblaController(),fenix: true);
  }

}