import 'package:fresher_demo_2/core/network/api_client.dart';
import 'package:dio/dio.dart';

class AuthRepository {
  final ApiClient _apiClient = ApiClient();

  Future<Response> login(String username, String password) async {
    final Map<String, dynamic> loginData = {
      "username": username,
      "password": password,
    };
    return await _apiClient.dio.post('/login', data: loginData);
  }
}
