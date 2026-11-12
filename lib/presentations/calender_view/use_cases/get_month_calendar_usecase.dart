import '../domain/entity/hijri_calendar_entity.dart';
import '../domain/repository/islamic_calendar_repo.dart';

class GetMonthCalendarUseCase {
  final IslamicCalendarRepo repository;

  GetMonthCalendarUseCase({
    required this.repository,
  });

  Future<List<HijriCalendarEntity>> call({
    required int month,
    required int year,
  }) {
    return repository.getMonthCalendar(
      month: month,
      year: year,
    );
  }
}