 import '../repository/juz_entity.dart';

class JuzModel extends JuzEntity {
    JuzModel({
      required super.juzNumber, required super.juzArabicName,
  });

  factory JuzModel.fromNumber(int number) {
    const arabicNames = [
      'الجزء الأول',
      'الجزء الثاني',
      'الجزء الثالث',
      'الجزء الرابع',
      'الجزء الخامس',
      'الجزء السادس',
      'الجزء السابع',
      'الجزء الثامن',
      'الجزء التاسع',
      'الجزء العاشر',
      'الجزء الحادي عشر',
      'الجزء الثاني عشر',
      'الجزء الثالث عشر',
      'الجزء الرابع عشر',
      'الجزء الخامس عشر',
      'الجزء السادس عشر',
      'الجزء السابع عشر',
      'الجزء الثامن عشر',
      'الجزء التاسع عشر',
      'الجزء العشرون',
      'الجزء الحادي والعشرون',
      'الجزء الثاني والعشرون',
      'الجزء الثالث والعشرون',
      'الجزء الرابع والعشرون',
      'الجزء الخامس والعشرون',
      'الجزء السادس والعشرون',
      'الجزء السابع والعشرون',
      'الجزء الثامن والعشرون',
      'الجزء التاسع والعشرون',
      'الجزء الثلاثون',
    ];
    if(number <1 || number >30){
      throw  RangeError.range(number, 1, 30);
    }
    return JuzModel( juzNumber: number, juzArabicName: arabicNames[number -1]);
  }
}