
import '../../domain/entity/islamic_event_entity.dart';

class IslamicEventModel extends IslamicEventEntity {
  const IslamicEventModel({
    required super.day,
    required super.month,
    required super.name,
  });

  factory IslamicEventModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return IslamicEventModel(
      day: json['day'] ?? 0,
      month: json['month'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}