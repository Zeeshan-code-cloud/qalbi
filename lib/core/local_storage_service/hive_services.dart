import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static Box get surahBox => Hive.box('surahBox');
  static Box get juzBox => Hive.box('juzBox');
  static Box get duaBox => Hive.box('duaBox');
  static Box get adhkarBox => Hive.box('adhkarBox');

  // Quran: Surah list
  static Future<void> saveAllSurahs(
      List<dynamic> data,
      ) async {
    await surahBox.put('all_surahs', data);
  }

  static List<dynamic>? getAllSurahs() {
    final data = surahBox.get('all_surahs');
    return data == null ? null : List<dynamic>.from(data);
  }

  // Quran: Individual Surah
  static Future<void> saveSurah(
      int number,
      Map<String, dynamic> data,
      ) async {
    await surahBox.put('surah_$number', data);
  }

  static Map<String, dynamic>? getSurah(int number) {
    final data = surahBox.get('surah_$number');

    return data == null
        ? null
        : Map<String, dynamic>.from(data);
  }

  // Quran: Individual Juz
  static Future<void> saveJuz(
      int number,
      Map<String, dynamic> data,
      ) async {
    await juzBox.put('juz_$number', data);
  }

  static Map<String, dynamic>? getJuz(int number) {
    final data = juzBox.get('juz_$number');

    return data == null
        ? null
        : Map<String, dynamic>.from(data);
  }

  // Duas
  static Future<void> saveDuas(List<dynamic> data) async {
    await duaBox.put('all_duas', data);
  }

  static List<dynamic>? getDuas() {
    final data = duaBox.get('all_duas');

    return data == null ? null : List<dynamic>.from(data);
  }

  // Adhkar collections
  static Future<void> saveAdhkar(
      String slug,
      List<dynamic> data,
      ) async {
    await adhkarBox.put('collection_$slug', data);
  }

  static List<dynamic>? getAdhkar(String slug) {
    final data = adhkarBox.get('collection_$slug');

    return data == null ? null : List<dynamic>.from(data);
  }
}