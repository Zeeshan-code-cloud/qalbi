import 'package:dio/dio.dart';
import 'package:qalbi/core/network/api_const.dart';

 import '../../domain/entity/hijri_calendar_entity.dart';
import '../../domain/entity/islamic_event_entity.dart';
import '../../domain/repository/islamic_calendar_repo.dart';
import '../model/hijri_calendar_model.dart';
import '../model/islamic_event_model.dart';

class IslamicCalendarRepoImpl implements IslamicCalendarRepo {
  final Dio dio;

  IslamicCalendarRepoImpl({
    required this.dio,
  });


  @override
  Future<List<HijriCalendarEntity>> getMonthCalendar({
    required int month,
    required int year,
  }) async {
    final response = await dio.get(
      ApiConst.monthCalendar(month, year),
      queryParameters: {
        'calendarMethod': 'HJCoSA',
      },
    );

    final List<dynamic> data = response.data['data'];

    return data.map((item) {
      return HijriCalendarModel.fromJson(
        item as Map<String, dynamic>,
      );
    }).toList();
  }

  @override
  Future<List<IslamicEventEntity>> getIslamicEvents() async {
    final response = await dio.get(
      ApiConst.specialDays,
    );

    final List<dynamic> data = response.data['data'];

    return data.map((item) {
      return IslamicEventModel.fromJson(
        item as Map<String, dynamic>,
      );
    }).toList();
  }
}