import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grocery_app/core/utils/app_text_styles.dart';
import 'package:grocery_app/core/utils/colors.dart';
import 'package:grocery_app/core/widgets/custom_button.dart';
import 'package:grocery_app/screens/admin/home/widgets/resturent_item.dart';

class AdminWalletView extends StatefulWidget {
  const AdminWalletView({super.key});

  @override
  State<AdminWalletView> createState() => AdminWalletViewState();
}

class AdminWalletViewState extends State<AdminWalletView> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? user;

  Future<void> _getUser() async {
    user = _auth.currentUser;
  }

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Check Orders'),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            children: [
              TabBar(dividerHeight: 0, tabs: [
                Tab(
                  child: Text(
                    'Pending',
                    style: getbodyStyle(
                      fontSize: 16,
                      color: AppColors.white,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    'Accepted',
                    style: getbodyStyle(
                      fontSize: 16,
                      color: AppColors.white,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    'Cancelled',
                    style: getbodyStyle(
                      fontSize: 16,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ]),
              Expanded(
                  child: TabBarView(
                      children: List.generate(
                3,
                (index) => StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('restaurant-booking')
                        .where('status', isEqualTo: index)
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 20),
                          child: ListView.separated(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, i) {
                              var item = snapshot.data!.docs[i].data();

                              return Container(
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(15),
                                    ),
                                    color: AppColors.bottomBarColor,
                                    border: Border.all(
                                        color: AppColors.shadeColor)),
                                child: Column(
                                  children: [
                                    ResturentItem(
                                      imageUrl: item['restaurant']['cover'],
                                      name: item['restaurant']['name'],
                                      location: item['restaurant']['address'],
                                      rating: (item['restaurant']['rating'])
                                          .toString(),
                                    ),
                                    const Gap(10),
                                    Row(
                                      children: [
                                        Text(
                                          'Check In: ',
                                          style: getTitleStyle(
                                              color: AppColors.primary),
                                        ),
                                        Text(
                                          item['checkIn']
                                              .toString()
                                              .split(' ')[0],
                                          style: getbodyStyle(),
                                        ),
                                      ],
                                    ),
                                    const Gap(5),
                                    Row(
                                      children: [
                                        Text(
                                          'Meal Type: ',
                                          style: getTitleStyle(
                                              color: AppColors.primary),
                                        ),
                                        Text(
                                          item['mealTime']
                                              .toString()
                                              .split(' ')[0],
                                          style: getbodyStyle(),
                                        ),
                                      ],
                                    ),
                                    const Gap(5),
                                    Row(
                                      children: [
                                        Text(
                                          'No. of gests: ',
                                          style: getTitleStyle(
                                              color: AppColors.primary),
                                        ),
                                        Text(
                                          ' ${item['numberOfGuests'].toString()}',
                                          style:
                                              const TextStyle(fontSize: 16.0),
                                        ),
                                      ],
                                    ),
                                    if (index == 0)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 15),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: CustomButton(
                                                onTap: () {
                                                  cancelRestaurant(snapshot
                                                      .data!.docs[i].id);
                                                },
                                                height: 40,
                                                color: AppColors.redColor,
                                                text: 'Reject Booking',
                                              ),
                                            ),
                                            const Gap(20),
                                            Expanded(
                                              child: CustomButton(
                                                onTap: () {
                                                  accepteRestaurent(snapshot
                                                      .data!.docs[i].id);
                                                },
                                                height: 40,
                                                color: Colors.green,
                                                text: 'Accept Booking',
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                  ],
                                ),
                              );
                            },
                            separatorBuilder: (context, index) => const Gap(15),
                          ),
                        );
                      }
                    }),
              ))),
            ],
          ),
        ),
      ),
    );
  }

  accepteRestaurent(id) {
    FirebaseFirestore.instance
        .collection('restaurant-booking')
        .doc(id)
        .set({'status': 1}, SetOptions(merge: true));
  }

  cancelRestaurant(id) {
    FirebaseFirestore.instance
        .collection('restaurant-booking')
        .doc(id)
        .set({'status': 2}, SetOptions(merge: true));
  }
}
