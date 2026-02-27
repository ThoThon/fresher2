import '../../../core/network/api_client.dart';
import '../../../core/network/base_response_list.dart';
import '../../../core/network/base_response.dart'; 
import '../../models/category_model.dart';

class CategoryRepository {
  final ApiClient _apiClient = ApiClient();

  Future<List<CategoryModel>> getCategories() async {
    final response = await _apiClient.dio.get('/categories');

    final baseResponse = BaseResponseList<CategoryModel>.fromJson(
      response.data,
      func: (item) => CategoryModel.fromJson(item),
    );

    return baseResponse.data;
  }

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

  Future<bool> deleteCategory(int id) async {
    final response = await _apiClient.dio.delete('/categories/$id');

    final baseResponse = BaseResponse<bool>.fromJson(
      response.data,
      func: (x) => x as bool,
    );

    return baseResponse.data ?? false;
  }
}