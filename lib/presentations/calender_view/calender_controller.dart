import 'package:get/get.dart';
import 'package:qalbi/presentations/calender_view/domain/entity/hijri_calendar_entity.dart';
import 'package:qalbi/presentations/calender_view/domain/entity/islamic_event_entity.dart';
import 'package:qalbi/presentations/calender_view/use_cases/get_islamic_events_usecase.dart';
import 'package:qalbi/presentations/calender_view/use_cases/get_month_calendar_usecase.dart';

class CalenderController extends GetxController {
  final GetMonthCalendarUseCase getMonthCalendarUseCase;
  final GetIslamicEventsUseCase getIslamicEventsUseCase;

  CalenderController({
    required this.getIslamicEventsUseCase,
    required this.getMonthCalendarUseCase,
  });

  final RxList<IslamicEventEntity> specialDays = <IslamicEventEntity>[].obs;
  final RxList<HijriCalendarEntity> islamicMonths = <HijriCalendarEntity>[].obs;
  final RxBool specialDaysFetching = false.obs;
  final RxBool islamicMonthFetching = false.obs;
  final Rx<DateTime> selectedDate = DateTime.now().obs;

  int get currentMonth => selectedDate.value.month;
  int get currentYear => selectedDate.value.year;

  List<DateTime> get weekDates {
    final date = selectedDate.value;
    final monday = DateTime(date.year, date.month, date.day)
        .subtract(Duration(days: date.weekday - DateTime.monday));
    return List.generate(7, (index) => monday.add(Duration(days: index)));
  }

  HijriCalendarEntity? calendarFor(DateTime date) {
    for (final entry in islamicMonths) {
      if (entry.gregorianYear == date.year &&
          entry.gregorianMonth == date.month &&
          entry.gregorianDay == date.day) {
        return entry;
      }
    }
    return null;
  }

  List<IslamicEventEntity> get monthHolidays {
    final holidays = <IslamicEventEntity>[];
    for (final date in islamicMonths) {
      for (final holiday in date.holidays) {
        if (holiday.trim().isNotEmpty) {
          holidays.add(IslamicEventEntity(
            day: date.hijriDay,
            month: date.hijriMonth,
            name: holiday,
          ));
        }
      }
    }
    return holidays;
  }

  @override
  void onInit() {
    super.onInit();
    fetchSpecialEvents();
    fetchIslamicMonth();
  }

  Future<void> fetchSpecialEvents() async {
    specialDaysFetching.value = true;
    try {
      specialDays.assignAll(await getIslamicEventsUseCase.call());
    } catch (e) {
      Get.snackbar('Islamic Event Error', e.toString());
    } finally {
      specialDaysFetching.value = false;
    }
  }

  Future<void> fetchIslamicMonth() async {
    islamicMonthFetching.value = true;
    try {
      islamicMonths.assignAll(await getMonthCalendarUseCase.call(
        month: currentMonth,
        year: currentYear,
      ));
    } catch (e) {
      Get.snackbar('Calendar Error', e.toString());
    } finally {
      islamicMonthFetching.value = false;
    }
  }

  Future<void> selectDate(DateTime date) async {
    final loadedMonth = islamicMonths.isEmpty ? null : islamicMonths.first;
    final needsFetch = loadedMonth == null ||
        loadedMonth.gregorianMonth != date.month ||
        loadedMonth.gregorianYear != date.year;
    selectedDate.value = date;
    if (needsFetch) await fetchIslamicMonth();
  }

  Future<void> previousMonth() => _changeMonth(-1);

  Future<void> nextMonth() => _changeMonth(1);

  Future<void> _changeMonth(int offset) async {
    final selected = selectedDate.value;
    final targetMonth = DateTime(selected.year, selected.month + offset, 1);
    final lastDay = DateTime(targetMonth.year, targetMonth.month + 1, 0).day;
    selectedDate.value = DateTime(
      targetMonth.year,
      targetMonth.month,
      selected.day.clamp(1, lastDay),
    );
    await fetchIslamicMonth();
  }
}
