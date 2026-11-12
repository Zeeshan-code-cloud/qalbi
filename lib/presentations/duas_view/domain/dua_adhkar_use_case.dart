import 'package:qalbi/presentations/duas_view/domain/adhkar_entity.dart';
import 'package:qalbi/presentations/duas_view/domain/duas_adhkar_repo.dart';
import 'package:qalbi/presentations/duas_view/domain/duas_entity.dart';

class DuaAdhkarUseCase {
  final DuasAdhkarRepo duasAdhkarRepo;

  DuaAdhkarUseCase({required this.duasAdhkarRepo});

  Future<List<DuaEntity>> getDuaUseCase()async {
   return  await duasAdhkarRepo.getDuaList();
  }

  Future<List<AdhkarEntity>> getAdhkarUseCase(String slug)async{
    return await duasAdhkarRepo.getDhikrList(slug);
  }
}