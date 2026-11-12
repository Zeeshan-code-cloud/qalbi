import 'dart:async';

import 'package:qalbi/core/network/api_const.dart';
import 'package:qalbi/core/network/dio_client.dart';
import 'package:qalbi/presentations/holy_quran/data/juz_details_model.dart';
import 'package:qalbi/presentations/holy_quran/data/juz_model.dart';
import 'package:qalbi/presentations/holy_quran/data/surah_model.dart';
import 'package:qalbi/presentations/holy_quran/repository/juz_details_entity.dart';
import 'package:qalbi/presentations/holy_quran/repository/juz_entity.dart';
import 'package:qalbi/presentations/holy_quran/repository/surah_entity.dart';
import 'package:qalbi/presentations/holy_quran/repository/surah_repository.dart';

import 'package:qalbi/presentations/holy_quran/repository/ayah_detail_entity.dart';
import 'package:qalbi/presentations/holy_quran/data/ayah_surah_detail_model.dart';

import '../../../core/local_storage_service/hive_services.dart';

class RepoImple implements SurahRepository {
  final DioClient dioClient;

  RepoImple({required this.dioClient});

  @override
  Future<List<SurahEntity>> getAllSuran() async {
    // Return cached list immediately.
    final cachedData = HiveService.getAllSurahs();

    if (cachedData != null) {
      _refreshAllSurahs();
      return cachedData
          .map((e) => SurahModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }

    // No cache: fetch from API.
    final response = await dioClient.dio.get(ApiConst.allSurahs);

    if (response.statusCode != 200 || response.data['code'] != 200) {
      throw Exception('Failed to fetch all Surahs');
    }

    final List<dynamic> data = response.data['data'];

    await HiveService.saveAllSurahs(data);

    return data
        .map((e) => SurahModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<void> _refreshAllSurahs() async {
    try {
      final response = await dioClient.dio.get(ApiConst.allSurahs);

      if (response.statusCode == 200 && response.data['code'] == 200) {
        await HiveService.saveAllSurahs(
          List<dynamic>.from(response.data['data']),
        );
      }
    } catch (_) {
      // Keep the existing cache if refresh fails.
    }
  }

  @override
  Future<SurahDetailsEntity> getSurahDetails(int number) async {
    final cachedData = HiveService.getSurah(number);

    if (cachedData != null &&
        (cachedData['ayahs'] as List).isNotEmpty &&
        (cachedData['ayahs'][0] as Map).containsKey('urduTranslation')) {
      _refreshSurah(number);
      return SurahDetailsModel.fromJson(cachedData);
    }

    final data = await _fetchSurah(number);
    return SurahDetailsModel.fromJson(data);
  }

  Future<void> _refreshSurah(int number) async {
    try {
      final data = await _fetchSurah(number);
      await HiveService.saveSurah(number, data);
    } catch (_) {
      // Offline or API error: preserve cached data.
    }
  }

  Future<Map<String, dynamic>> _fetchSurah(int number) async {
    final responses = await Future.wait([
      dioClient.dio.get(ApiConst.surahDetails(number)),
      dioClient.dio.get(ApiConst.surahTranslation(number)),
      dioClient.dio.get(ApiConst.surahUrduTranslation(number)),
    ]);

    final arabicResponse = responses[0].data;
    final translationResponse = responses[1].data;
    final urduTranslation = responses[2].data;
    if (arabicResponse['code'] != 200 ||
        translationResponse['code'] != 200 ||
        urduTranslation["code"] != 200) {
      throw Exception('Failed to fetch Surah or translation');
    }

    final surahJson = _mergeTranslations(
      Map<String, dynamic>.from(arabicResponse['data']),
      Map<String, dynamic>.from(translationResponse['data']),
      Map<String, dynamic>.from(urduTranslation['data']),
    );

    await HiveService.saveSurah(number, surahJson);

    return surahJson;
  }

  @override
  Future<List<JuzEntity>> getAllJuz() async {
    return List.generate(30, (index) => JuzModel.fromNumber(index + 1));
  }

  @override
  Future<JuzDetailsEntity> getJuzDetails(int number) async {
    final cachedData = HiveService.getJuz(number);

    if (cachedData != null &&
        (cachedData['ayahs'] as List).isNotEmpty &&
        (cachedData['ayahs'][0] as Map).containsKey('urduTranslation')) {
      _refreshJuz(number);
      return JuzDetailsModel.fromJson(cachedData);
    }

    final data = await _fetchJuz(number);
    return JuzDetailsModel.fromJson(data);
  }

  Future<void> _refreshJuz(int number) async {
    try {
      final data = await _fetchJuz(number);
      await HiveService.saveJuz(number, data);
    } catch (_) {
      // Keep cached Juz data.
    }
  }

  Future<Map<String, dynamic>> _fetchJuz(int number) async {
    final responses = await Future.wait([
      dioClient.dio.get(ApiConst.jusDetails(number)),
      dioClient.dio.get(ApiConst.juzTranslation(number)),
      dioClient.dio.get(ApiConst.juzUrduTranslation(number)),
    ]);

    final arabicResponse = responses[0].data;
    final translationResponse = responses[1].data;
    final juzUrduTranslations = responses[2].data;

    if (arabicResponse['code'] != 200 ||
        translationResponse['code'] != 200 ||
        juzUrduTranslations["code"] != 200) {
      throw Exception('Failed to fetch Juz or translation');
    }

    final juzJson = _mergeTranslations(
      Map<String, dynamic>.from(arabicResponse['data']),
      Map<String, dynamic>.from(translationResponse['data']),
      Map<String, dynamic>.from(juzUrduTranslations['data']),
    );

    await HiveService.saveJuz(number, juzJson);

    return juzJson;
  }

  Map<String, dynamic> _mergeTranslations(
    Map<String, dynamic> arabicJson,
    Map<String, dynamic> englishJson,
    Map<String, dynamic> urduJson,
  ) {
    final englishTranslations = <int, String>{};
    final urduTranslations = <int, String>{};

    // Extract English translations.
    final englishAyahs = englishJson['ayahs'];

    if (englishAyahs is List) {
      for (final item in englishAyahs) {
        if (item is Map && item['number'] is num) {
          englishTranslations[(item['number'] as num).toInt()] =
              item['text']?.toString() ?? '';
        }
      }
    }

    // Extract Urdu translations.
    final urduAyahs = urduJson['ayahs'];

    if (urduAyahs is List) {
      for (final item in urduAyahs) {
        if (item is Map && item['number'] is num) {
          urduTranslations[(item['number'] as num).toInt()] =
              item['text']?.toString() ?? '';
        }
      }
    }

    final arabicAyahs = arabicJson['ayahs'];

    if (arabicAyahs is! List) {
      throw const FormatException('Invalid Quran response: ayahs list missing');
    }

    return {
      ...arabicJson,
      'ayahs': arabicAyahs.map((item) {
        if (item is! Map) {
          throw const FormatException('Invalid Quran ayah response');
        }

        final number = item['number'];
        final ayahNumber = number is num ? number.toInt() : -1;

        return {
          ...Map<String, dynamic>.from(item),
          'translation': englishTranslations[ayahNumber] ?? '',
          'urduTranslation': urduTranslations[ayahNumber] ?? '',
        };
      }).toList(),
    };
  }
}
