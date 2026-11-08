import 'package:qalbi/presentations/holy_quran/repository/ayah_detail_entity.dart';
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
}
