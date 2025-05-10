class User {
  final String id;
  final String firstName;

  User({required this.id, required this.firstName});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(id: json['_id'], firstName: json['firstName']);
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'firstName': firstName};
  }
}

class Product {
  final String id;
  final String name;
  final String slug;

  Product({required this.id, required this.name, required this.slug});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(id: json['_id'], name: json['name'], slug: json['slug']);
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'name': name, 'slug': slug};
  }
}

class Review {
  final String id;
  final Product product;
  final User user;
  final int rating;
  final bool isRecommended;
  final String status;
  final String review;
  final String title;
  final DateTime created;
  final int v;

  Review({
    required this.id,
    required this.product,
    required this.user,
    required this.rating,
    required this.isRecommended,
    required this.status,
    required this.review,
    required this.title,
    required this.created,
    required this.v,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    final dynamic productData = json['product'] ?? "";
    final Product parsedProduct =
        productData is String ? Product(id: productData, name: '', slug: '') : Product.fromJson(productData);

    final dynamic userData = json['user'];
    final User parsedUser = userData is String ? User(id: userData, firstName: '') : User.fromJson(userData);

    return Review(
      id: json['_id'],
      product: parsedProduct,
      user: parsedUser,
      rating: json['rating'],
      isRecommended: json['isRecommended'],
      status: json['status'],
      review: json['review'],
      title: json['title'],
      created: DateTime.parse(json['created']),
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'product': product.toJson(),
      'user': user.toJson(),
      'rating': rating,
      'isRecommended': isRecommended,
      'status': status,
      'review': review,
      'title': title,
      'created': created.toIso8601String(),
      '__v': v,
    };
  }
}
