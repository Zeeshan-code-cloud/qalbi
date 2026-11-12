class ApiConst {
  ApiConst._();
  static const String baseUrl = 'https://api.alquran.cloud/v1';

  static const String allSurahs = '/surah';

  static const String duasList = "https://ummahapi.com/api/duas";
  static   String dhikrCollection(String slug) =>
      'https://athkar-api.thkeecdn.com/v1/collections/$slug';
  static String surahDetails(int number) => '/surah/$number';


  static const String arabicEdition = 'quran-uthmani';
  static const String translationEdition = 'en.sahih';

// Surah
  static String surahTranslation(int number) =>
      '/surah/$number/$translationEdition';

// Juz
  static String juzTranslation(int number) =>
      '/juz/$number/$translationEdition';

  static String surahMultipleEditions(
      int number,
      String editions,
      ) => '/surah/$number/editions/$editions';

  static String surahUrduTranslation(int number) =>
      'https://api.alquran.cloud/v1/surah/$number/ur.jalandhry';

  static String juzUrduTranslation(int number) =>
      'https://api.alquran.cloud/v1/juz/$number/ur.jalandhry';



  static const String editions = '/edition';
  static String jusDetails(int number) => "/juz/$number";


  static const String islamicCalenderBaseUrl =
      'https://api.aladhan.com/v1';

  // Gregorian month converted into Hijri calendar
  static String monthCalendar(int month, int year) =>
      '/gToHCalendar/$month/$year';

  // All special Islamic days
  static const String specialDays = '/specialDays';

  // Hijri holidays for a particular year
  static String holidaysByYear(int year) =>
      '/islamicHolidaysByHijriYear/$year';



  static const String adhanBaseUrl =
      'https://api.aladhan.com/v1';

  static String prayerTimings(String date) =>
      '/timings/$date';

}