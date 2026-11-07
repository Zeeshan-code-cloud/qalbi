import 'package:get/get.dart';

import '../export.dart';

class DuasController  extends GetxController{
  final searchController = TextEditingController();

  final selectedTab = 'All'.obs;
  final selectedCategory = 'Morning'.obs;
  final searchQuery = ''.obs;

  final duas = <DuaModel>[
    const DuaModel(
      title: 'Protection from Evil',
      arabic: 'أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ',
      translation: 'I seek refuge in the perfect words of Allah.',
      reference: 'Sahih Muslim',
      category: 'Morning',
      iconKey: 'protection',
    ),
    const DuaModel(
      title: 'For Guidance',
      arabic: 'رَبَّنَا لَا تُزِغْ قُلُوبَنَا',
      translation: 'Our Lord, do not let our hearts deviate.',
      reference: 'Quran 3:8',
      category: 'Daily',
      iconKey: 'guidance',
    ),
    const DuaModel(
      title: 'Increase in Knowledge',
      arabic: 'رَبِّ زِدْنِي عِلْمًا',
      translation: 'My Lord, increase me in knowledge.',
      reference: 'Quran 20:114',
      category: 'Daily',
      iconKey: 'knowledge',
    ),
    const DuaModel(
      title: 'Forgiveness',
      arabic: 'أَسْتَغْفِرُ اللَّهَ',
      translation: 'I seek forgiveness from Allah.',
      reference: 'Dhikr',
      category: 'Daily',
      iconKey: 'forgiveness',
    ),
    const DuaModel(
      title: 'For Provision',
      arabic: 'اللَّهُمَّ إِنِّي أَسْأَلُكَ رِزْقًا طَيِّبًا',
      translation: 'O Allah, I ask You for good provision.',
      reference: 'Authentic supplication',
      category: 'Morning',
      iconKey: 'provision',
    ),
    const DuaModel(
      title: 'Before Sleeping',
      arabic: 'بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا',
      translation: 'In Your name, O Allah, I die and I live.',
      reference: 'Sahih al-Bukhari',
      category: 'Sleep',
      iconKey: 'sleep',
    ),
  ].obs;

  final favoriteTitles = <String>{}.obs;

  final tabs = ['All', 'duas', 'Adhkar', 'Favorites'];
  final categories = ['Morning', 'Evening', 'Sleep', 'Daily'];

  @override
  void onInit() {
    super.onInit();

    searchController.addListener(() {
      searchQuery.value = searchController.text.trim();
    });
  }

  List<DuaModel> get filteredDuas {
    final query = searchQuery.value.toLowerCase();

    return duas.where((dua) {
      final matchesSearch = query.isEmpty ||
          dua.title.toLowerCase().contains(query) ||
          dua.translation.toLowerCase().contains(query) ||
          dua.arabic.contains(query);

      final matchesTab = switch (selectedTab.value) {
        'Favorites' => favoriteTitles.contains(dua.title),
        'Adhkar' => dua.category != 'Daily',
        _ => true,
      };

      final matchesCategory =
          selectedTab.value == 'Favorites' ||
              selectedTab.value == 'Adhkar' ||
              selectedTab.value == 'Duas' ||
              dua.category == selectedCategory.value;

      return matchesSearch && matchesTab && matchesCategory;
    }).toList();
  }

  void selectTab(String tab) {
    selectedTab.value = tab;
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
  }

  void toggleFavorite(DuaModel dua) {
    if (!favoriteTitles.add(dua.title)) {
      favoriteTitles.remove(dua.title);
    }
  }

  bool isFavorite(DuaModel dua) =>
      favoriteTitles.contains(dua.title);

  void openDua(DuaModel dua) {
    Get.toNamed('/dua-details', arguments: dua);
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}


class DuaModel {
  final String title;
  final String arabic;
  final String translation;
  final String reference;
  final String category;
  final String iconKey;
  final bool isFavorite;

  const DuaModel({
    required this.title,
    required this.arabic,
    required this.translation,
    required this.reference,
    required this.category,
    required this.iconKey,
    this.isFavorite = false,
  });
}