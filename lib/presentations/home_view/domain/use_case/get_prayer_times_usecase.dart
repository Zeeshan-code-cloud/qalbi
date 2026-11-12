import '../entity/prayer_times_entity.dart';
import '../repository/prayer_times_repository.dart';

class GetPrayerTimesUseCase {
  final PrayerTimesRepository repository;

  GetPrayerTimesUseCase({
    required this.repository,
  });

  Future<PrayerTimesEntity> call({
    required double latitude,
    required double longitude,
    required DateTime date,
    required int method,
    required int school,
  }) {
    return repository.getPrayerTimes(
      latitude: latitude,
      longitude: longitude,
      date: date,
      method: method,
      school: school,
    );
  }
}