import '../../../core/network/api_client.dart';
import '../../../core/network/base_response.dart';

class CategoryFormRepository {
  final ApiClient _apiClient = ApiClient();

  Future<bool> createCategory(String name) async {
    final response = await _apiClient.dio.post(
      '/categories',
      data: {'name': name},
    );
    final baseResponse = BaseResponse.fromJson(response.data);
    return baseResponse.data != null;
  }

  Future<bool> updateCategory(int id, String name) async {
    final response = await _apiClient.dio.put(
      '/categories/$id',
      data: {'name': name},
    );
    final baseResponse = BaseResponse<bool>.fromJson(
      response.data,
      func: (x) => x as bool,
    );
    return baseResponse.data ?? false;
  }
}