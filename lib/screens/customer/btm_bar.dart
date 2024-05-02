import 'package:flutter/material.dart';
import 'package:grocery_app/core/utils/colors.dart';
import 'package:grocery_app/screens/customer/cart/cart_screen.dart';
import 'package:grocery_app/screens/customer/home_screen.dart';
import 'package:grocery_app/screens/customer/wishlist/wishlist_screen.dart';
import 'package:grocery_app/screens/user.dart';

class CustomerNavBarView extends StatefulWidget {
  const CustomerNavBarView({super.key});

  @override
  State<CustomerNavBarView> createState() => _CustomerNavBarViewState();
}

class _CustomerNavBarViewState extends State<CustomerNavBarView> {
  int _selectedIndex = 0;
  final List _page = [
    const HomeScreen(),
    const WishlistScreen(),
    const CartScreen(),
    const UserScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _page[_selectedIndex],
          Positioned(
            bottom: 15,
            left: 40,
            right: 40,
            child: Container(
              height: 55,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.bottomBarColor,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    enableFeedback: false,
                    onPressed: () {
                      setState(() {
                        _selectedIndex = 0;
                      });
                    },
                    icon: Icon(
                      Icons.home_outlined,
                      size: 25,
                      color: _selectedIndex == 0
                          ? AppColors.primary
                          : AppColors.white,
                    ),
                  ),
                  IconButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    enableFeedback: false,
                    onPressed: () {
                      setState(() {
                        _selectedIndex = 1;
                      });
                    },
                    icon: const Icon(Icons.favorite),
                    color: _selectedIndex == 1
                        ? AppColors.primary
                        : AppColors.white,
                  ),
                  IconButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    enableFeedback: false,
                    onPressed: () {
                      setState(() {
                        _selectedIndex = 2;
                      });
                    },
                    icon: const Icon(Icons.shopping_cart),
                    color: _selectedIndex == 2
                        ? AppColors.primary
                        : AppColors.white,
                  ),
                  IconButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    enableFeedback: false,
                    onPressed: () {
                      setState(() {
                        _selectedIndex = 3;
                      });
                    },
                    icon: const Icon(Icons.person),
                    color: _selectedIndex == 3
                        ? AppColors.primary
                        : AppColors.white,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
