import 'package:qalbi/presentations/holy_quran/repository/surah_entity.dart';

import 'ayah_detail_entity.dart';

abstract class SurahRepository {
  Future<List<SurahEntity>> getAllSuran();
  Future<SurahDetailsEntity> getSurahDetails(int number);

}