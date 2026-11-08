import 'package:get/get.dart';
import 'package:qalbi/presentations/holy_quran/holly_quran_binding.dart';
import 'package:qalbi/presentations/holy_quran/holy_quran_vew.dart';
import 'package:qalbi/presentations/holy_quran/repository/ayah_detail_entity.dart';
import 'package:qalbi/presentations/holy_quran/repository/get_all_useCases.dart';
import 'package:qalbi/presentations/holy_quran/repository/surah_entity.dart';

import '../export.dart';
import 'data/surah_model.dart';

class HollyQuranController  extends GetxController{
  late GetAllUseCases getAllUseCases;
  HollyQuranController({required this.getAllUseCases});
  final searchController = TextEditingController();

  final RxInt selectedTab = 0.obs;
  final RxBool isSearching = false.obs;
  final RxString searchQuery = ''.obs;
  RxBool allSurachFetching = false.obs;
  RxBool surahFetching = false.obs;
  final RxList<SurahEntity> allSurah = <SurahEntity>[].obs;
 late Rxn<SurahDetailsEntity>   surah = Rxn<SurahDetailsEntity>();

  @override
  void onInit() async{
    // TODO: implement onInit
    super.onInit();
   await  fetchAllSurah();
   }

  Future fetchAllSurah() async {
    allSurachFetching.value = true;

    try{
      allSurah.value =  await getAllUseCases.call();
      allSurachFetching.value = false;
    }
    catch (e){
      Get.snackbar("error message", "the following error are occurred\n${e.toString()}");
    }
    finally{
      allSurachFetching.value = false;

    }
  }

  Future<void> fetchSurah(int number)async {
    Get.to(() => SurahDetailView(number: number),binding: HollyQuranBinding());
    try{
      surahFetching.value = true;
      surah.value = await getAllUseCases.surahRepository.getSurahDetails(number);
    }
    catch (e){
      Get.snackbar("error message", "the following error are occurred\n${e.toString()}");

    }
    finally{
      surahFetching.value = false;
    }
  }

  final List<String> tabs = const [
    'Surah',
    'Juz',
    'Bookmarks',
  ];

  // List<SurahModedel> get filteredSurahs {
  //   final query = searchQuery.value.trim().toLowerCase();
  //
  //   if (query.isEmpty) return surahs.toList();
  //
  //   return surahs.where((surah) {
  //     return surah.name.toLowerCase().contains(query) ||
  //         surah.number.toString() == query;
  //   }).toList();
  // }

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




