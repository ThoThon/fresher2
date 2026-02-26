import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';

class ProductApiService {
  static final ApiClient _apiClient = ApiClient();

  static Future<Response> getProducts({
    int page = 1,
    int limit = 10,
    String keyword = '',
    int? categoryId,
  }) async {
    return await _apiClient.dio.get(
      '/products',
      queryParameters: {
        'page': page,
        'limit': limit,
        'keyword': keyword,
        if (categoryId != null) 'category_id': categoryId,
      },
    );
  }

  static Future<Response> createProduct(Map<String, dynamic> data) async {
    return await _apiClient.dio.post('/products', data: data);
  }

  static Future<Response> updateProduct(int id, Map<String, dynamic> data) async {
    return await _apiClient.dio.put('/products/$id', data: data);
  }

  static Future<Response> deleteProduct(int id) async {
    return await _apiClient.dio.delete('/products/$id');
  }
}