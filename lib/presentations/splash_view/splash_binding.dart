

import '../export.dart';

class SplashBinding  extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(SplashController());
  }

}