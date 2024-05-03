import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grocery_app/core/utils/app_text_styles.dart';
import 'package:grocery_app/core/utils/colors.dart';
import 'package:grocery_app/screens/admin/home/widgets/order_item.dart';

class AdminWalletView extends StatefulWidget {
  const AdminWalletView({super.key});

  @override
  State<AdminWalletView> createState() => AdminWalletViewState();
}

class AdminWalletViewState extends State<AdminWalletView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check Orders'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('orders')
                .orderBy('orderDate', descending: true)
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

                      return Column(
                        children: [
                          OrderItem(
                            imageUrl: item['imageUrl'],
                            price: item['price'],
                            productName: item['productName'],
                            name: item['userName'],
                            quntity: item['quantity'].toString(),
                            date: item['orderDate'].toString(),
                          ),
                        ],
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
