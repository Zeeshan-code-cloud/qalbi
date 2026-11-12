
import '../entity/prayer_times_entity.dart';

abstract class PrayerTimesRepository {
  Future<PrayerTimesEntity> getPrayerTimes({
    required double latitude,
    required double longitude,
    required DateTime date,
    required int method,
    required int school,
  });
}