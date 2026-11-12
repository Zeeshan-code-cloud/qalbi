class AyahEntity {
  final int number;
  final String text;
  final int numberInSurah;
  final int juz;
  final int page;
  final bool sajda;
  final String translation;
  final String urduTranslation;

  const AyahEntity({
    required this.number,
    required this.text,
    required this.numberInSurah,
    required this.juz,
    required this.page,
    required this.sajda,
    this.translation = '',
    this.urduTranslation = '',
  });
}