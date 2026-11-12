import 'package:dio/dio.dart';
import 'package:qalbi/core/network/api_const.dart';
import 'package:qalbi/presentations/duas_view/data/adhkar_model.dart';
import 'package:qalbi/presentations/duas_view/data/dua_model.dart';
import 'package:qalbi/presentations/duas_view/domain/adhkar_entity.dart';
import 'package:qalbi/presentations/duas_view/domain/duas_adhkar_repo.dart';
import 'package:qalbi/presentations/duas_view/domain/duas_entity.dart';

import '../../../core/local_storage_service/hive_services.dart';

class DuaDhikrRepoImple implements DuasAdhkarRepo {
  final Dio duaDio;
  final Dio dhikrDio;

  DuaDhikrRepoImple({
    required this.duaDio,
    required this.dhikrDio,
  });

  @override
  Future<List<DuaEntity>> getDuaList() async {
    // 1. Return cached Duas immediately.
    final cachedData = HiveService.getDuas();

    if (cachedData != null) {
      _refreshDuas();
      return _parseDuas(cachedData);
    }

    // 2. First-time API request.
    final data = await _fetchDuas();
    return _parseDuas(data);
  }

  Future<void> _refreshDuas() async {
    try {
      await _fetchDuas();
    } catch (_) {
      // Keep existing cached Duas.
    }
  }

  Future<List<dynamic>> _fetchDuas() async {
    final result = await duaDio.get(ApiConst.duasList);
    final responseData = result.data;

    final dynamic payload = responseData is Map
        ? responseData['data']
        : responseData;

    final List<dynamic> data;

    if (payload is List) {
      data = payload;
    } else if (payload is Map) {
      final collection =
          payload['duas'] ?? payload['items'] ?? payload['results'];

      if (collection is List) {
        data = collection;
      } else if (payload.containsKey('id')) {
        data = [payload];
      } else {
        throw const FormatException(
          'Unexpected Duas response structure',
        );
      }
    } else {
      throw const FormatException(
        'Unexpected Duas response',
      );
    }

    // Save raw JSON to Hive.
    await HiveService.saveDuas(data);

    return data;
  }

  List<DuaEntity> _parseDuas(List<dynamic> data) {
    return data.map((json) {
      if (json is! Map) {
        throw const FormatException('Invalid Dua item');
      }

      return DuaModel.fromJson(
        Map<String, dynamic>.from(json),
      );
    }).toList();
  }

  @override
  Future<List<AdhkarEntity>> getDhikrList(String slug) async {
    // 1. Return cached collection immediately.
    final cachedData = HiveService.getAdhkar(slug);

    if (cachedData != null) {
      _refreshDhikr(slug);
      return _parseDhikr(cachedData);
    }

    // 2. First-time API request.
    final data = await _fetchDhikr(slug);
    return _parseDhikr(data);
  }

  Future<void> _refreshDhikr(String slug) async {
    try {
      await _fetchDhikr(slug);
    } catch (_) {
      // Keep existing cached collection.
    }
  }

  Future<List<dynamic>> _fetchDhikr(String slug) async {
    final response = await dhikrDio.get(
      ApiConst.dhikrCollection(slug),
    );

    final body = response.data;
    final items = body is Map ? body['items'] : null;

    if (items is! List) {
      throw const FormatException(
        'Invalid adhkar response: expected an items list',
      );
    }

    // Save raw collection in Hive.
    await HiveService.saveAdhkar(slug, items);

    return items;
  }

  List<AdhkarEntity> _parseDhikr(List<dynamic> items) {
    return items.map((item) {
      if (item is! Map) {
        throw const FormatException('Invalid adhkar item');
      }

      return AdhkarModel.fromJson(
        Map<String, dynamic>.from(item),
      );
    }).toList();
  }
}