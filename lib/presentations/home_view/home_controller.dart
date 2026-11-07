import 'dart:async';

import 'package:qalbi/enums/enum.dart';

import '../export.dart';

class HomeController extends GetxController {

  final pageController = PageController();
  final RxInt currentIndex = 0.obs;

  Timer? _timer;

  RxString welcomeMessage = "Good Morning".obs;

  @override
  void onInit() {
    super.onInit();
    startAutoScroll();
    updateGreetings();
  }

  void startAutoScroll() {
    _timer?.cancel();

    _timer = Timer.periodic(
      const Duration(seconds: 3),
          (timer) {
        if (!pageController.hasClients || quotes.isEmpty) return;

        final nextIndex =
            (currentIndex.value + 1) % quotes.length;

        pageController.animateToPage(
          nextIndex,
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeInOut,
        );
      },
    );
  }
  List<PrayerModel> prayers = [
    PrayerModel(prayerName: "Fajr", time: "5:50"),
    PrayerModel(prayerName: "Dhuhr", time: "4:15"),
    PrayerModel(prayerName: "Asr", time: "6:50"),
    PrayerModel(prayerName: "Maghrib", time: "7:50"),
    PrayerModel(prayerName: "Isha", time: "9:50"),
  ];

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
      iconPath: AppAssets.qibla,
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
      iconPath: AppAssets.tasbeehImage,
      route: Routes.tasbeehView,
    ),

    HomeFeatureModel(
      title: 'Islamic Calender',
      subtitle: 'Hijri dates & events',
      iconPath: AppAssets.calenderImage,
      route: Routes.calenderView,
    ),
    HomeFeatureModel(
      title: 'Search',
      subtitle: 'Find Quran, Duas',
      iconPath: AppAssets.searchIcon,
      route: Routes.zakatView,
    ),  HomeFeatureModel(
      title: 'Dark Mode',
      subtitle: 'Easy On Eye',
      iconPath: AppAssets.darkMode,
      route: Routes.qiblaView,
    ),
    HomeFeatureModel(
      title: 'Multiple Language',
      subtitle: 'Arabic,English & More',
      iconPath: AppAssets.language,
      route: Routes.settingView,
    ),
    HomeFeatureModel(
      title: 'Offline Access',
      subtitle: 'Use Without Internet',
      iconPath: AppAssets.offlineAccess,
      route: Routes.zakatView,
    ),
  ];
  final List<IslamicQuoteModel> quotes = const [

    IslamicQuoteModel(
      quote: 'Live a Blessed Islamic Life',
      reference: 'Remember Allah in everything',
    ),

    IslamicQuoteModel(
      quote: 'Indeed, with hardship comes ease',
      reference: 'Surah Ash-Sharh 94:6',
    ),

    IslamicQuoteModel(
      quote: 'And Allah is with those who are patient',
      reference: 'Surah Al-Baqarah 2:153',
    ),

    IslamicQuoteModel(
      quote: 'So remember Me; I will remember you',
      reference: 'Surah Al-Baqarah 2:152',
    ),

    IslamicQuoteModel(
      quote: 'Never lose hope in the mercy of Allah',
      reference: 'Surah Az-Zumar 39:53',
    ),

    IslamicQuoteModel(
      quote: 'Put your trust in Allah',
      reference: 'Surah At-Talaq 65:3',
    ),

    IslamicQuoteModel(
      quote: 'A good word is charity',
      reference: 'Sahih al-Bukhari 2989',
    ),
  ];

  void onFeatureTap(HomeFeatureModel feature) {
    Get.toNamed(feature.route,arguments: NavType.fromHomeTile);
  }

  void onPageChanged(int index) {
    currentIndex.value = index;
  }

  void updateGreetings() {
    final hours = DateTime.now().hour;
    if (hours >= 0 && hours < 12) {
      welcomeMessage.value = "Good Morning";
    } else if (hours >= 12 && hours < 17) {
      welcomeMessage.value = "Good Afternoon";
    } else if (hours < 21) {
      welcomeMessage.value = "Good Evening";
    } else {
      welcomeMessage.value = "Good Night";
    }
  }


  @override
  void onClose() {
    _timer?.cancel();
    pageController.dispose();
    super.onClose();
  }

}

class PrayerModel {
  final String prayerName;
  final String time;
  PrayerModel({required this.prayerName, required this.time});
}

class HomeFeatureModel {
  final String title;
  final String subtitle;
  final String iconPath;
  final String route;

  const HomeFeatureModel({
    required this.title,
    required this.subtitle,
    required this.iconPath,
    required this.route,
  });
}

class IslamicQuoteModel {
  final String quote;
  final String reference;

  const IslamicQuoteModel({
    required this.quote,
    required this.reference,
  });
}
