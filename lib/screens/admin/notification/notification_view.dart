import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grocery_app/core/consts/navigation.dart';
import 'package:grocery_app/core/utils/app_text_styles.dart';
import 'package:grocery_app/core/utils/colors.dart';
import 'package:grocery_app/models/products_model.dart';
import 'package:grocery_app/providers/products_provider.dart';
import 'package:grocery_app/screens/admin/home/add_product.dart';
import 'package:grocery_app/screens/admin/home/widgets/order_item.dart';
import 'package:provider/provider.dart';

class AdminNotificationView extends StatefulWidget {
  const AdminNotificationView({super.key});

  @override
  State<AdminNotificationView> createState() => AdminNotificationViewState();
}

class AdminNotificationViewState extends State<AdminNotificationView> {
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('offers')
                .orderBy('date', descending: true)
                .where('status', isEqualTo: '0')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.data?.docs.isEmpty == true) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.wallet,
                        size: 150,
                        color: AppColors.shadeColor,
                      ),
                      const Gap(20),
                      Text(
                        'No Items',
                        textAlign: TextAlign.center,
                        style: getbodyStyle(
                          fontSize: 16,
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  child: ListView.separated(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, i) {
                      var item = snapshot.data!.docs[i].data();

                      return InkWell(
                        onTap: () {
                          final getCurrProduct =
                              productProvider.findProdById(item['id']);
                          navigateTo(
                              context,
                              AddProductView(
                                model: ProductsModel(
                                    id: getCurrProduct.id,
                                    orderCount: getCurrProduct.orderCount,
                                    title: getCurrProduct.title,
                                    imageUrl: getCurrProduct.imageUrl,
                                    productCategoryName:
                                        getCurrProduct.productCategoryName,
                                    price: getCurrProduct.price,
                                    salePrice: getCurrProduct.salePrice,
                                    isOnSale: getCurrProduct.isOnSale,
                                    isPiece: getCurrProduct.isPiece),
                              ));
                        },
                        child: OrderItem(
                          imageUrl: item['imageUrl'],
                          price: item['price'].toStringAsFixed(2),
                          productName: item['productName'],
                          name: item['userName'],
                          date: ((item['date'] as Timestamp).toDate())
                              .toIso8601String()
                              .split('T')
                              .first,
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => const Gap(15),
                  ),
                );
              }
            }),
      ),
    );
  }
}
