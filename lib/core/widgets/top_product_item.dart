import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/core/utils/colors.dart';
import 'package:grocery_app/core/widgets/price_widget.dart';
import 'package:grocery_app/core/widgets/text_widget.dart';
import 'package:grocery_app/models/products_model.dart';
import 'package:grocery_app/providers/cart_provider.dart';
import 'package:provider/provider.dart';

import '../../inner_screens/product_details.dart';
import '../../providers/wishlist_provider.dart';
import '../consts/firebase_consts.dart';
import '../services/global_methods.dart';
import '../services/utils.dart';
import 'heart_btn.dart';

class TopProductItem extends StatefulWidget {
  const TopProductItem({super.key, required this.productModel});
  final ProductsModel productModel;

  @override
  State<TopProductItem> createState() => _TopProductItemState();
}

class _TopProductItemState extends State<TopProductItem> {
  final _quantityTextController = TextEditingController();
  @override
  void initState() {
    _quantityTextController.text = '1';
    super.initState();
  }

  @override
  void dispose() {
    _quantityTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    final cartProvider = Provider.of<CartProvider>(context);
    bool? isInCart =
        cartProvider.getCartItems.containsKey(widget.productModel.id);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    bool? isInWishlist =
        wishlistProvider.getWishlistItems.containsKey(widget.productModel.id);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).cardColor,
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, ProductDetails.routeName,
                arguments: widget.productModel.id);
          },
          borderRadius: BorderRadius.circular(12),
          child: Column(children: [
            FancyShimmerImage(
              imageUrl: widget.productModel.imageUrl,
              height: 100,
              width: 100,
              boxFit: BoxFit.fill,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 3,
                    child: TextWidget(
                      text: widget.productModel.title,
                      color: color,
                      maxLines: 1,
                      textSize: 18,
                      isTitle: true,
                    ),
                  ),
                  Flexible(
                      flex: 1,
                      child: HeartBTN(
                        productId: widget.productModel.id,
                        isInWishlist: isInWishlist,
                      )),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 3,
                    child: PriceWidget(
                      salePrice: widget.productModel.salePrice,
                      price: widget.productModel.price,
                      textPrice: _quantityTextController.text,
                      isOnSale: widget.productModel.isOnSale,
                    ),
                  ),
                  Flexible(
                    child: Row(
                      children: [
                        Flexible(
                          flex: 6,
                          child: FittedBox(
                            child: TextWidget(
                              text:
                                  widget.productModel.isPiece ? 'Piece' : 'kg',
                              color: color,
                              textSize: 18,
                              isTitle: true,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: isInCart
                    ? null
                    : () async {
                        // if (_isInCart) {
                        //   return;
                        // }
                        final User? user = authInstance.currentUser;

                        if (user == null) {
                          GlobalMethods.errorDialog(
                              subtitle: 'No user found, Please login first',
                              context: context);
                          return;
                        }
                        await GlobalMethods.addToCart(
                            productId: widget.productModel.id,
                            quantity: int.parse(_quantityTextController.text),
                            context: context);
                        await cartProvider.fetchCart();
                        // cartProvider.addProductsToCart(
                        //     productId: widget.productModel.id,
                        //     quantity: int.parse(_quantityTextController.text));
                      },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        isInCart ? AppColors.primary : AppColors.accentColor),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(12.0),
                          bottomRight: Radius.circular(12.0),
                        ),
                      ),
                    )),
                child: TextWidget(
                  text: isInCart ? 'In cart' : 'Add to cart',
                  maxLines: 1,
                  color: color,
                  textSize: 18,
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
