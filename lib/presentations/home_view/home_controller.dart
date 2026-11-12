import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:qalbi/core/theme/theme_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/adhan_notification_service/adhan_notification_service.dart';
import '../../core/adhan_notification_service/prayer_calculation_method.dart';
import '../../core/localizations/app_localizations/app_languages.dart';
import '../../core/localizations/app_localizations/language_controller.dart';
import '../export.dart';
import 'domain/entity/prayer_times_entity.dart';
import 'domain/use_case/get_prayer_times_usecase.dart';

class HomeController extends GetxController {
  HomeController({
    required this.getPrayerTimesUseCase,
    required this.notificationService,
  });

  final GetPrayerTimesUseCase getPrayerTimesUseCase;
  final AdhanNotificationService notificationService;

  final themeC = Get.find<ThemeController>();
  final languageC = Get.find<LanguageController>();
  final Rxn<PrayerTimesEntity> todayPrayerTimes = Rxn<PrayerTimesEntity>();
  final RxMap<DateTime, Map<String, String>> weeklySchedules =
      <DateTime, Map<String, String>>{}.obs;
  final RxBool isLoading = true.obs;
  final RxBool notificationsEnabled = false.obs;
  final RxDouble latitude = 0.0.obs;
  final RxDouble longitude = 0.0.obs;
  final Rx<PrayerCalculationMethod> selectedMethod =
      PrayerCalculationMethod.karachi.obs;
  final RxBool isHanafi = true.obs;
  final Rx<DateTime> clockTick = DateTime.now().obs;

  final RxMap<String, bool> prayerNotifications = {
    'Fajr': true,
    'Dhuhr': true,
    'Asr': true,
    'Maghrib': true,
    'Isha': true,
  }.obs;

  final PageController pageController = PageController();
  final List<HomeFeatureModel> features = [
    HomeFeatureModel(
      title: 'Holy Quran',
      subtitle: 'Read & Listen & Translate',
      iconPath: AppAssets.quranImage,
      route: Routes.holyQuranView,
    ),
    HomeFeatureModel(
      title: 'Qibla Compass',
      subtitle: 'Find qibla direction',
      iconPath: AppAssets.kiblaImage,
      route: Routes.qiblaView,
    ),
    HomeFeatureModel(
      title: 'Duas & Adhkar',
      subtitle: 'Daily supplications',
      iconPath: AppAssets.duasImage,
      route: Routes.duasView,
    ),
    HomeFeatureModel(
      title: 'Digital Tasbeeh',
      subtitle: 'Count Down Dhikr',
      iconPath: "assets/images/img_9.png",
      route: Routes.tasbeehView,
    ),
    HomeFeatureModel(
      title: 'Islamic Calender',
      subtitle: 'Hijri dates & events',
      iconPath: "assets/images/img_14.png",
      route: Routes.calenderView,
    ),

    HomeFeatureModel(
      title: 'Search Now',
      subtitle: 'Search Suran and Juz',
      iconPath: AppAssets.searchIcon,
      route: Routes.holyQuranView,
    ),HomeFeatureModel(
      title: 'Dark Mode',
      subtitle: 'Easy on Eye',
      iconPath:  AppAssets.darkMode,
      route: Routes.settingView,
    ),HomeFeatureModel(
      title: 'Multiple Language',
      subtitle: 'Select Language',
      iconPath: AppAssets.language,
      route: Routes.settingView,
    ),
    HomeFeatureModel(
      title: 'Offline Access',
      subtitle: 'Use Without Internet',
      iconPath: AppAssets.offlineAccess,
      route: Routes.offlineAcess,
    ),
  ];

  final List<HomeQuote> quotes = const [
    HomeQuote('Indeed, with hardship comes ease.', 'Qur’an 94:6'),
    HomeQuote('Allah does not burden a soul beyond what it can bear.', 'Qur’an 2:286'),
    HomeQuote('Remember Me; I will remember you.', 'Qur’an 2:152'),
    HomeQuote('Call upon Me; I will answer you.', 'Qur’an 40:60'),
    HomeQuote('Allah is with those who are patient.', 'Qur’an 2:153'),
    HomeQuote('When you decide, put your trust in Allah.', 'Qur’an 3:159'),
    HomeQuote('Allah loves those who rely upon Him.', 'Qur’an 3:159'),
    HomeQuote('Whoever is mindful of Allah, He will make a way out for them.', 'Qur’an 65:2'),
    HomeQuote('Allah is sufficient for whoever puts their trust in Him.', 'Qur’an 65:3'),
    HomeQuote('Surely in the remembrance of Allah do hearts find comfort.', 'Qur’an 13:28'),
    HomeQuote('Do not despair of the mercy of Allah.', 'Qur’an 39:53'),
    HomeQuote('Allah loves those who constantly repent.', 'Qur’an 2:222'),
    HomeQuote('Race toward forgiveness from your Lord.', 'Qur’an 3:133'),
    HomeQuote('A good word is like a good tree.', 'Qur’an 14:24'),
    HomeQuote('Whoever does an atom’s weight of good will see it.', 'Qur’an 99:7'),
    HomeQuote('The most beloved deeds to Allah are those done regularly, even if small.', 'Sahih al-Bukhari 6464'),
    HomeQuote('Actions are judged by intentions.', 'Sahih al-Bukhari 1; Sahih Muslim 1907'),
    HomeQuote('Your smile for your brother is charity.', 'Jami at-Tirmidhi 1956'),
    HomeQuote('Kindness adorns whatever it is part of.', 'Sahih Muslim 2594'),
    HomeQuote('The strong believer is better and more beloved to Allah.', 'Sahih Muslim 2664'),
    HomeQuote('Speak good or remain silent.', 'Sahih al-Bukhari 6018; Sahih Muslim 47'),
    HomeQuote('Allah looks at your hearts and your deeds.', 'Sahih Muslim 2564'),
    HomeQuote('Whoever follows a path seeking knowledge, Allah eases a path to Paradise for them.', 'Sahih Muslim 2699'),
    HomeQuote('The merciful are shown mercy by the Most Merciful.', 'Jami at-Tirmidhi 1924'),
    HomeQuote('Tie your camel, then put your trust in Allah.', 'Jami at-Tirmidhi 2517'),
    HomeQuote('Supplication is worship.', 'Sunan Abi Dawud 1479'),
    HomeQuote('The best of you are those who learn the Qur’an and teach it.', 'Sahih al-Bukhari 5027'),
    HomeQuote('Make things easy and do not make them difficult.', 'Sahih al-Bukhari 69; Sahih Muslim 1734'),
    HomeQuote('When you ask, ask Allah.', 'Jami at-Tirmidhi 2516'),
    HomeQuote('If you are grateful, I will surely increase you.', 'Qur’an 14:7'),
  ];

  SharedPreferences? _prefs;
  Timer? _clockTimer;
  Timer? _quoteTimer;
  int _currentQuoteIndex = 0;

  String get welcomeMessage {
    final hour = clockTick.value.hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    if (hour < 20) return 'Good Evening';
    return 'Good Night';
  }

  List<PrayerTimeDisplay> get prayers {
    final times = todayPrayerTimes.value?.prayers ?? const <String, String>{};
    return const ['Fjr', 'Duhr', 'Asr', 'Mgrb', 'Isha']
        .map((name) => PrayerTimeDisplay(
              name,
              times[name] == null ? '--:--' : _formatTime(times[name]!),
            ))
        .toList(growable: false);
  }

  _NextPrayer? get _nextPrayer {
    // Read clockTick so the view refreshes every second.
    final now = clockTick.value;
    for (var dayOffset = 0; dayOffset < 8; dayOffset++) {
      final date = DateTime(now.year, now.month, now.day + dayOffset);
      final schedule = weeklySchedules[date];
      if (schedule == null) continue;
      for (final name in const ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha']) {
        final value = schedule[name];
        if (value == null) continue;
        final parts = value.split(':');
        if (parts.length < 2) continue;
        final hour = int.tryParse(parts[0]);
        final minute = int.tryParse(parts[1]);
        if (hour == null || minute == null) continue;
        final at = DateTime(date.year, date.month, date.day, hour, minute);
        if (at.isAfter(now)) return _NextPrayer(name, value, at);
      }
    }
    return null;
  }

  String get nextPrayerName => _nextPrayer?.name ?? 'Fajr';
  String get nextPrayerTime => _nextPrayer == null ? '--:--' : _formatTime(_nextPrayer!.time);
  String get countdownText {
    final duration = _nextPrayer?.at.difference(clockTick.value);
    if (duration == null || duration.isNegative) return '--:--:--';
    String two(int value) => value.toString().padLeft(2, '0');
    return '${two(duration.inHours)}:${two(duration.inMinutes.remainder(60))}:${two(duration.inSeconds.remainder(60))}';
  }

  @override
  void onInit() {
    super.onInit();
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      clockTick.value = DateTime.now();
    });
    _quoteTimer = Timer.periodic(const Duration(seconds: 6), (_) {
      if (!pageController.hasClients || quotes.isEmpty) return;
      _currentQuoteIndex = (_currentQuoteIndex + 1) % quotes.length;
      pageController.animateToPage(
        _currentQuoteIndex,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
    initializeAdhan();
  }

  Future<void> initializeAdhan() async {
    _prefs = await SharedPreferences.getInstance();
    final methodIndex = _prefs?.getInt('adhan_method') ?? PrayerCalculationMethod.karachi.index;
    selectedMethod.value = PrayerCalculationMethod.values[
      methodIndex.clamp(0, PrayerCalculationMethod.values.length - 1).toInt()
    ];
    isHanafi.value = _prefs?.getBool('adhan_hanafi') ?? true;
    notificationsEnabled.value = _prefs?.getBool('adhan_enabled') ?? false;
    for (final prayer in prayerNotifications.keys.toList()) {
      prayerNotifications[prayer] = _prefs?.getBool('adhan_$prayer') ?? true;
    }
    await fetchPrayerTimes();
  }

  Future<Position> _getCurrentLocation() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw Exception('Please enable GPS location.');
    }
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw Exception('Location permission is required.');
    }
    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 20),
      ),
    );
  }


    changeTheme(String themeMode) {
    if(themeMode == "Dark Theme"){
      themeC.isDark.value = true;
    }
    themeC.isDark.value = false;
  }

  Future<void> selectLanguage(String language) async {
    switch (language) {
      case 'English':
        await languageC.changeLang(AppLanguages.english);
        break;
      case 'Urdu':
        await languageC.changeLang(AppLanguages.urdu);
        break;
      case 'Arabic':
        await languageC.changeLang(AppLanguages.arabic);
        break;
      default:
        return;
    }
  }
  Future<void> fetchPrayerTimes() async {
    isLoading.value = true;
    try {
      final position = await _getCurrentLocation();
      latitude.value = position.latitude;
      longitude.value = position.longitude;
      final now = DateTime.now();
      final dates = List.generate(
        8,
        (index) => DateTime(now.year, now.month, now.day + index),
      );
      final results = await Future.wait(
        dates.map((date) => getPrayerTimesUseCase(
          latitude: position.latitude,
          longitude: position.longitude,
          date: date,
          method: selectedMethod.value.apiValue,
          school: isHanafi.value ? 1 : 0,
        )),
      );
      final schedules = <DateTime, Map<String, String>>{};
      for (final result in results) {
        schedules[DateTime(result.date.year, result.date.month, result.date.day)] =
            result.prayers;
      }
      weeklySchedules.assignAll(schedules);
      todayPrayerTimes.value = results.first;
      if (notificationsEnabled.value) await _scheduleNotifications();
    } catch (error) {
      Get.snackbar('Prayer Times Error', error.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _scheduleNotifications() => notificationService.schedulePrayerNotifications(
    schedules: Map<DateTime, Map<String, String>>.from(weeklySchedules),
    enabledPrayers: Map<String, bool>.from(prayerNotifications),
  );

  Future<void> changeCalculationMethod(PrayerCalculationMethod method) async {
    selectedMethod.value = method;
    await _prefs?.setInt('adhan_method', method.index);
    await fetchPrayerTimes();
  }

  Future<void> changeAsrSchool(bool hanafi) async {
    isHanafi.value = hanafi;
    await _prefs?.setBool('adhan_hanafi', hanafi);
    await fetchPrayerTimes();
  }

  Future<void> togglePrayerNotification(String prayer, bool enabled) async {
    prayerNotifications[prayer] = enabled;
    await _prefs?.setBool('adhan_$prayer', enabled);
    if (notificationsEnabled.value) await _scheduleNotifications();
  }

  Future<void> enableAdhanNotifications(bool enabled) async {
    if (!enabled) {
      notificationsEnabled.value = false;
      await _prefs?.setBool('adhan_enabled', false);
      await notificationService.cancelAllPrayerNotifications();
      return;
    }
    final permissionGranted = await notificationService.requestPermissions();
    if (!permissionGranted) {
      Get.snackbar('Permission Required', 'Please allow notifications in device settings.');
      return;
    }
    await notificationService.requestExactAlarmPermission();
    notificationsEnabled.value = true;
    await _prefs?.setBool('adhan_enabled', true);
    if (weeklySchedules.isEmpty) {
      await fetchPrayerTimes();
    } else {
      await _scheduleNotifications();
    }
  }

  String _formatTime(String value) {
    final parts = value.split(':');
    if (parts.length < 2) return value;
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return value;
    final suffix = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour % 12 == 0 ? 12 : hour % 12;
    return '$displayHour:${minute.toString().padLeft(2, '0')} $suffix';
  }

  void onPageChanged(int index) {
    _currentQuoteIndex = index;
  }

  @override
  void onClose() {
    _clockTimer?.cancel();
    _quoteTimer?.cancel();
    pageController.dispose();
    super.onClose();
  }
}

class HomeFeatureModel {
  const HomeFeatureModel({
    required this.title,
    required this.subtitle,
    required this.iconPath,
    required this.route,
  });

  final String title;
  final String subtitle;
  final String iconPath;
  final String route;
}

class HomeQuote {
  const HomeQuote(this.quote, this.reference);
  final String quote;
  final String reference;
}

class PrayerTimeDisplay {
  const PrayerTimeDisplay(this.prayerName, this.time);
  final String prayerName;
  final String time;
}

class _NextPrayer {
  const _NextPrayer(this.name, this.time, this.at);
  final String name;
  final String time;
  final DateTime at;
}
