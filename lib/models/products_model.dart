import 'package:flutter/cupertino.dart';

class ProductModel with ChangeNotifier {
  final String id, title, imageUrl, productCategoryName;
  final double price, salePrice;
  final int orderCount;
  final bool isOnSale, isPiece;

  ProductModel(
      {required this.id,
      required this.title,
      required this.orderCount,
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
  final int orderCount;
  final bool isOnSale, isPiece;

  ProductsModel(
      {required this.id,
      required this.title,
      required this.imageUrl,
      required this.productCategoryName,
      required this.price,
      required this.orderCount,
      required this.salePrice,
      required this.isOnSale,
      required this.isPiece});

  factory ProductsModel.fromJson(Map<String, dynamic> json) {
    return ProductsModel(
      id: json['id'],
      title: json['title'],
      orderCount: json['orderCount'],
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
      'orderCount': orderCount,
      'productCategoryName': productCategoryName,
      'price': price,
      'salePrice': salePrice,
      'isOnSale': isOnSale,
      'isPiece': isPiece,
    };
  }
}
