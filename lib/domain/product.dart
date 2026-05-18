import 'package:flutter/foundation.dart';

@immutable
class Product {
  final int id;
  final String? documentId;
  final String title;
  final String? price;
  final String? oldPrice;
  final String? category;
  final String? image;
  final List<String> images;
  final bool? inStock;
  final String? shortDescription;
  final String? description;
  final String? permalink;

  const Product({
    required this.id,
    this.documentId,
    required this.title,
    this.price,
    this.oldPrice,
    this.category,
    this.image,
    this.images = const [],
    this.inStock,
    this.shortDescription,
    this.description,
    this.permalink,
  });
}
