class Categories {
  final bool isActive;
  final List<String> products;
  final String id;
  final String name;
  final String description;
  final DateTime created;
  final String slug;
  final int v;

  Categories({
    required this.isActive,
    required this.products,
    required this.id,
    required this.name,
    required this.description,
    required this.created,
    required this.slug,
    required this.v,
  });

  factory Categories.fromJson(Map<String, dynamic> json) {
    return Categories(
      isActive: json['isActive'],
      products: List<String>.from(json['products']),
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      created: DateTime.parse(json['created']),
      slug: json['slug'],
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isActive': isActive,
      'products': products,
      '_id': id,
      'name': name,
      'description': description,
      'created': created.toIso8601String(),
      'slug': slug,
      '__v': v,
    };
  }
}
