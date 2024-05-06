import 'package:flutter/material.dart';
import 'package:grocery_app/core/widgets/on_sale_widget.dart';
import 'package:grocery_app/core/widgets/text_widget.dart';
import 'package:provider/provider.dart';

import '../../../core/services/utils.dart';
import '../../../core/widgets/back_widget.dart';
import '../../../core/widgets/empty_products_widget.dart';
import '../../../models/products_model.dart';
import '../../../providers/products_provider.dart';

class OnSaleScreen extends StatelessWidget {
  static const routeName = "/OnSaleScreen";
  const OnSaleScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final productProviders = Provider.of<ProductsProvider>(context);
    List<ProductModel> productsOnSale = productProviders.getOnSaleProducts;
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    return Scaffold(
      appBar: AppBar(
        leading: const BackWidget(),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: TextWidget(
          text: 'Products on sale',
          color: color,
          textSize: 24.0,
          isTitle: true,
        ),
      ),
      body: productsOnSale.isEmpty
          ? const EmptyProdWidget(
              text: 'No products on sale yet!,\nStay tuned',
            )
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  mainAxisExtent: 220,
                  crossAxisSpacing: 10),
              padding: EdgeInsets.zero,
              // crossAxisSpacing: 10,
              itemCount: productsOnSale.length,
              itemBuilder: (context, index) {
                return ChangeNotifierProvider.value(
                  value: productsOnSale[index],
                  child: const OnSaleWidget(),
                );
              }),
    );
  }
}
