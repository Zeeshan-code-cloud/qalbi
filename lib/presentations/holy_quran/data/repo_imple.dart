import 'package:dio/dio.dart';
import 'package:qalbi/core/network/api_const.dart';
import 'package:qalbi/core/network/dio_client.dart';
import 'package:qalbi/presentations/holy_quran/data/surah_model.dart';
import 'package:qalbi/presentations/holy_quran/repository/surah_entity.dart';
import 'package:qalbi/presentations/holy_quran/repository/surah_repository.dart';

import '../repository/ayah_detail_entity.dart';
import 'ayah_surah_detail_model.dart';

class RepoImple  implements SurahRepository{
  final DioClient dioClient;

  RepoImple({required this.dioClient});
  @override
  Future<List<SurahEntity>> getAllSuran() async {
    try{
      final response = await dioClient.dio.get(ApiConst.allSurahs);
      final responseData = response.data;
      if(response.statusCode != 200){
        throw  Exception("Failed to fetch all surah");
      }
      List<dynamic> data = responseData["data"];
      return data.map((e) {
       return  SurahModel.fromJson(e as Map<String,dynamic>);
      }).toList();
    }
    on DioException catch (e){
      throw Exception(e.message ?? "Network error while fetching the surah" );
    }
    catch (e){
      rethrow;
    }
   }

  @override
  Future<SurahDetailsEntity> getSurahDetails(int number) async {
    try {
      final response = await dioClient.dio.get(
        ApiConst.surahDetails(number),
      );

      if (response.data['code'] != 200) {
        throw Exception('Failed to fetch Surah details');
      }

      return SurahDetailsModel.fromJson(
        response.data['data'],
      );
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Network error');
    }
  }
}