import 'package:get/get.dart';
import 'package:qalbi/core/routes_config/routes.dart';
import 'package:qalbi/presentations/bottom_nav_view/bottom_nav_binding.dart';
import 'package:qalbi/presentations/bottom_nav_view/bottom_nav_view.dart';
import 'package:qalbi/presentations/calender_view/calender_binding.dart';
import 'package:qalbi/presentations/calender_view/calender_view.dart';
import 'package:qalbi/presentations/duas_view/duas_binding.dart';
import 'package:qalbi/presentations/duas_view/duas_view.dart';
import 'package:qalbi/presentations/holy_quran/holly_quran_binding.dart';
import 'package:qalbi/presentations/holy_quran/holy_quran_vew.dart';
import 'package:qalbi/presentations/home_view/home_binding.dart';
import 'package:qalbi/presentations/home_view/home_view.dart';
import 'package:qalbi/presentations/onboarding_view/onboarding_binding.dart';
import 'package:qalbi/presentations/onboarding_view/onboarding_view.dart';
import 'package:qalbi/presentations/qibla/qibla_binding.dart';
import 'package:qalbi/presentations/qibla/qibla_view.dart';
import 'package:qalbi/presentations/setting_view/setting_binding.dart';
import 'package:qalbi/presentations/setting_view/setting_view.dart';
import 'package:qalbi/presentations/splash_view/splash_binding.dart';
import 'package:qalbi/presentations/splash_view/splash_view.dart';
import 'package:qalbi/presentations/tasbeeh_view/tasbeeh_binding.dart';
import 'package:qalbi/presentations/tasbeeh_view/tasbeeh_view.dart';
import 'package:qalbi/presentations/zakat/zakat_binding.dart';
import 'package:qalbi/presentations/zakat/zakat_view.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: Routes.splashView,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.onboardingView,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.bottomNavView,
      page: () => const BottomNavView(),
      binding: BottomNavBinding(),
    ),
    GetPage(
      name: Routes.homeView,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.calenderView,
      page: () =>   CalenderView(),
      binding: CalenderBinding(),
    ),
    GetPage(
      name: Routes.duasView,
      page: () =>   DuasView(),
      binding: DuasBinding(),
    ),
    GetPage(
      name: Routes.holyQuranView,
      page: () => const HolyQuranVew(),
      binding: HollyQuranBinding(),
    ),
    GetPage(
      name: Routes.settingView,
      page: () => const SettingView(),
      binding: SettingBinding(),
    ),
    GetPage(
      name: Routes.zakatView,
      page: () =>   ZakatView(),
      binding: ZakatBinding(),
    ),
    GetPage(
      name: Routes.tasbeehView,
      page: () => const TasbeehView(),
      binding: TasbeehBinding(),
    ),
    GetPage(
      name: Routes.qiblaView,
      page: () => const QiblaView(),
      binding: QiblaBinding(),
    ),
  ];
}
