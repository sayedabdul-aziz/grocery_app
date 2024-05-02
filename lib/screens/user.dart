import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_app/core/consts/firebase_consts.dart';
import 'package:grocery_app/core/services/global_methods.dart';
import 'package:grocery_app/core/utils/app_text_styles.dart';
import 'package:grocery_app/core/utils/colors.dart';
import 'package:grocery_app/core/widgets/text_widget.dart';
import 'package:grocery_app/screens/auth/forget_pass.dart';
import 'package:grocery_app/screens/customer/orders/orders_screen.dart';
import 'package:grocery_app/screens/customer/viewed_recently/viewed_recently.dart';
import 'package:grocery_app/screens/customer/wishlist/wishlist_screen.dart';
import 'package:grocery_app/screens/loading_manager.dart';

import 'auth/login.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final TextEditingController _addressTextController =
      TextEditingController(text: "");
  @override
  void dispose() {
    _addressTextController.dispose();
    super.dispose();
  }

  String? _email;
  String? _name;
  String? address;
  bool _isLoading = false;
  final User? user = authInstance.currentUser;
  @override
  void initState() {
    getUserData();
    super.initState();
  }

  Future<void> getUserData() async {
    setState(() {
      _isLoading = true;
    });
    if (user == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }
    try {
      String uid = user!.uid;

      final DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      _email = userDoc.get('email');
      _name = userDoc.get('name');
      address = userDoc.get('shipping-address');
      _addressTextController.text = userDoc.get('shipping-address');
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      GlobalMethods.errorDialog(subtitle: '$error', context: context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color color = Colors.white;
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(
            'Profile',
            style: getTitleStyle(fontSize: 20),
          ),
        ),
        body: LoadingManager(
          isLoading: _isLoading,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.account_circle_rounded,
                        size: 80,
                        color: color,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: 'Hi,  ',
                              style: getTitleStyle(),
                              children: [
                                TextSpan(
                                    text: _name ?? 'user',
                                    style: getTitleStyle(
                                        fontSize: 20, color: AppColors.primary),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {}),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          TextWidget(
                            text: _email == null ? 'Email' : _email!,
                            color: color,
                            textSize: 16,
                            // isTitle: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Divider(
                    thickness: 2,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  _listTiles(
                    title: 'Address 2',
                    subtitle: address,
                    icon: IconlyLight.profile,
                    onPressed: () async {
                      await _showAddressDialog();
                    },
                    color: color,
                  ),
                  _listTiles(
                    title: 'Orders',
                    icon: IconlyLight.bag,
                    onPressed: () {
                      GlobalMethods.navigateTo(
                          ctx: context, routeName: OrdersScreen.routeName);
                    },
                    color: color,
                  ),
                  _listTiles(
                    title: 'Wishlist',
                    icon: IconlyLight.heart,
                    onPressed: () {
                      GlobalMethods.navigateTo(
                          ctx: context, routeName: WishlistScreen.routeName);
                    },
                    color: color,
                  ),
                  _listTiles(
                    title: 'Viewed',
                    icon: IconlyLight.show,
                    onPressed: () {
                      GlobalMethods.navigateTo(
                          ctx: context,
                          routeName: ViewedRecentlyScreen.routeName);
                    },
                    color: color,
                  ),
                  _listTiles(
                    title: 'Forget password',
                    icon: IconlyLight.unlock,
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ForgetPasswordScreen(),
                        ),
                      );
                    },
                    color: color,
                  ),

                  _listTiles(
                    title: user == null ? 'Login' : 'Logout',
                    icon: user == null ? IconlyLight.login : IconlyLight.logout,
                    onPressed: () {
                      if (user == null) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                        return;
                      }
                      GlobalMethods.warningDialog(
                          title: 'Sign out',
                          subtitle: 'Do you wanna sign out?',
                          fct: () async {
                            await authInstance.signOut();
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                          context: context);
                    },
                    color: color,
                  ),
                  // listTileAsRow(),
                ],
              ),
            ),
          ),
        ));
  }

  Future<void> _showAddressDialog() async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Update'),
            content: TextField(
              // onChanged: (value) {
              //   print('_addressTextController.text ${_addressTextController.text}');
              // },
              controller: _addressTextController,
              maxLines: 5,
              decoration: const InputDecoration(hintText: "Your address"),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  String uid = user!.uid;
                  try {
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(uid)
                        .update({
                      'shipping-address': _addressTextController.text,
                    });

                    Navigator.pop(context);
                    setState(() {
                      address = _addressTextController.text;
                    });
                  } catch (err) {
                    GlobalMethods.errorDialog(
                        subtitle: err.toString(), context: context);
                  }
                },
                child: const Text('Update'),
              ),
            ],
          );
        });
  }

  Widget _listTiles({
    required String title,
    String? subtitle,
    required IconData icon,
    required Function onPressed,
    required Color color,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      title: TextWidget(
        text: title,
        color: color,
        textSize: 18,
        // isTitle: true,
      ),
      leading: Icon(
        icon,
        color: AppColors.primary,
      ),
      trailing: Icon(
        IconlyLight.arrowRight2,
        color: AppColors.primary,
      ),
      onTap: () {
        onPressed();
      },
    );
  }

// // Alternative code for the listTile.
//   Widget listTileAsRow() {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Row(
//         children: <Widget>[
//           const Icon(Icons.settings),
//           const SizedBox(width: 10),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: const [
//               Text('Title'),
//               Text('Subtitle'),
//             ],
//           ),
//           const Spacer(),
//           const Icon(Icons.chevron_right)
//         ],
//       ),
//     );
//   }
}
