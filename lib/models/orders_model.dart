import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class OrderModel with ChangeNotifier {
  final String orderId,
      userId,
      productId,
      productName,
      userName,
      price,
      imageUrl,
      quantity;
  final Timestamp orderDate;

  OrderModel(
      {required this.orderId,
      required this.productName,
      required this.userId,
      required this.productId,
      required this.userName,
      required this.price,
      required this.imageUrl,
      required this.quantity,
      required this.orderDate});
}
