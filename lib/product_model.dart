import 'dart:convert';

List<ProductModel> productModelFromJson(String str) => List<ProductModel>.from(
      json.decode(str).map((x) => ProductModel.fromJson(x)),
    );

String productModelToJson(List<ProductModel> data) => json.encode(
      List<dynamic>.from(data.map((x) => x.toJson())),
    );

class ProductModel {
  ProductModel({
    required this.id,
    required this.title,
    required this.slug,
    required this.price,
    required this.description,
    required this.category,
    required this.images,
    required this.creationAt,
    required this.updatedAt,
  });

  int id;
  String title;
  String slug;
  int price;
  String description;
  Category category;
  List<String> images;
  DateTime creationAt;
  DateTime updatedAt;

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json['id'],
        title: json['title'],
        slug: json['slug'],
        price: json['price'],
        description: json['description'],
        category: Category.fromJson(json['category']),
        images: List<String>.from(
          json['images'].map((x) => _cleanImageUrl(x.toString())),
        ),
        creationAt: DateTime.parse(json['creationAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'slug': slug,
        'price': price,
        'description': description,
        'category': category.toJson(),
        'images': List<dynamic>.from(images.map((x) => x)),
        'creationAt': creationAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  static String _cleanImageUrl(String value) {
    return value
        .replaceAll('[', '')
        .replaceAll(']', '')
        .replaceAll('"', '')
        .trim();
  }
}

class Category {
  Category({
    required this.id,
    required this.name,
    required this.slug,
    required this.image,
    required this.creationAt,
    required this.updatedAt,
  });

  int id;
  String name;
  String slug;
  String image;
  DateTime creationAt;
  DateTime updatedAt;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json['id'],
        name: json['name'],
        slug: json['slug'],
        image: json['image'],
        creationAt: DateTime.parse(json['creationAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'slug': slug,
        'image': image,
        'creationAt': creationAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };
}
