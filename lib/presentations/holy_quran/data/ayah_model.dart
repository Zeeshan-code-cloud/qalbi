
import '../repository/ayah_entity.dart';

class AyahModel extends AyahEntity {
  const AyahModel({
    required super.number,
    required super.text,
    required super.numberInSurah,
    required super.juz,
    required super.page,
    required super.sajda,
  });

  factory AyahModel.fromJson(Map<String, dynamic> json) {
    return AyahModel(
      number: json['number'] ?? 0,
      text: json['text'] ?? '',
      numberInSurah: json['numberInSurah'] ?? 0,
      juz: json['juz'] ?? 0,
      page: json['page'] ?? 0,
      sajda: json['sajda'] == true,
    );
  }
}