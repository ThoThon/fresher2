import '../../core/network/api_client.dart';
import '../models/category_model.dart';

class CategoryRepository {
  final ApiClient _apiClient = ApiClient();

  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await _apiClient.dio.get('/categories');
      
      if (response.statusCode == 200) {
        List data = response.data['data'];
        return data.map((item) => CategoryModel.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      throw Exception("Lấy danh mục thất bại");
    }
  }
}