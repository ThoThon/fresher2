import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ApiInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final box = Hive.box('settings');
    final String? token = box.get('token'); // Dùng key 'token'

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token'; // Giống Postman
    }
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Tự động lưu token khi gọi API login thành công
    if (response.requestOptions.path.contains('/login') &&
        response.statusCode == 200) {
      final token = response.data['data']['access_token'];
      if (token != null) {
        Hive.box('settings').put('token', token);
      }
    }
    return handler.next(response);
  }
}
