import 'package:dio/dio.dart';
import 'package:qalbi/core/network/api_const.dart';
import 'package:qalbi/presentations/home_view/data/prayer_times_model.dart';

import '../domain/entity/prayer_times_entity.dart';
import '../domain/repository/prayer_times_repository.dart';


class PrayerTimesRepositoryImpl
    implements PrayerTimesRepository {

  final Dio dio;

  PrayerTimesRepositoryImpl({required this.dio});

  @override
  Future<PrayerTimesEntity> getPrayerTimes({
    required double latitude,
    required double longitude,
    required DateTime date,
    required int method,
    required int school,
  }) async {
    final formattedDate =
        '${date.day.toString().padLeft(2, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.year}';

    final response = await dio.get(
      ApiConst.prayerTimings(formattedDate),
      queryParameters: {
        'latitude': latitude,
        'longitude': longitude,
        'method': method,
        'school': school,
      },
    );

    if (response.data['code'] != 200) {
      throw Exception('Unable to fetch prayer times');
    }

    return PrayerTimesModel.fromJson(
      response.data['data'],
      date,
    );
  }
}