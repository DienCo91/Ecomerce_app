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

class Review {
  final String id;
  final String productId;
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
    required this.productId,
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
    return Review(
      id: json['_id'],
      productId: json['product'],
      user: User.fromJson(json['user']),
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
      'product': productId,
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
