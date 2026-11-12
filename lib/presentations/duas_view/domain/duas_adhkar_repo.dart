import 'package:qalbi/presentations/duas_view/domain/adhkar_entity.dart';
import 'package:qalbi/presentations/duas_view/domain/duas_entity.dart';

abstract class DuasAdhkarRepo {

  Future<List<DuaEntity>> getDuaList();

  Future<List<AdhkarEntity>> getDhikrList(String slug);
}