import '../entity/hijri_calendar_entity.dart';
import '../entity/islamic_event_entity.dart';

abstract class IslamicCalendarRepo {
  Future<List<HijriCalendarEntity>> getMonthCalendar({
    required int month,
    required int year,
  });

  Future<List<IslamicEventEntity>> getIslamicEvents();
}