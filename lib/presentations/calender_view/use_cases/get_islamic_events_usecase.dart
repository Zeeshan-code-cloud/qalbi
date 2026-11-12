import '../domain/entity/islamic_event_entity.dart';
import '../domain/repository/islamic_calendar_repo.dart';

class GetIslamicEventsUseCase {
  final IslamicCalendarRepo repository;

  GetIslamicEventsUseCase({
    required this.repository,
  });

  Future<List<IslamicEventEntity>> call() {
    return repository.getIslamicEvents();
  }
}