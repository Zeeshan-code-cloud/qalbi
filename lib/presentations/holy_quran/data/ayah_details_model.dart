
import '../repository/ayah_details_entity.dart';

class AyahDetailModel extends AyahDetailEntity {
  const AyahDetailModel({
    required super.number,
    required super.text,
    required super.numberInSurah,
    required super.juz,
    required super.manzil,
    required super.page,
    required super.ruku,
    required super.hizbQuarter,
    required super.sajda,
    required super.translation,
    required super.urduTranslation,
  });

  factory AyahDetailModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return AyahDetailModel(
      urduTranslation: json['urduTranslation']?.toString() ?? '',
      number: json['number'] ?? 0,
      translation: json['translation']?.toString() ?? '',
      text: json['text'] ?? '',
      numberInSurah: json['numberInSurah'] ?? 0,
      juz: json['juz'] ?? 0,
      manzil: json['manzil'] ?? 0,
      page: json['page'] ?? 0,
      ruku: json['ruku'] ?? 0,
      hizbQuarter: json['hizbQuarter'] ?? 0,
      sajda: json['sajda'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'text': text,
      'numberInSurah': numberInSurah,
      'juz': juz,
      'manzil': manzil,
      'page': page,
      'ruku': ruku,
      'hizbQuarter': hizbQuarter,
      'sajda': sajda,
      'translation': translation,
    };
  }
}