import 'package:flutter_app/models/Brands.dart';
import 'package:flutter_app/models/products.dart';

final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

enum FieldType { email, password, text }

enum DetailType { add, update }

Products fakeData = Products(
  id: "6815a969fff0414534466851",
  name: "Nuc M15 Kit",
  price: 400,
  imageUrl: "/uploads/80d7e5d3-2e49-42ec-bafd-c373f0ea74a3-intel-nuc-m15-i7-bbc710bcuxbc1-thumb-1-600x600.jpg",
  slug: "nuc-m15-kit",
  taxable: true,
  isActive: true,
  brand: Brand(id: '', name: '', isActive: false),
  sku: "NUC-M15",
  description: "A high-performance NUC M15 Kit for developers.",
  quantity: 50,
  imageKey: "80d7e5d3-2e49-42ec-bafd-c373f0ea74a3",
  created: DateTime.now(),
  v: 1,
  totalRatings: 100,
  totalReviews: 25,
  averageRating: 4.5,
);
