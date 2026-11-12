import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:qalbi/core/local_storage_service/hive_services.dart';

class OfflineAccessController extends GetxController {
  final RxList<OfflineContentSection> sections = <OfflineContentSection>[].obs;
  final List<ValueListenable<Box>> _boxListenables = [];

  @override
  void onInit() {
    super.onInit();
    _watchBox(HiveService.surahBox);
    _watchBox(HiveService.juzBox);
    _watchBox(HiveService.duaBox);
    _watchBox(HiveService.adhkarBox);
    refreshCachedContent();
  }

  int get totalItems =>
      sections.fold(0, (total, section) => total + section.items.length);

  void _watchBox(Box box) {
    final listenable = box.listenable();
    listenable.addListener(refreshCachedContent);
    _boxListenables.add(listenable);
  }

  void refreshCachedContent() {
    sections.assignAll([
      OfflineContentSection(
        title: 'Surahs',
        icon: 'book',
        items: _readSurahs(),
      ),
      OfflineContentSection(
        title: 'Juz',
        icon: 'juz',
        items: _readJuz(),
      ),
      OfflineContentSection(
        title: 'Duas',
        icon: 'dua',
        items: _readDuas(),
      ),
      OfflineContentSection(
        title: 'Adhkar',
        icon: 'adhkar',
        items: _readAdhkar(),
      ),
    ]);
  }

  List<OfflineContentItem> _readSurahs() {
    final items = <OfflineContentItem>[];
    final cachedIndex = HiveService.getAllSurahs();
    if (cachedIndex != null && cachedIndex.isNotEmpty) {
      final indexBlocks = cachedIndex.whereType<Map>().map((raw) {
        final json = Map<String, dynamic>.from(raw);
        return OfflineTextBlock(
          arabic: _text(json['name']),
          translation: _text(json['englishNameTranslation']),
          metadata: _text(json['englishName']),
        );
      }).toList();
      items.add(OfflineContentItem(
        title: 'Surah catalogue',
        subtitle: '${cachedIndex.length} surahs cached',
        blocks: indexBlocks,
      ));
    }

    for (final key in HiveService.surahBox.keys) {
      final keyText = key.toString();
      if (!keyText.startsWith('surah_')) continue;
      final number = int.tryParse(keyText.substring('surah_'.length));
      final raw = HiveService.surahBox.get(key);
      if (number == null || raw is! Map) continue;
      final json = Map<String, dynamic>.from(raw);
      final ayahs = _readAyahs(json['ayahs']);
      final englishName = _text(json['englishName']);
      final arabicName = _text(json['name']);
      items.add(OfflineContentItem(
        title: englishName.isEmpty ? 'Surah $number' : englishName,
        subtitle: [
          'Surah $number',
          if (arabicName.isNotEmpty) arabicName,
          '${ayahs.length} ayahs',
        ].join(' · '),
        blocks: ayahs,
      ));
    }
    items.sort((a, b) {
      if (a.title == 'Surah catalogue') return -1;
      if (b.title == 'Surah catalogue') return 1;
      return _itemNumber(a.subtitle).compareTo(_itemNumber(b.subtitle));
    });
    return items;
  }

  List<OfflineContentItem> _readJuz() {
    final items = <OfflineContentItem>[];
    for (final key in HiveService.juzBox.keys) {
      final keyText = key.toString();
      if (!keyText.startsWith('juz_')) continue;
      final number = int.tryParse(keyText.substring('juz_'.length));
      final raw = HiveService.juzBox.get(key);
      if (number == null || raw is! Map) continue;
      final json = Map<String, dynamic>.from(raw);
      final ayahs = _readAyahs(json['ayahs']);
      items.add(OfflineContentItem(
        title: 'Juz $number',
        subtitle: '${ayahs.length} ayahs cached',
        blocks: ayahs,
      ));
    }
    items.sort((a, b) => _itemNumber(a.title).compareTo(_itemNumber(b.title)));
    return items;
  }

  List<OfflineContentItem> _readDuas() {
    final cached = HiveService.getDuas();
    if (cached == null) return [];
    return cached.asMap().entries.where((entry) => entry.value is Map).map((entry) {
      final json = Map<String, dynamic>.from(entry.value as Map);
      final title = _firstText(json, ['title', 'name']);
      final arabic = _firstText(json, ['arabic', 'text_ar', 'text']);
      final translation = _firstText(json, ['translation', 'meaning', 'text_en']);
      final transliteration =
          _firstText(json, ['transliteration', 'transliteration_en']);
      final reference = _firstText(json, ['reference', 'source']);
      final category = _firstText(json, ['category', 'category_name']);
      return OfflineContentItem(
        title: title.isEmpty ? 'Dua ${entry.key + 1}' : title,
        subtitle: [if (category.isNotEmpty) category, if (reference.isNotEmpty) reference]
            .join(' · '),
        blocks: [
          OfflineTextBlock(
            arabic: arabic,
            translation: translation,
            metadata: transliteration,
            reference: reference,
          ),
        ],
      );
    }).toList();
  }

  List<OfflineContentItem> _readAdhkar() {
    final items = <OfflineContentItem>[];
    for (final key in HiveService.adhkarBox.keys) {
      final keyText = key.toString();
      if (!keyText.startsWith('collection_')) continue;
      final slug = keyText.substring('collection_'.length);
      final cached = HiveService.getAdhkar(slug);
      if (cached == null) continue;
      for (var index = 0; index < cached.length; index++) {
        final raw = cached[index];
        if (raw is! Map) continue;
        final json = Map<String, dynamic>.from(raw);
        final dhikr = json['dhikr'];
        final dhikrJson = dhikr is Map
            ? Map<String, dynamic>.from(dhikr)
            : <String, dynamic>{};
        final translations = dhikrJson['translations'];
        final references = dhikrJson['references'];
        final translation = translations is List && translations.isNotEmpty
            ? translations.first.toString()
            : '';
        final reference = references is List
            ? references.map((value) => value.toString()).join(', ')
            : _text(references);
        final category = _firstText(json, ['category']);
        final id = _text(dhikrJson['id']);
        final repeatCount = _text(json['repeat_count']);
        items.add(OfflineContentItem(
          title: category.isEmpty ? 'Dhikr $id' : category,
          subtitle: [
            slug.replaceAll('-', ' '),
            if (repeatCount.isNotEmpty) 'Repeat $repeatCount times',
            if (reference.isNotEmpty) reference,
          ].join(' · '),
          blocks: [
            OfflineTextBlock(
              arabic: _text(dhikrJson['text_ar']),
              translation: translation,
              reference: reference,
            ),
          ],
          identity: '$slug-$id-$index',
        ));
      }
    }
    return items;
  }

  List<OfflineTextBlock> _readAyahs(dynamic rawAyahs) {
    if (rawAyahs is! List) return [];
    return rawAyahs.whereType<Map>().map((raw) {
      final json = Map<String, dynamic>.from(raw);
      return OfflineTextBlock(
        arabic: _text(json['text']),
        translation: _text(json['translation']),
        metadata: json['numberInSurah'] == null
            ? ''
            : 'Ayah ${json['numberInSurah']}',
      );
    }).toList();
  }

  String _firstText(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value != null && value.toString().trim().isNotEmpty) {
        return value.toString();
      }
    }
    return '';
  }

  String _text(dynamic value) => value?.toString().trim() ?? '';

  int _itemNumber(String value) {
    final match = RegExp(r'\d+').firstMatch(value);
    return int.tryParse(match?.group(0) ?? '') ?? 0;
  }

  @override
  void onClose() {
    for (final listenable in _boxListenables) {
      listenable.removeListener(refreshCachedContent);
    }
    super.onClose();
  }
}

class OfflineContentSection {
  const OfflineContentSection({
    required this.title,
    required this.icon,
    required this.items,
  });

  final String title;
  final String icon;
  final List<OfflineContentItem> items;
}

class OfflineContentItem {
  const OfflineContentItem({
    required this.title,
    required this.subtitle,
    required this.blocks,
    this.identity,
  });

  final String title;
  final String subtitle;
  final List<OfflineTextBlock> blocks;
  final String? identity;
}

class OfflineTextBlock {
  const OfflineTextBlock({
    required this.arabic,
    required this.translation,
    this.metadata = '',
    this.reference = '',
  });

  final String arabic;
  final String translation;
  final String metadata;
  final String reference;
}
