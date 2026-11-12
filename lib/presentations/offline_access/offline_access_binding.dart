import 'package:get/get.dart';
import 'package:qalbi/presentations/offline_access/offline_access_controller.dart';

class OfflineAccessBinding  extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => OfflineAccessController(), fenix: true);
  }
}