import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grocery_app/core/services/utils.dart';
import 'package:grocery_app/core/utils/colors.dart';
import 'package:grocery_app/core/widgets/custom_button.dart';
import 'package:grocery_app/core/widgets/heart_btn.dart';
import 'package:grocery_app/core/widgets/text_widget.dart';
import 'package:provider/provider.dart';

import '../../screens/customer/inner_screens/product_details.dart';
import '../../models/products_model.dart';
import '../../providers/cart_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../consts/firebase_consts.dart';
import '../services/global_methods.dart';
import 'price_widget.dart';

class OnSaleWidget extends StatefulWidget {
  const OnSaleWidget({super.key});

  @override
  State<OnSaleWidget> createState() => _OnSaleWidgetState();
}

class _OnSaleWidgetState extends State<OnSaleWidget> {
  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    final productModel = Provider.of<ProductModel>(context);
    Size size = Utils(context).getScreenSize;
    final cartProvider = Provider.of<CartProvider>(context);
    bool? isInCart = cartProvider.getCartItems.containsKey(productModel.id);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    bool? isInWishlist =
        wishlistProvider.getWishlistItems.containsKey(productModel.id);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: AppColors.shadeColor,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.pushNamed(context, ProductDetails.routeName,
                arguments: productModel.id);
            // GlobalMethods.navigateTo(
            //     ctx: context, routeName: ProductDetails.routeName);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FancyShimmerImage(
                    imageUrl: productModel.imageUrl,
                    height: 80,
                    width: size.width * 0.22,
                    boxFit: BoxFit.fill,
                  ),
                  Column(
                    children: [
                      TextWidget(
                        text: productModel.isPiece ? '1Piece' : '1KG',
                        color: color,
                        textSize: 16,
                        isTitle: true,
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                    ],
                  )
                ],
              ),
              const Gap(10),
              PriceWidget(
                salePrice: productModel.salePrice,
                price: productModel.price,
                textPrice: '1',
                isOnSale: true,
              ),
              const SizedBox(height: 5),
              TextWidget(
                text: productModel.title,
                color: color,
                textSize: 16,
                isTitle: true,
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  SizedBox(
                    width: 100,
                    height: 30,
                    child: GestureDetector(
                      onTap: isInCart
                          ? null
                          : () async {
                              final User? user = authInstance.currentUser;

                              if (user == null) {
                                GlobalMethods.errorDialog(
                                    subtitle:
                                        'No user found, Please login first',
                                    context: context);
                                return;
                              }
                              await GlobalMethods.addToCart(
                                  productId: productModel.id,
                                  quantity: 1,
                                  context: context);
                              await cartProvider.fetchCart();
                              // cartProvider.addProductsToCart(
                              //     productId: productModel.id,
                              //     quantity: 1);
                            },
                      child: CustomButton(
                        text: isInCart ? 'In Cart' : 'Add to cart',
                        color: isInCart ? Colors.green : AppColors.accentColor,
                      ),
                    ),
                  ),
                  const Gap(10),
                  HeartBTN(
                    productId: productModel.id,
                    isInWishlist: isInWishlist,
                  )
                ],
              ),
              const SizedBox(height: 5),
            ]),
          ),
        ),
      ),
    );
  }
}
