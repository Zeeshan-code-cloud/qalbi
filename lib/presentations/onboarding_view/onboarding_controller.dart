import 'package:qalbi/presentations/export.dart';
import 'package:qalbi/presentations/onboarding_view/onboarding_model.dart';

class OnboardingController extends GetxController {
  final pageC = PageController();
  final RxInt currentIndex = 0.obs;

  List<OnboardingModel> onboardingList = [
    OnboardingModel(
      titles: "Accurate\nPrayer Times",
      captions: "Never miss a prayer with precise time based on your locations",
      images: AppAssets.onboarding1,
    ),
    OnboardingModel(
      titles: "Explore\nThe Holy Quran",
      captions: "Read listen and understand with translations",
      images: AppAssets.onboarding2,
    ),
    OnboardingModel(
      titles: "Duas & Adhkar\nfor Daily Life ",
      captions: "Strengthen with authentic supplications",
      images: AppAssets.onboarding3,
    ),
  ];

  void setIndex(int index) {
    currentIndex.value = index;
  }

  void nextPage() {
    if(currentIndex.value == onboardingList.length -1){
      getStarted();
    }
    pageC.nextPage(duration: Duration(milliseconds: 220), curve: Curves.easeInOut);
  }
  Future<void> getStarted()  async {
    Get.offAllNamed(Routes.bottomNavView);
  }
}
