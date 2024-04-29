import 'package:flutter/material.dart';
import 'package:grocery_app/core/utils/app_text_styles.dart';
import 'package:grocery_app/core/utils/colors.dart';
import 'package:grocery_app/core/widgets/custom_button.dart';
import 'package:grocery_app/core/widgets/feed_items.dart';
import 'package:grocery_app/models/products_model.dart';
import 'package:grocery_app/providers/products_provider.dart';
import 'package:provider/provider.dart';

class AdminHomeView extends StatelessWidget {
  const AdminHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final productProviders = Provider.of<ProductsProvider>(context);
    List<ProductModel> allProducts = productProviders.getProducts;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 11),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Hi, Admin 👋', style: getbodyStyle()),
                        Text('Manage Your Orders Now!', style: getsmallStyle()),
                        const SizedBox(height: 30),
                        Row(children: [
                          // add hotel button
                          Expanded(
                            child: CustomButton(
                              color: AppColors.primary,
                              text: 'Add Product +',
                              onTap: () {
                                // navigateTo(context, const AddHotelView());
                              },
                            ),
                          ),
                        ]),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 200 / 250,
                ),
                itemCount: allProducts.length,
                itemBuilder: (context, index) {
                  return ChangeNotifierProvider.value(
                    value: allProducts[index],
                    child: const FeedsWidget(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
