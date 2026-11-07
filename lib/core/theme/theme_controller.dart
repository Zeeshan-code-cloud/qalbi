import 'package:qalbi/core/storage_keys/storage_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../presentations/export.dart';

class ThemeController  extends GetxController{
  RxBool isDark = false.obs;

  @override
  void onInit() async  {
    // TODO: implement onInit
    super.onInit();
     loadTheme();
  }

   void loadTheme() async {
    final preferences = await SharedPreferences.getInstance();
    isDark.value = preferences.getBool(StorageKeys.selectedTheme) ?? false;
    Get.changeThemeMode(
      isDark.value ? ThemeMode.dark : ThemeMode.light,
    );
  }

  void setTheme(bool dark) async {
    isDark.value = dark;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(StorageKeys.selectedTheme, dark);
    Get.changeThemeMode(
      dark ? ThemeMode.dark : ThemeMode.light,
    );
  }

  void toggledTheme() {
    setTheme(!isDark.value);
  }

}