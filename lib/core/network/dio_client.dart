import 'package:dio/dio.dart';
import 'package:qalbi/core/network/api_const.dart';
class DioClient {
  late final  Dio dio;

  DioClient (){
    dio = Dio(
        BaseOptions(
          baseUrl: ApiConst.baseUrl,
          connectTimeout: Duration(seconds: 20),
          receiveTimeout: Duration(seconds: 20),
          headers: {
            "Accept": "application/json",
          }
        )
    );
  }
}