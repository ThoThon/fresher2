class CategoryRequest {
  final String name;
  final int? id;

  CategoryRequest({
    required this.name,
    this.id,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}
