import 'package:qalbi/presentations/holy_quran/repository/ayah_detail_entity.dart';
import 'package:qalbi/presentations/holy_quran/repository/juz_details_entity.dart';
import 'package:qalbi/presentations/holy_quran/repository/juz_entity.dart';
import 'package:qalbi/presentations/holy_quran/repository/surah_entity.dart';
import 'package:qalbi/presentations/holy_quran/repository/surah_repository.dart';

class GetAllUseCases {

  late SurahRepository surahRepository;
  GetAllUseCases({required this.surahRepository});


  Future<List<SurahEntity>> call() async {
    return surahRepository.getAllSuran();
  }

  Future<SurahDetailsEntity> getSurah(int number) async{
    return surahRepository.getSurahDetails(number);
  }

  Future<List<JuzEntity>> getAllJus() async {
    return surahRepository.getAllJuz();
  }

  Future<JuzDetailsEntity> getJuzDetails(int number) async {
    return surahRepository.getJuzDetails(number);
  }
}
