
import '../../domain/entity/hijri_calendar_entity.dart';

class HijriCalendarModel extends HijriCalendarEntity {
  const HijriCalendarModel({
    required super.hijriDate,
    required super.hijriDay,
    required super.hijriMonth,
    required super.hijriMonthEnglish,
    required super.hijriMonthArabic,
    required super.hijriYear,
    required super.weekdayEnglish,
    required super.weekdayArabic,
    required super.gregorianDate,
    required super.gregorianDay,
    required super.gregorianMonth,
    required super.gregorianYear,
    required super.holidays,
  });

  factory HijriCalendarModel.fromJson(
      Map<String, dynamic> json,
      ) {
    final hijri = json['hijri'] ?? {};
    final gregorian = json['gregorian'] ?? {};

    final hijriMonth = hijri['month'] ?? {};
    final hijriWeekday = hijri['weekday'] ?? {};
    final gregorianWeekday = gregorian['weekday'] ?? {};

    return HijriCalendarModel(
      hijriDate: hijri['date'] ?? '',
      hijriDay: int.tryParse('${hijri['day']}') ?? 0,
      hijriMonth: hijriMonth['number'] ?? 0,
      hijriMonthEnglish: hijriMonth['en'] ?? '',
      hijriMonthArabic: hijriMonth['ar'] ?? '',
      hijriYear: int.tryParse('${hijri['year']}') ?? 0,

      weekdayEnglish: gregorianWeekday['en'] ?? '',
      weekdayArabic: hijriWeekday['ar'] ?? '',

      gregorianDate: gregorian['date'] ?? '',
      gregorianDay:
      int.tryParse('${gregorian['day']}') ?? 0,
      gregorianMonth: gregorian['month']?['number'] ?? 0,
      gregorianYear:
      int.tryParse('${gregorian['year']}') ?? 0,

      holidays: List<String>.from(
        hijri['holidays'] ?? [],
      ),
    );
  }
}