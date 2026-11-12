 import 'package:qalbi/presentations/holy_quran/repository/ayah_details_entity.dart';

class JuzDetailsEntity {
  final int  juzNumber;
  final List<AyahDetailEntity> ayahList;

  JuzDetailsEntity({

 required this.juzNumber, required this.ayahList});
}