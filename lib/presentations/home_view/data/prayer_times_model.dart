

import '../domain/entity/prayer_times_entity.dart';

class PrayerTimesModel extends PrayerTimesEntity {
  const PrayerTimesModel({
    required super.date,
    required super.fajr,
    required super.dhuhr,
    required super.asr,
    required super.maghrib,
    required super.isha,
  });

  factory PrayerTimesModel.fromJson(
      Map<String, dynamic> json,
      DateTime date,
      ) {
    final timings = json['timings'];

    return PrayerTimesModel(
      date: date,
      fajr: _cleanTime(timings['Fajr']),
      dhuhr: _cleanTime(timings['Dhuhr']),
      asr: _cleanTime(timings['Asr']),
      maghrib: _cleanTime(timings['Maghrib']),
      isha: _cleanTime(timings['Isha']),
    );
  }

  static String _cleanTime(dynamic value) {
    return value.toString().split(' ').first;
  }
}