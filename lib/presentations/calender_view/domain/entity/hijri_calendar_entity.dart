class HijriCalendarEntity {
  final String hijriDate;
  final int hijriDay;
  final int hijriMonth;
  final String hijriMonthEnglish;
  final String hijriMonthArabic;
  final int hijriYear;

  final String weekdayEnglish;
  final String weekdayArabic;

  final String gregorianDate;
  final int gregorianDay;
  final int gregorianMonth;
  final int gregorianYear;

  final List<String> holidays;

  const HijriCalendarEntity({
    required this.hijriDate,
    required this.hijriDay,
    required this.hijriMonth,
    required this.hijriMonthEnglish,
    required this.hijriMonthArabic,
    required this.hijriYear,
    required this.weekdayEnglish,
    required this.weekdayArabic,
    required this.gregorianDate,
    required this.gregorianDay,
    required this.gregorianMonth,
    required this.gregorianYear,
    required this.holidays,
  });
}