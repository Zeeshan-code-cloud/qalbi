



import '../export.dart';

class SplashController  extends GetxController with GetTickerProviderStateMixin{

  late AnimationController animationController;
  late Animation<Offset> animation;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    moveToOnboarding();
  }

  void moveToOnboarding() {
    Future.delayed(const Duration(seconds: 2), () {
      Get.offNamed(Routes.onboardingView);
    });
  }

}