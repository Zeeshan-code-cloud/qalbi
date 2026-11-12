
import 'package:qalbi/presentations/qibla/qibla_entity.dart';

abstract class QiblaRepository {
  Future<QiblaEntity> getQiblaDirection();
}