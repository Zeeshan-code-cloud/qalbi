import 'package:qalbi/presentations/duas_view/domain/duas_entity.dart';

class DuaModel extends DuaEntity {
  new({
    required super.id,
    required super.category,
    required super.title,
    required super.arabic,
    required super.translation,
    required super.transliteration,
    required super.reference,
  });

  factory DuaModel.fromJson(Map<String, dynamic> json) {
    String readText(Iterable<String> keys) {
      for (final key in keys) {
        final value = json[key];
        if (value != null) return value.toString();
      }
      return '';
    }

    final rawId = json['id'];
    final id = rawId is int ? rawId : int.tryParse(rawId?.toString() ?? '') ?? 0;

    return DuaModel(
      id: id,
      category: readText(['category', 'category_name']),
      title: readText(['title', 'name']),
      arabic: readText(['arabic', 'text_ar', 'text']),
      translation: readText(['translation', 'meaning', 'text_en']),
      transliteration: readText(['transliteration', 'transliteration_en']),
      reference: readText(['reference', 'source']),
    );
  }
}
