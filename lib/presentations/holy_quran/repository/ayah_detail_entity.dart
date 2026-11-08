import 'ayah_entity.dart';

class SurahDetailsEntity {
  final int number;
  final String name;
  final String englishName;
  final List<AyahEntity> ayahs;

  const SurahDetailsEntity({
    required this.number,
    required this.name,
    required this.englishName,
    required this.ayahs,
  });
}