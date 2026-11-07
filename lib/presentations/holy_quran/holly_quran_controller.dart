import 'package:get/get.dart';

import '../export.dart';

class HollyQuranController  extends GetxController{
  final searchController = TextEditingController();

  final RxInt selectedTab = 0.obs;
  final RxBool isSearching = false.obs;
  final RxString searchQuery = ''.obs;

  final RxList<SurahModel> surahs = <SurahModel>[
    const SurahModel(
      number: 1,
      name: 'Al-Fatiha',
      arabicName: 'الْفَاتِحَة',
      verses: 7,
      revelationType: 'Meccan',
    ),
    const SurahModel(
      number: 2,
      name: 'Al-Baqarah',
      arabicName: 'الْبَقَرَة',
      verses: 286,
      revelationType: 'Medinan',
    ),
    const SurahModel(
      number: 3,
      name: 'Al-Imran',
      arabicName: 'آلِ عِمْرَان',
      verses: 200,
      revelationType: 'Medinan',
    ),
    const SurahModel(
      number: 4,
      name: 'An-Nisa',
      arabicName: 'النِّسَاء',
      verses: 176,
      revelationType: 'Medinan',
    ),
    const SurahModel(
      number: 5,
      name: "Al-Ma'idah",
      arabicName: 'الْمَائِدَة',
      verses: 120,
      revelationType: 'Medinan',
    ),
  ].obs;

  final List<String> tabs = const [
    'Surah',
    'Juz',
    'Bookmarks',
  ];

  List<SurahModel> get filteredSurahs {
    final query = searchQuery.value.trim().toLowerCase();

    if (query.isEmpty) return surahs.toList();

    return surahs.where((surah) {
      return surah.name.toLowerCase().contains(query) ||
          surah.number.toString() == query;
    }).toList();
  }

  void selectTab(int index) {
    selectedTab.value = index;
  }

  void toggleSearch() {
    isSearching.toggle();

    if (!isSearching.value) {
      searchController.clear();
      searchQuery.value = '';
    }
  }

  void searchSurahs(String value) {
    searchQuery.value = value;
  }

  void openSurah(SurahModel surah) {
    // Navigate to the Surah reader when implemented.
    // Example: Get.toNamed('/quran/reader',
    //     arguments: surah.number);
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}


class SurahModel {
  final int number;
  final String name;
  final String arabicName;
  final int verses;
  final String revelationType;

  const SurahModel({
    required this.number,
    required this.name,
    required this.arabicName,
    required this.verses,
    required this.revelationType,
  });
}

