import '../../../core/network/api_client.dart';
import '../../../core/network/base_response.dart';

class ProductFormRepository {
  final ApiClient _apiClient = ApiClient();

  Future<bool> createProduct(Map<String, dynamic> data) async {
    final response = await _apiClient.dio.post(
      '/products',
      data: data,
    );

    final baseResponse = BaseResponse.fromJson(response.data);
    
    return baseResponse.data != null;
  }

  Future<bool> updateProduct(int id, Map<String, dynamic> data) async {
    final response = await _apiClient.dio.put(
      '/products/$id',
      data: data,
    );

    final baseResponse = BaseResponse<bool>.fromJson(
      response.data,
      func: (x) => x as bool,
    );

    return baseResponse.data ?? false;
  }
}