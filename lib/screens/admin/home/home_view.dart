import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/core/consts/navigation.dart';
import 'package:grocery_app/core/utils/app_text_styles.dart';
import 'package:grocery_app/core/utils/colors.dart';
import 'package:grocery_app/core/widgets/custom_button.dart';
import 'package:grocery_app/models/products_model.dart';
import 'package:grocery_app/screens/admin/home/add_product.dart';
import 'package:grocery_app/screens/admin/home/widgets/product_item.dart';
import 'package:grocery_app/screens/auth/login.dart';

class AdminHomeView extends StatelessWidget {
  const AdminHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 25),
                Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Hi, Admin 👋',
                                    style: getHeadlineStyle(fontSize: 22)),
                                Text('Manage Your Orders Now!',
                                    style: getsmallStyle(fontSize: 14)),
                              ],
                            ),
                            const Spacer(),
                            IconButton.outlined(
                                onPressed: () async {
                                  await FirebaseAuth.instance
                                      .signOut()
                                      .then((value) {
                                    navigateAndRemoveUntil(
                                        context, const LoginScreen());
                                  });
                                },
                                color: AppColors.redColor,
                                icon: const Icon(Icons.login_rounded)),
                          ],
                        ),
                        const SizedBox(height: 30),
                        Row(children: [
                          // add hotel button
                          Expanded(
                            child: CustomButton(
                              color: AppColors.primary,
                              text: 'Add Product +',
                              onTap: () {
                                navigateTo(context, const AddProductView());
                              },
                            ),
                          ),
                        ]),
                      ],
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
                Text('All Products', style: getTitleStyle()),
                const SizedBox(height: 15),
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('products')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          mainAxisExtent: 250,
                        ),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          return Productitem(
                            productModel: ProductsModel.fromJson(
                                snapshot.data!.docs[index].data()),
                          );
                        },
                      );
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
