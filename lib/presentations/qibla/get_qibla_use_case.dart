

import 'package:qalbi/presentations/qibla/qibla_entity.dart';
import 'package:qalbi/presentations/qibla/qibla_repository.dart';

class GetQiblaDirectionUseCase {
  final QiblaRepository repository;

  GetQiblaDirectionUseCase({
    required this.repository,
  });

  Future<QiblaEntity> call() {
    return repository.getQiblaDirection();
  }
}