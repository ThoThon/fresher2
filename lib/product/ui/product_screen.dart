import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/product_controller.dart';
import '../models/product_model.dart';

class ProductFormScreen extends GetView<ProductController> {
  final ProductModel? product;
  const ProductFormScreen({super.key, this.product});

  @override
  Widget build(BuildContext context) {
    controller.prepareForm(product);

    return Scaffold(
      appBar: AppBar(
        title: Text(product == null ? "Thêm sản phẩm" : "Sửa sản phẩm"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: Form(
        key: controller.formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildTextField(controller.nameController, "Tên sản phẩm *",
                (v) => v!.isEmpty ? "Vui lòng nhập tên" : null),
            _buildTextField(controller.codeController, "Mã SKU *",
                (v) => v!.isEmpty ? "Vui lòng nhập mã" : null),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                      controller.priceController,
                      "Giá *",
                      (v) => (double.tryParse(v!) ?? 0) <= 0
                          ? "Giá phải > 0"
                          : null,
                      isNumber: true),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                      controller.stockController,
                      "Tồn kho *",
                      (v) =>
                          (int.tryParse(v!) ?? -1) < 0 ? "Tồn kho >= 0" : null,
                      isNumber: true),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text("Danh mục",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Obx(
              () => DropdownButtonFormField<int>(
                value: controller.selectedFormCategoryId.value,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none),
                ),
                items: controller.categories
                    .map((cat) =>
                        DropdownMenuItem(value: cat.id, child: Text(cat.name)))
                    .toList(),
                onChanged: (val) =>
                    controller.selectedFormCategoryId.value = val,
                hint: const Text("Chọn danh mục"),
              ),
            ),
            _buildTextField(controller.descController, "Mô tả", null,
                maxLines: 3),
            const SizedBox(height: 32),
            Obx(
              () => ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFf24e1e),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: controller.isLoading.value
                    ? null
                    : () => product == null
                        ? controller.addProduct()
                        : controller.updateProduct(product!.id),
                child: controller.isLoading.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("LƯU SẢN PHẨM",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController textController, String label,
      String? Function(String?)? validator,
      {bool isNumber = false, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextFormField(
            controller: textController,
            validator: validator,
            maxLines: maxLines,
            keyboardType: isNumber ? TextInputType.number : TextInputType.text,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none),
            ),
          ),
        ],
      ),
    );
  }
}
