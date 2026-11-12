import 'package:qalbi/presentations/duas_view/domain/adhkar_entity.dart';

class AdhkarModel extends AdhkarEntity {
  const AdhkarModel({
    required super.id,
    required super.category,
    required super.arabic,
    required super.translation,
    required super.reference,
    required super.repeatCount,
  });

  factory AdhkarModel.fromJson(Map<String, dynamic> json) {
    final rawDhikr = json['dhikr'];
    final Map<String, dynamic> dhikr;

    if (rawDhikr is Map) {
      // Hive may deserialize nested JSON maps as Map<dynamic, dynamic>.
      dhikr = Map<String, dynamic>.from(rawDhikr);
    } else if (json.containsKey('text_ar') ||
        json.containsKey('arabic') ||
        json.containsKey('text')) {
      // Also accept a flattened item in case the collection payload is flat.
      dhikr = json;
    } else {
      throw const FormatException(
        'Invalid adhkar item: expected a dhikr object or Arabic text',
      );
    }

    final rawId = dhikr['id'] ?? json['id'];
    final rawRepeatCount = json['repeat_count'] ?? json['repeatCount'];
    final rawTranslations = dhikr['translations'];
    final translation = _readTranslation(rawTranslations) ??
        _readText(dhikr, const ['translation', 'text_en', 'meaning']) ??
        '';
    final references = dhikr['references'] ?? dhikr['reference'];

    return AdhkarModel(
      id: rawId is int ? rawId : int.tryParse(rawId?.toString() ?? '') ?? 0,
      arabic: _readText(dhikr, const ['text_ar', 'arabic', 'text']) ?? '',
      repeatCount: rawRepeatCount is int
          ? rawRepeatCount
          : int.tryParse(rawRepeatCount?.toString() ?? '') ?? 1,
      category: (json['category'] ?? dhikr['category'] ?? '').toString(),
      translation: translation,
      reference: _readReferences(references),
    );
  }

  static String? _readText(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value is String && value.trim().isNotEmpty) return value;
      if (value != null && value is! Map && value is! List) {
        final text = value.toString().trim();
        if (text.isNotEmpty) return text;
      }
    }
    return null;
  }

  static String? _readTranslation(dynamic raw) {
    if (raw is String) return raw;
    if (raw is Map) {
      final map = Map<String, dynamic>.from(raw);
      return _readText(map, const ['text', 'translation', 'value', 'en']);
    }
    if (raw is List) {
      for (final item in raw) {
        if (item is String && item.trim().isNotEmpty) return item;
        if (item is Map) {
          final map = Map<String, dynamic>.from(item);
          final text = _readText(
            map,
            const ['text', 'translation', 'value', 'text_en'],
          );
          if (text != null) return text;
        }
      }
    }
    return null;
  }

  static String _readReferences(dynamic raw) {
    if (raw is String) return raw;
    if (raw is List) {
      return raw.map((item) {
        if (item is Map) {
          final map = Map<String, dynamic>.from(item);
          return [
            map['collection'],
            map['number'],
            map['surah'],
            map['ayah_from'],
            map['ayah_to'],
            map['grade'],
          ].where((value) => value != null).join(' ');
        }
        return item.toString();
      }).where((value) => value.trim().isNotEmpty).join(', ');
    }
    if (raw is Map) {
      return Map<String, dynamic>.from(raw).entries
          .map((entry) => '${entry.key}: ${entry.value}')
          .join(', ');
    }
    return raw?.toString() ?? '';
  }
}
