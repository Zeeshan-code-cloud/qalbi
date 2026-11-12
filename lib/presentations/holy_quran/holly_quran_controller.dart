import 'dart:async';
 import 'package:qalbi/core/storage_keys/storage_keys.dart';
import 'package:qalbi/presentations/holy_quran/holy_quran_vew.dart';
import 'package:qalbi/presentations/holy_quran/repository/ayah_detail_entity.dart';
import 'package:qalbi/presentations/holy_quran/repository/get_all_useCases.dart';
import 'package:qalbi/presentations/holy_quran/repository/juz_details_entity.dart';
import 'package:qalbi/presentations/holy_quran/repository/juz_entity.dart';
import 'package:qalbi/presentations/holy_quran/repository/surah_entity.dart';
import 'package:qalbi/presentations/holy_quran/surah_details_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../export.dart';
import 'juz_detail_view.dart';

class HollyQuranController extends GetxController {
  final List<String> tabs = const ['Surah', 'Juz', 'Bookmarks'];

  late GetAllUseCases getAllUseCases;
  HollyQuranController({required this.getAllUseCases});
  final searchController = TextEditingController();

  final RxInt selectedTab = 0.obs;
  final RxBool isSearching = false.obs;
  final RxString searchQuery = ''.obs;
  RxBool allSurahFetching = false.obs;
  RxBool surahFetching = false.obs;
  final RxList<SurahEntity> allSurah = <SurahEntity>[].obs;
  final RxList<SurahEntity> filteredSurah = <SurahEntity>[].obs;
  late Rxn<SurahDetailsEntity> surah = Rxn<SurahDetailsEntity>();
  final RxList<JuzEntity> allJuz = <JuzEntity>[].obs;
  final Rxn<JuzDetailsEntity> juzDetails = Rxn<JuzDetailsEntity>();
  final RxBool juzFetching = false.obs;
  final RxBool juzDetailsFetching = false.obs;
  final RxString selectedTranslation = 'English'.obs;


  Timer? debounce;
  final RxSet<int> bookmarkedNumbers = <int>{}.obs;
   SharedPreferences? _prefs;

  @override
  void onInit()   {
    // TODO: implement onInit
    super.onInit();
      fetchAllSurah();
      _init();
      fetchAllJuz();
    }
  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();
    _loadBookmarks();
    await fetchAllSurah();
  }

  void changeTranslation(String language) {
    selectedTranslation.value = language;
  }


  void _loadBookmarks() {
    // setStringList sirf List<String> store karta hai, isliye int main parse karna paray ga
    final saved = _prefs?.getStringList(StorageKeys.bookMarksSurah) ?? [];
    bookmarkedNumbers.addAll(
      saved.map(int.tryParse).whereType<int>(),
    );
  }
  bool isBookmarked(int number) => bookmarkedNumbers.contains(number);

  Future<void> adToBookmark(int number) async {
    if (!bookmarkedNumbers.remove(number)) {
      bookmarkedNumbers.add(number);
    }

    HapticFeedback.lightImpact();
    await _prefs?.setStringList(
      StorageKeys.bookMarksSurah,
      bookmarkedNumbers.map((e) => e.toString()).toList(),
    );
  }

  Future<void> removeFromBookmark(int number) async {
    if(bookmarkedNumbers.contains(number)){
      bookmarkedNumbers.remove(number);
    }
    HapticFeedback.lightImpact();
    await _prefs?.setStringList(StorageKeys.bookMarksSurah, bookmarkedNumbers.map((e) => e.toString()).toList());
  }
  List<SurahEntity> get bookmarkedSurahs =>
      allSurah.where((s) => bookmarkedNumbers.contains(s.number)).toList();

  void onSearchChanged(String query) {
    searchQuery.value = query;
    final q = query.trim().toLowerCase();

    if (q.isEmpty) {
      filteredSurah.assignAll(allSurah);
      return;
    }

    filteredSurah.assignAll(
      allSurah.where((e) =>
      e.englishNameTranslation.toLowerCase().contains(q) ||
          e.name.toLowerCase().contains(q) ||
          e.number.toString() == q),
    );
  }
  void filtered(String query) {
    final q = query.trim().toString();
    if (q.isEmpty) {
      filteredSurah.assignAll(allSurah);
    } else {
      filteredSurah.assignAll(
        allSurah.where(
          (e) =>
              e.englishNameTranslation.toLowerCase().contains(q)
        ),
      );
    }
  }

  void clearSearch() {
    searchController.clear();
    onSearchChanged('');
  }

  Future<void> fetchAllSurah() async {
    allSurahFetching.value = true;
    try {
      final result = await getAllUseCases.call();
      allSurah.assignAll(result);       // .value nahi
      filteredSurah.assignAll(result);
    } catch (e) {
      Get.snackbar("Error", "The following error occurred\n${e.toString()}");
    } finally {
      allSurahFetching.value = false;
    }
  }
  Future<void> fetchSurah(int number) async {
    Get.to(() => SurahDetailView(number: number), );
    try {
      surahFetching.value = true;
      surah.value = await getAllUseCases.surahRepository.getSurahDetails(
        number,
      );
    } catch (e) {
      Get.snackbar(
        "error message",
        "the following error are occurred\n${e.toString()}",
      );
    } finally {
      surahFetching.value = false;
    }
  }


  void fetchAllJuz() async {
    juzFetching.value = true;
    try{
    final result =  await  getAllUseCases.getAllJus();
    allJuz.assignAll(result);

    }
    catch (e){
      Get.snackbar("Error", "The following error occurred\n${e.toString()}");

    }
    finally{
      juzFetching.value = false;
    }

  }


  void fetchJuzDetails(int  number) async {
    Get.to(() => JuzDetailView(number: number));
    juzDetailsFetching.value = true;
    try{
      final result = await getAllUseCases.getJuzDetails(number);
      juzDetails.value = result;
    }
    catch (e){
      Get.snackbar("Error", "The following error occurred\n${e.toString()}");

      print(e.toString());
    }
    finally{
      juzDetailsFetching.value = false;
    }

  }

  void selectTab(int index) {
    selectedTab.value = index;
  }





   @override
  void onClose() {
    searchController.dispose();

  }
}
