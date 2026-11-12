
import 'package:qalbi/presentations/duas_view/domain/adhkar_entity.dart';
import 'package:qalbi/presentations/duas_view/domain/duas_entity.dart';

import '../export.dart';
import 'domain/dua_adhkar_use_case.dart';

class DuasController  extends GetxController{
  final DuaAdhkarUseCase duaAdhkarUseCase;

  DuasController({
    required this.duaAdhkarUseCase
});
  final searchController = TextEditingController();

  final selectedTab = 'All'.obs;
  final selectedCategory = 'Morning'.obs;
  final searchQuery = ''.obs;


  final favoriteTitles = <String>{}.obs;



  final tabs = ['All', 'duas', 'Adhkar', 'Favorites'];
  final categories = ['Morning', 'Evening', 'Sleep',];

  RxList<DuaEntity> allDua = <DuaEntity>[].obs;
  RxList<AdhkarEntity> allDhikr = <AdhkarEntity>[].obs;
  RxBool duaFetching = false.obs;
  RxBool dhikrFetching = false.obs;

  @override
  void onInit() {
    super.onInit();

    searchController.addListener(() {
      searchQuery.value = searchController.text.trim();
    });
    fetchDua();
    fetchDhikr('morning-evening');
  }





  void changeCategory() {
    if (categories.isEmpty) return;

    final currentIndex = categories.indexOf(selectedCategory.value);
    final nextIndex = (currentIndex + 1) % categories.length;
    selectedCategory.value = categories[nextIndex];
    selectedTab.value = 'duas';
  }
  Future<void> fetchDua() async {
    duaFetching.value = true;
    try{
     final result =  await duaAdhkarUseCase.getDuaUseCase();
     allDua.assignAll(result);
     }
    catch (e){
      Get.snackbar("error occurred", e.toString());
    }
    finally{
      duaFetching.value =false;
    }
  }

  Future<void> fetchDhikr(String slug) async {
    dhikrFetching.value = true;
    try {
      final result = await duaAdhkarUseCase.getAdhkarUseCase(slug);
      allDhikr.assignAll(result);
    } catch (e) {
      Get.snackbar('Could not load Adhkar', e.toString());
      print(e.toString());
    } finally {
      dhikrFetching.value = false;
    }
  }

  List<AdhkarEntity> get filteredDhikr {
    final query = searchQuery.value.toLowerCase().trim();
    if (query.isEmpty) return allDhikr.toList();

    return allDhikr.where((dhikr) =>
      dhikr.arabic.toLowerCase().contains(query) ||
      dhikr.translation.toLowerCase().contains(query) ||
      dhikr.reference.toLowerCase().contains(query)
    ).toList();
  }

  List<DuaEntity> get filteredDuas {
    final query = searchQuery.value.toLowerCase().trim();

    return allDua.where((dua) {
      final matchesSearch = query.isEmpty ||
          dua.title.toLowerCase().contains(query) ||
          dua.translation.toLowerCase().contains(query) ||
          dua.arabic.contains(query);

      final matchesTab = switch (selectedTab.value.toLowerCase()) {
        'favorites' => favoriteTitles.contains(dua.title),
        'adhkar' => false,
        _ => true,
      };

      final matchesCategory = dua.category.toLowerCase() ==
          selectedCategory.value.toLowerCase();

      return matchesSearch && matchesTab && matchesCategory;
    }).toList();
  }

  void selectTab(String tab) {
    selectedTab.value = tab;
    if (tab.toLowerCase() == 'adhkar' && allDhikr.isEmpty && !dhikrFetching.value) {
      fetchDhikr('morning-evening');
    }
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
    selectedTab.value = 'duas';
  }

  void toggleFavorite(DuaEntity dua) {
    if (!favoriteTitles.add(dua.title)) {
      favoriteTitles.remove(dua.title);
    }
  }

  bool isFavorite(DuaEntity dua) =>
      favoriteTitles.contains(dua.title);

  void openDua(DuaEntity dua) {
    Get.toNamed('/dua-details', arguments: dua);
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}


