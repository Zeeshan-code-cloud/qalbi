import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:qalbi/core/localizations/app_localizations/app_languages.dart';
import 'package:qalbi/core/storage_keys/storage_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageController  extends GetxController{

  Rx<Locale> selectedLocal = AppLanguages.english.obs;
  late SharedPreferences preferences;

  @override
  void onInit()   {
    // TODO: implement onInit
    super.onInit();
      loadLanguage();
  }

  Future<void> loadLanguage() async {
    preferences = await SharedPreferences.getInstance();

    final savedLang = preferences.getString(StorageKeys.selectedLan);
    if(savedLang ==  null){
      selectedLocal.value = AppLanguages.english;
      return;
    }

    final locale = getLocalFromCode(savedLang);
    selectedLocal.value = locale;
    Get.updateLocale(locale);
  }

  Locale getLocalFromCode(String code){
    switch(code){
      case "ur_PK":
        return AppLanguages.urdu;
      case "ar_SA":
        return AppLanguages.arabic;
      case "en_US":
        return AppLanguages.english;

      default:
        return AppLanguages.english;
    }
  }

  Future<void> changeLang(Locale locale)async{
     selectedLocal.value = locale;
     final selectedLang = "${locale.languageCode}_${locale.countryCode}";
     await preferences.setString(StorageKeys.selectedLan, selectedLang);
     Get.updateLocale(locale);
  }
}