import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:qalbi/core/initial_binding/initial_binding.dart';
import 'package:qalbi/core/localizations/app_localizations/language_controller.dart';
import 'package:qalbi/core/routes_config/app_pages.dart';
import 'package:qalbi/presentations/export.dart';
import 'package:sizer/sizer.dart';
import 'core/adhan_notification_service/adhan_notification_service.dart';
import 'core/localizations/app_localizations/app_languages.dart';
import 'core/localizations/app_localizations/app_translations.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'core/theme/theme_controller.dart';

  void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterLocalization.instance.ensureInitialized();

  final languageC = Get.put(LanguageController(), permanent: true);
  await languageC.loadLanguage();
  final themeC = Get.put(ThemeController(), permanent: true);
  themeC.loadTheme();

  final adhanService = AdhanNotificationService();

  await adhanService.initialize();

  Get.put<AdhanNotificationService>(
    adhanService,
    permanent: true,
  );

  await Hive.initFlutter();

  await Hive.openBox('surahBox');
  await Hive.openBox('juzBox');
  await Hive.openBox('duaBox');
  await Hive.openBox('adhkarBox');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

   MyApp({super.key});

  final FlutterLocalization localization = FlutterLocalization.instance;
   @override
  Widget build(BuildContext context) {
    final languageC = Get.find<LanguageController>();
    final themeC = Get.find<ThemeController>();

    return Sizer(
      builder: (_, _, _) {
        return Obx(
          () => GetMaterialApp(
            initialBinding: InitialBinding(),
            fallbackLocale: AppLanguages.english,
            translations: AppTraanslations(),
            locale: languageC.selectedLocal.value,
            supportedLocales: AppLanguages.supportedLocales,
            localizationsDelegates:  localization.localizationsDelegates,
            debugShowCheckedModeBanner: false,
            title: 'Qalbi',
            themeMode: themeC.isDark.value ? ThemeMode.dark : ThemeMode.light,
            theme: ThemeData(
              brightness: Brightness.light,
              colorScheme: ColorScheme.fromSeed(
                seedColor: AppColors.primary,
                brightness: Brightness.light,
              ),
              scaffoldBackgroundColor: AppColors.lightBackground,
              fontFamily: "Inter",
              textTheme: const TextTheme(
                headlineLarge: TextStyle(
                  fontFamily: 'Cinzel',
                  fontWeight: FontWeight.bold,
                ),
                titleLarge: TextStyle(
                  fontFamily: 'Cinzel',
                  fontWeight: FontWeight.w600,
                ),
                bodyLarge: TextStyle(
                  fontFamily: 'Inter',
                ),
              ),
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF2CA780),
                brightness: Brightness.dark,
              ),
              scaffoldBackgroundColor: AppColors.darkBackground,
              fontFamily: "Inter",
              textTheme: const TextTheme(
                headlineLarge: TextStyle(
                  fontFamily: 'Cinzel',
                  fontWeight: FontWeight.bold,
                ),
                titleLarge: TextStyle(
                  fontFamily: 'Cinzel',
                  fontWeight: FontWeight.w600,
                ),
                bodyLarge: TextStyle(
                  fontFamily: 'Inter',
                ),
              ),
            ),
            getPages: AppPages.routes,
            initialRoute: Routes.splashView,
          ),
        );
      },
    );
  }
}
