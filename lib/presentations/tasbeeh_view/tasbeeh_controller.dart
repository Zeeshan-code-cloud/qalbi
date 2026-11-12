import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qalbi/core/storage_keys/storage_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TasbeehController extends GetxController {
  final count = 0.obs;
  final dailyGoal = 100.obs;
  final selectedTasbeeh = 'سُبْحَانَ اللَّهِ'.obs;
  final tasbeehSearchQuery = ''.obs;
  final tasbeehSearchController = TextEditingController();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchCounterValue();
  }

  void fetchCounterValue() async {
    final prefs = await SharedPreferences.getInstance();

    count.value = prefs.getInt(StorageKeys.tasbeehKey)?? 0;
  }
  final List<String> tasbeehOptions = const [
    'سُبْحَانَ اللَّهِ',
    'الْحَمْدُ لِلَّهِ',
    'اللَّهُ أَكْبَرُ',
    'لَا إِلَٰهَ إِلَّا اللَّهُ',
    'أَسْتَغْفِرُ اللَّهَ',
    'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ',
    'سُبْحَانَ اللَّهِ الْعَظِيمِ',
    'لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ',
    'سُبْحَانَ اللَّهِ وَالْحَمْدُ لِلَّهِ وَلَا إِلَٰهَ إِلَّا اللَّهُ وَاللَّهُ أَكْبَرُ',
    'لَا إِلَٰهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَىٰ كُلِّ شَيْءٍ قَدِيرٌ',
    'اللَّهُمَّ صَلِّ وَسَلِّمْ عَلَىٰ نَبِيِّنَا مُحَمَّدٍ',
    'اللَّهُمَّ اغْفِرْ لِي وَارْحَمْنِي وَاهْدِنِي وَعَافِنِي وَارْزُقْنِي',
    'رَبِّ اغْفِرْ لِي وَتُبْ عَلَيَّ إِنَّكَ أَنْتَ التَّوَّابُ الرَّحِيمُ',
    'اللَّهُمَّ إِنَّكَ عَفُوٌّ تُحِبُّ الْعَفْوَ فَاعْفُ عَنِّي',
    'اللَّهُمَّ أَعِنِّي عَلَىٰ ذِكْرِكَ وَشُكْرِكَ وَحُسْنِ عِبَادَتِكَ',
    'حَسْبِيَ اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ عَلَيْهِ تَوَكَّلْتُ وَهُوَ رَبُّ الْعَرْشِ الْعَظِيمِ',
    'حَسْبُنَا اللَّهُ وَنِعْمَ الْوَكِيلُ',
    'يَا حَيُّ يَا قَيُّومُ بِرَحْمَتِكَ أَسْتَغِيثُ',
    'أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ',
    'بِسْمِ اللَّهِ الَّذِي لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الْأَرْضِ وَلَا فِي السَّمَاءِ وَهُوَ السَّمِيعُ الْعَلِيمُ',
    'رَضِيتُ بِاللَّهِ رَبًّا وَبِالْإِسْلَامِ دِينًا وَبِمُحَمَّدٍ نَبِيًّا',
    'سُبْحَانَكَ اللَّهُمَّ وَبِحَمْدِكَ، أَشْهَدُ أَنْ لَا إِلَٰهَ إِلَّا أَنْتَ، أَسْتَغْفِرُكَ وَأَتُوبُ إِلَيْكَ',
    'اللَّهُمَّ أَنْتَ السَّلَامُ وَمِنْكَ السَّلَامُ تَبَارَكْتَ يَا ذَا الْجَلَالِ وَالْإِكْرَامِ',
    'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ، سُبْحَانَ اللَّهِ الْعَظِيمِ',
    'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
    'لَا إِلَٰهَ إِلَّا أَنْتَ سُبْحَانَكَ إِنِّي كُنْتُ مِنَ الظَّالِمِينَ',
    'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ',
    'اللَّهُمَّ إِنِّي أَسْأَلُكَ الْعَفْوَ وَالْعَافِيَةَ',
    'أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ',
  ];



  List<String> get filteredTasbeehOptions {
    final query = tasbeehSearchQuery.value.trim();
    if (query.isEmpty) return tasbeehOptions;
    return tasbeehOptions.where((phrase) => phrase.contains(query)).toList();
  }

  void selectTasbeeh(String phrase) {
    selectedTasbeeh.value = phrase;
    count.value = 0;
    tasbeehSearchController.clear();
    tasbeehSearchQuery.value = '';
  }

  void increment() async {
    final prefs = await SharedPreferences.getInstance();

    count.value++;
    prefs.setInt(StorageKeys.tasbeehKey, count.value);
  }

  void decrement()  async{
    final prefs = await SharedPreferences.getInstance();
    if (count.value > 0) {
      count.value--;

      prefs.setInt(StorageKeys.tasbeehKey, count.value);
    }
  }

  void reset() {
    count.value = 0;
  }

  double get progress =>
      (count.value / dailyGoal.value).clamp(0.0, 1.0);

  @override
  void onClose() {
    tasbeehSearchController.dispose();
    super.onClose();
  }
}