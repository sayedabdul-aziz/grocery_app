import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/models/orders_model.dart';
import 'package:provider/provider.dart';

import '../../../core/services/utils.dart';
import '../../../core/widgets/text_widget.dart';
import '../../../providers/products_provider.dart';

class OrderWidget extends StatefulWidget {
  const OrderWidget({super.key});

  @override
  State<OrderWidget> createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  late String orderDateToShow;

  @override
  void didChangeDependencies() {
    final ordersModel = Provider.of<OrderModel>(context);
    var orderDate = ordersModel.orderDate.toDate();
    orderDateToShow = '${orderDate.day}/${orderDate.month}/${orderDate.year}';
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final ordersModel = Provider.of<OrderModel>(context);
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    final productProvider = Provider.of<ProductsProvider>(context);
    final getCurrProduct = productProvider.findProdById(ordersModel.productId);
    return ListTile(
      subtitle:
          Text('Paid: \$${double.parse(ordersModel.price).toStringAsFixed(2)}'),
      leading: FancyShimmerImage(
        width: size.width * 0.2,
        imageUrl: getCurrProduct.imageUrl,
        boxFit: BoxFit.fill,
      ),
      title: TextWidget(
          text: '${getCurrProduct.title}  x${ordersModel.quantity}',
          color: color,
          textSize: 18),
      trailing: TextWidget(text: orderDateToShow, color: color, textSize: 18),
    );
  }
}
