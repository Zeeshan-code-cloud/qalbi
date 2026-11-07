import 'package:get/get.dart';

class CalenderController extends GetxController {
  final selectedDate = DateTime(2025, 10, 16).obs;
  final displayedMonth = DateTime(2025, 10, 1).obs;

  final events = <IslamicEventModel>[
    const IslamicEventModel(
      title: "Rabi' al-Thani 1",
      subtitle: "Start of Rabi' al-Thani 1447 AH",
      day: '26',
      month: 'Oct',
      iconKey: 'month',
    ),
    const IslamicEventModel(
      title: 'Ayyamul Bidh',
      subtitle: "13th, 14th, 15th of Rabi' al-Thani",
      day: '8',
      month: 'Nov',
      iconKey: 'fasting',
    ),
    const IslamicEventModel(
      title: "Friday (Jumu'ah)",
      subtitle: 'Weekly Friday Prayer',
      day: '31',
      month: 'Oct',
      iconKey: 'prayer',
    ),
    const IslamicEventModel(
      title: 'Islamic New Year',
      subtitle: '1 Muharram 1448 AH',
      day: '26',
      month: 'Jun',
      iconKey: 'calendar',
      isImportant: true,
    ),
  ].obs;

  void selectDate(DateTime date) {
    selectedDate.value = date;
    displayedMonth.value = DateTime(date.year, date.month, 1);
  }

  void previousWeek() {
    selectDate(selectedDate.value.subtract(const Duration(days: 7)));
  }

  void nextWeek() {
    selectDate(selectedDate.value.add(const Duration(days: 7)));
  }

  void previousMonth() {
    final month = displayedMonth.value;
    displayedMonth.value = DateTime(month.year, month.month - 1);
    selectedDate.value = DateTime(
      displayedMonth.value.year,
      displayedMonth.value.month,
      1,
    );
  }

  void nextMonth() {
    final month = displayedMonth.value;
    displayedMonth.value = DateTime(month.year, month.month + 1);
    selectedDate.value = DateTime(
      displayedMonth.value.year,
      displayedMonth.value.month,
      1,
    );
  }

  List<DateTime> get weekDates {
    final date = selectedDate.value;
    final monday = date.subtract(
      Duration(days: date.weekday - DateTime.monday),
    );

    return List.generate(
      7,
          (index) => monday.add(Duration(days: index)),
    );
  }

  String get monthName {
    const months = [
      'January', 'February', 'March', 'April',
      'May', 'June', 'July', 'August',
      'September', 'October', 'November', 'December',
    ];
    return months[displayedMonth.value.month - 1];
  }

  @override
  void onInit() {
    super.onInit();
    // Replace the sample date with DateTime.now() if desired.
  }

}
class IslamicEventModel {
  final String title;
  final String subtitle;
  final String day;
  final String month;
  final String iconKey;
  final bool isImportant;

  const IslamicEventModel({
    required this.title,
    required this.subtitle,
    required this.day,
    required this.month,
    required this.iconKey,
    this.isImportant = false,
  });
}