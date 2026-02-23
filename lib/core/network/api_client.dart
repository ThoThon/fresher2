import 'package:dio/dio.dart';
import 'package:fresher_demo_2/core/network/api_interceptor.dart';

class ApiClient {
  late Dio dio;

  ApiClient() {
    dio = Dio(BaseOptions(
      baseUrl: "http://192.168.20.19:8080/api/v1",
    ));

    dio.interceptors.add(ApiInterceptor());
  }
}
