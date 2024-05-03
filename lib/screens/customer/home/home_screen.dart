import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:gap/gap.dart';
import 'package:grocery_app/core/consts/navigation.dart';
import 'package:grocery_app/core/services/utils.dart';
import 'package:grocery_app/core/utils/app_text_styles.dart';
import 'package:grocery_app/core/utils/colors.dart';
import 'package:grocery_app/core/widgets/text_widget.dart';
import 'package:grocery_app/core/widgets/top_product_item.dart';
import 'package:grocery_app/inner_screens/feeds_screen.dart';
import 'package:grocery_app/inner_screens/on_sale_screen.dart';
import 'package:grocery_app/screens/customer/notification/notification_view.dart';
import 'package:provider/provider.dart';

import '../../../core/consts/contss.dart';
import '../../../core/services/global_methods.dart';
import '../../../core/widgets/on_sale_widget.dart';
import '../../../models/products_model.dart';
import '../../../providers/products_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final Utils utils = Utils(context);
    final Color color = Utils(context).color;
    Size size = utils.getScreenSize;
    final productProviders = Provider.of<ProductsProvider>(context);
    List<ProductModel> allProducts = productProviders.getProducts;
    List<ProductModel> productsOnSale = productProviders.getOnSaleProducts;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(
                height: size.height * 0.02,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Hi, ${FirebaseAuth.instance.currentUser?.displayName} 👋',
                            style: getHeadlineStyle(fontSize: 22)),
                        Text('Order Your Product Now!',
                            style: getsmallStyle(fontSize: 14)),
                      ],
                    ),
                    const Spacer(),
                    IconButton.outlined(
                        onPressed: () {
                          navigateTo(context, const CustomerNotificationView());
                        },
                        color: AppColors.accentColor,
                        icon: const Icon(Icons.notifications_active)),
                  ],
                ),
              ),
              const Gap(15),
              SizedBox(
                height: size.height * 0.25,
                width: size.width * .9,
                child: Swiper(
                  itemBuilder: (BuildContext context, int index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Image.asset(
                        Constss.offerImages[index],
                        fit: BoxFit.fill,
                      ),
                    );
                  },
                  autoplay: true,
                  itemCount: Constss.offerImages.length,
                  pagination: SwiperPagination(
                      alignment: Alignment.bottomCenter,
                      builder: DotSwiperPaginationBuilder(
                          color: Colors.white, activeColor: AppColors.primary)),
                  // control: const SwiperControl(color: Colors.black),
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              TextButton(
                onPressed: () {
                  GlobalMethods.navigateTo(
                      ctx: context, routeName: OnSaleScreen.routeName);
                },
                child: TextWidget(
                  text: 'View all',
                  maxLines: 1,
                  color: AppColors.primary,
                  textSize: 20,
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              Row(
                children: [
                  RotatedBox(
                    quarterTurns: -1,
                    child: Row(
                      children: [
                        TextWidget(
                          text: 'On sale'.toUpperCase(),
                          color: Colors.red,
                          textSize: 22,
                          isTitle: true,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        const Icon(
                          IconlyLight.discount,
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Flexible(
                    child: SizedBox(
                      height: 220,
                      child: ListView.builder(
                          itemCount: productsOnSale.length < 10
                              ? productsOnSale.length
                              : 10,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (ctx, index) {
                            return ChangeNotifierProvider.value(
                                value: productsOnSale[index],
                                child: const OnSaleWidget());
                          }),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextWidget(
                      text: 'Top Products',
                      color: color,
                      textSize: 22,
                      isTitle: true,
                    ),
                    // const Spacer(),
                    TextButton(
                      onPressed: () {
                        GlobalMethods.navigateTo(
                            ctx: context, routeName: FeedsScreen.routeName);
                      },
                      child: TextWidget(
                        text: 'Browse all',
                        maxLines: 1,
                        color: AppColors.primary,
                        textSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('products')
                      .orderBy('orderCount', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    var products = snapshot.data?.docs;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 60),
                      child: GridView.builder(
                          itemCount: products!.length < 8 ? products.length : 8,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisExtent: 240,
                          ),
                          itemBuilder: (context, index) => TopProductItem(
                                productModel: ProductsModel.fromJson(
                                    products[index].data()),
                              )),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
