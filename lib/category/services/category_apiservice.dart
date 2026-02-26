import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';

class CategoryApiService {
  static final ApiClient _apiClient = ApiClient();

  static Future<Response> getCategories() async {
    return await _apiClient.dio.get('/categories');
  }

  static Future<Response> createCategory(String name) async {
    return await _apiClient.dio.post(
      '/categories',
      data: {'name': name}, 
    );
  }

  static Future<Response> updateCategory(int id, String name) async {
    return await _apiClient.dio.put(
      '/categories/$id',
      data: {'name': name},
    );
  }

  static Future<Response> deleteCategory(int id) async {
    return await _apiClient.dio.delete('/categories/$id');
  }
}