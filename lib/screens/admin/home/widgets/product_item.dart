import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/core/consts/navigation.dart';
import 'package:grocery_app/core/services/utils.dart';
import 'package:grocery_app/core/utils/colors.dart';
import 'package:grocery_app/core/widgets/custom_button.dart';
import 'package:grocery_app/core/widgets/text_widget.dart';
import 'package:grocery_app/models/products_model.dart';
import 'package:grocery_app/screens/admin/home/add_product.dart';
import 'package:provider/provider.dart';

class Productitem extends StatefulWidget {
  const Productitem({super.key});

  @override
  State<Productitem> createState() => _ProductitemState();
}

class _ProductitemState extends State<Productitem> {
  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    final productModel = Provider.of<ProductModel>(context);

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
          height: size.width * 0.21,
          width: size.width * 0.2,
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
                    Expanded(
                      child: TextWidget(
                        text: '${productModel.price}\$',
                        color: AppColors.primary,
                        maxLines: 1,
                        textSize: 16,
                        isTitle: true,
                      ),
                    ),
                    Flexible(
                      child: FittedBox(
                        child: TextWidget(
                          text: productModel.isPiece ? 'Piece' : 'kg',
                          color: AppColors.primary,
                          textSize: 14,
                          isTitle: true,
                        ),
                      ),
                    ),
                  ],
                ),
              )
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
