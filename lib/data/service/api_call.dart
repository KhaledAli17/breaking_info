import 'package:breaking_api/constants/constants.dart';
import 'package:dio/dio.dart';

class ApiCall {
  Dio? dio;

  ApiCall() {
    BaseOptions options = BaseOptions(
      baseUrl: baseUrl,
      receiveDataWhenStatusError: true,
      connectTimeout: 30 * 1000,
      receiveTimeout: 30 * 1000,
    );
    dio = Dio(options);
  }

  Future<List<dynamic>> getCharactersData() async {
    Response response = await dio!.get('characters');
    //print('response data ${response.data}');
    return response.data;
  }


  Future<List<dynamic>> getQuotes(String name) async {
    Response response = await dio!.get('quote' , queryParameters: {'author' : name});
    return response.data;
  }
}
