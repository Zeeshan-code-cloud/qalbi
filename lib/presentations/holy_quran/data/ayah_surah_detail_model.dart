 import '../repository/ayah_detail_entity.dart';
import 'ayah_model.dart';

class SurahDetailsModel extends SurahDetailsEntity {
  const SurahDetailsModel({
    required super.number,
    required super.name,
    required super.englishName,
    required super.ayahs,
  });

  factory SurahDetailsModel.fromJson(Map<String, dynamic> json) {
    return SurahDetailsModel(
      number: json['number'] ?? 0,
      name: json['name'] ?? '',
      englishName: json['englishName'] ?? '',
      ayahs: (json['ayahs'] as List)
          .map((e) => AyahModel.fromJson(e))
          .toList(),
    );
  }
}