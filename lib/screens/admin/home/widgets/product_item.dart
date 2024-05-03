import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/core/consts/navigation.dart';
import 'package:grocery_app/core/utils/colors.dart';
import 'package:grocery_app/core/widgets/custom_button.dart';
import 'package:grocery_app/core/widgets/text_widget.dart';
import 'package:grocery_app/models/products_model.dart';
import 'package:grocery_app/screens/admin/home/add_product.dart';

class Productitem extends StatelessWidget {
  final ProductsModel productModel;

  const Productitem({super.key, required this.productModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.shadeColor.withOpacity(.3),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadeColor.withOpacity(.2),
              offset: const Offset(0, 5),
              blurRadius: 10,
            )
          ]),
      padding: const EdgeInsets.all(8.0),
      child: Column(children: [
        FancyShimmerImage(
          imageUrl: productModel.imageUrl,
          height: 100,
          width: 100,
          boxFit: BoxFit.fill,
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TextWidget(
                  text: productModel.title,
                  color: AppColors.white,
                  maxLines: 1,
                  textSize: 16,
                  isTitle: true,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Row(
                  children: [
                    (productModel.isOnSale)
                        ? Expanded(
                            child: TextWidget(
                              text: '${productModel.salePrice}\$',
                              color: AppColors.primary,
                              maxLines: 1,
                              textSize: 16,
                              isTitle: true,
                            ),
                          )
                        : Expanded(
                            child: TextWidget(
                              text: '${productModel.price}\$',
                              color: AppColors.primary,
                              maxLines: 1,
                              textSize: 16,
                              isTitle: true,
                            ),
                          ),
                    if (productModel.isOnSale)
                      TextWidget(
                        text: 'Sale',
                        color: AppColors.redColor,
                        maxLines: 1,
                        textSize: 16,
                        isTitle: true,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        CustomButton(
          height: 40,
          text: 'Edit',
          color: AppColors.shadeColor,
          onTap: () {
            navigateTo(
                context,
                AddProductView(
                  model: productModel,
                ));
          },
        )
      ]),
    );
  }
}
