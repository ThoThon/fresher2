import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../services/category_apiservice.dart';

class CategoryRepository {
  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await CategoryApiService.getCategories();
      if (response.statusCode == 200) {
        List data = response.data['data'] ?? [];
        return data.map((item) => CategoryModel.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      debugPrint('Lỗi CategoryRepository.getCategories: $e');
      return [];
    }
  }

  Future<bool> createCategory(String name) async {
    try {
      final response = await CategoryApiService.createCategory(name);
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Lỗi CategoryRepository.create: $e');
      return false;
    }
  }

  Future<bool> updateCategory(int id, String name) async {
    try {
      final response = await CategoryApiService.updateCategory(id, name);
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Lỗi CategoryRepository.update: $e');
      return false;
    }
  }

  Future<bool> deleteCategory(int id) async {
    try {
      final response = await CategoryApiService.deleteCategory(id);
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Lỗi CategoryRepository.delete: $e');
      return false;
    }
  }
}
