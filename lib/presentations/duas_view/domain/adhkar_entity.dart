class AdhkarEntity {
  final int id;
  final String category;
  final String arabic;
  final String translation;
  final String reference;
  final int repeatCount;

  const AdhkarEntity({
    required this.id,
    required this.category,
    required this.arabic,
    required this.translation,
    required this.reference,
    required this.repeatCount,
  });
}