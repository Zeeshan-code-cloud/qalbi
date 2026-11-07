
import 'package:qalbi/core/localizations/app_localizations/language_controller.dart';
import 'package:qalbi/core/theme/theme_controller.dart';

import '../../core/localizations/app_localizations/app_languages.dart';
import '../export.dart';

class SettingController extends GetxController {
  final  langC = Get.find<LanguageController>();
  final themeC = Get.find<ThemeController>();
  final selectedLanguage = 'English'.obs;
  final selectedTheme = 'Light'.obs;
  final prayerCalculationMethod = 'Muslim World League'.obs;

  @override
  void onInit() {
    super.onInit();
    selectedLanguage.value = getLanguageName(langC.selectedLocal.value.languageCode);
    selectedTheme.value = themeC.isDark.value ? 'Dark' : 'Light';
    ever(themeC.isDark, (bool dark) {
      selectedTheme.value = dark ? 'Dark' : 'Light';
    });
  }

  void changeTheme(String theme) {
    selectedTheme.value = theme;
    themeC.setTheme(theme == 'Dark');
  }

  String getLanguageName(String language){
  switch(language){

    case 'ur':
      return 'اردو';
    case 'ar':
      return 'العربية';
    case 'en':
    default:
      return 'English';

  }
  }
 Future<void>  changeLanguage(String language) async {

    selectedLanguage.value = language;
    switch(language){
      case "English":
        await langC.changeLang(AppLanguages.english);
        break;
      case "اردو":
        await langC.changeLang(AppLanguages.urdu);
        break;

      case "العربية":
        await langC.changeLang(AppLanguages.arabic);
        break;

    }
   }



  void changePrayerMethod(String method) {
    prayerCalculationMethod.value = method;
    // Recalculate prayer times using your prayer-time service.
  }

  void openPrivacyPolicy() {
    Get.toNamed('/privacy-policy');
  }

  void openTerms() {
    Get.toNamed('/terms');
  }

  void rateApp() {
    // Open your app's Play Store listing.
  }

  void shareApp() {
    // Connect share_plus here.
  }

  void contactSupport() {
    Get.toNamed('/support');
  }
}