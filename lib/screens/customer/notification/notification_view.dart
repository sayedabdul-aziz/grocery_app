import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grocery_app/core/utils/app_text_styles.dart';
import 'package:grocery_app/core/utils/colors.dart';
import 'package:grocery_app/screens/customer/inner_screens/product_details.dart';
import 'package:grocery_app/providers/products_provider.dart';
import 'package:grocery_app/screens/admin/home/widgets/order_item.dart';
import 'package:provider/provider.dart';

class CustomerNotificationView extends StatefulWidget {
  const CustomerNotificationView({super.key});

  @override
  State<CustomerNotificationView> createState() =>
      CustomerNotificationViewState();
}

class CustomerNotificationViewState extends State<CustomerNotificationView> {
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
                .where('userId',
                    isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                .where('status', isEqualTo: '1')
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
                          Navigator.pushNamed(context, ProductDetails.routeName,
                              arguments: item['id']);
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
