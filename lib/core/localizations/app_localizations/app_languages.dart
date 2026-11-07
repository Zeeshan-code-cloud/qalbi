import 'dart:ui';

class AppLanguages {
  static const Locale english = Locale('en', 'US');
  static const Locale arabic = Locale('ar', 'SA');
  static const Locale urdu = Locale('ur', 'PK');

   static const  List<Locale> supportedLocales = [
      english,
      arabic,
      urdu,
    ];

   static const defaultLanguage = "en_US";


  static const Map<String, String> languages = {
    'en_US': 'English',
    'ur_PK': 'اردو',
    'ar_SA': 'العربية',
  };
}