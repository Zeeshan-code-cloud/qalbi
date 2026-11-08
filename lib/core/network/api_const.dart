class ApiConst {
  ApiConst._();
  static const String baseUrl = 'https://api.alquran.cloud/v1';

  static const String allSurahs = '/surah';

  static String surahDetails(int number) => '/surah/$number';

  static String surahTranslation(int number, String edition) =>
      '/surah/$number/$edition';

  static String surahMultipleEditions(
      int number,
      String editions,
      ) => '/surah/$number/editions/$editions';

  static const String editions = '/edition';
}