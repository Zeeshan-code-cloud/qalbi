import '../repository/juz_details_entity.dart';
import 'ayah_details_model.dart';

class JuzDetailsModel extends JuzDetailsEntity {
  JuzDetailsModel({
    required super.juzNumber,
    required super.ayahList,
  });

  factory JuzDetailsModel.fromJson(
      Map<String, dynamic> json,
      ) {
    final ayahList = json['ayahs'] as List<dynamic>? ?? [];

    return JuzDetailsModel(
      juzNumber: json['number'] ?? 0,
      ayahList: ayahList.map((e) {
        return AyahDetailModel.fromJson(
          e as Map<String, dynamic>,
        );
      }).toList(),
    );
  }
}