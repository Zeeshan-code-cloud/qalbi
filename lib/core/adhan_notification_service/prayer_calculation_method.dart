enum PrayerCalculationMethod {
  muslimWorldLeague,
  karachi,
  egyptian,
  ummAlQura,
  isna,
}

extension PrayerCalculationMethodExtension
on PrayerCalculationMethod {

  String get title {
    switch (this) {
      case PrayerCalculationMethod.muslimWorldLeague:
        return 'Muslim World League';

      case PrayerCalculationMethod.karachi:
        return 'University of Islamic Sciences, Karachi';

      case PrayerCalculationMethod.egyptian:
        return 'Egyptian General Authority';

      case PrayerCalculationMethod.ummAlQura:
        return 'Umm Al-Qura University';

      case PrayerCalculationMethod.isna:
        return 'Islamic Society of North America (ISNA)';
    }
  }

  int get apiValue {
    switch (this) {
      case PrayerCalculationMethod.muslimWorldLeague:
        return 3;

      case PrayerCalculationMethod.karachi:
        return 1;

      case PrayerCalculationMethod.egyptian:
        return 5;

      case PrayerCalculationMethod.ummAlQura:
        return 4;

      case PrayerCalculationMethod.isna:
        return 2;
    }
  }
}