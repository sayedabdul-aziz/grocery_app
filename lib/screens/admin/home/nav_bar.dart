import 'package:flutter/material.dart';
import 'package:grocery_app/core/utils/colors.dart';
import 'package:grocery_app/screens/admin/home/home_view.dart';
import 'package:grocery_app/screens/admin/wallet/wallet_view.dart';

class AdminNavBarView extends StatefulWidget {
  const AdminNavBarView({super.key});

  @override
  State<AdminNavBarView> createState() => _AdminNavBarViewState();
}

class _AdminNavBarViewState extends State<AdminNavBarView> {
  int _selectedIndex = 0;
  final List _page = [
    const AdminHomeView(),
    const AdminWalletView(),
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
                    icon: const Icon(Icons.wallet),
                    color: _selectedIndex == 1
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
