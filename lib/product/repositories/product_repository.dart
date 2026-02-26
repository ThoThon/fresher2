import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/product_api_service.dart';

class ProductRepository {
  Future<List<ProductModel>> getProducts({
    int page = 1,
    int limit = 10,
    String keyword = '',
    int? categoryId,
  }) async {
    try {
      final response = await ProductApiService.getProducts(
        page: page,
        limit: limit,
        keyword: keyword,
        categoryId: categoryId,
      );

      if (response.statusCode == 200) {
        List data = response.data['data'] ?? [];
        return data.map((item) => ProductModel.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      debugPrint('Lỗi ProductRepo.getProducts: $e');
      return [];
    }
  }

  Future<bool> createProduct(Map<String, dynamic> data) async {
    try {
      final response = await ProductApiService.createProduct(data);
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Lỗi ProductRepo.create: $e');
      return false;
    }
  }

  Future<bool> updateProduct(int id, Map<String, dynamic> data) async {
    try {
      final response = await ProductApiService.updateProduct(id, data);
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Lỗi ProductRepo.update: $e');
      return false;
    }
  }

  Future<bool> deleteProduct(int id) async {
    try {
      final response = await ProductApiService.deleteProduct(id);
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Lỗi ProductRepo.delete: $e');
      return false;
    }
  }
}
