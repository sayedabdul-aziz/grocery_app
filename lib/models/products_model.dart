import 'package:flutter/cupertino.dart';

class ProductModel with ChangeNotifier {
  final String id, title, imageUrl, productCategoryName;
  final double price, salePrice;
  final bool isOnSale, isPiece;

  ProductModel(
      {required this.id,
      required this.title,
      required this.imageUrl,
      required this.productCategoryName,
      required this.price,
      required this.salePrice,
      required this.isOnSale,
      required this.isPiece});
}

class ProductsModel {
  final String id, title, imageUrl, productCategoryName;
  final double price, salePrice;
  final bool isOnSale, isPiece;

  ProductsModel(
      {required this.id,
      required this.title,
      required this.imageUrl,
      required this.productCategoryName,
      required this.price,
      required this.salePrice,
      required this.isOnSale,
      required this.isPiece});

  factory ProductsModel.fromJson(Map<String, dynamic> json) {
    return ProductsModel(
      id: json['id'],
      title: json['title'],
      imageUrl: json['imageUrl'],
      productCategoryName: json['productCategoryName'],
      price: json['price'],
      salePrice: json['salePrice'],
      isOnSale: json['isOnSale'],
      isPiece: json['isPiece'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
      'productCategoryName': productCategoryName,
      'price': price,
      'salePrice': salePrice,
      'isOnSale': isOnSale,
      'isPiece': isPiece,
    };
  }
}
