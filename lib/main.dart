import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/core/utils/app_text_styles.dart';
import 'package:grocery_app/core/utils/colors.dart';
import 'package:grocery_app/fetch_screen.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:grocery_app/inner_screens/on_sale_screen.dart';
import 'package:grocery_app/providers/orders_provider.dart';
import 'package:grocery_app/providers/products_provider.dart';
import 'package:grocery_app/providers/viewed_prod_provider.dart';
import 'package:grocery_app/screens/customer/viewed_recently/viewed_recently.dart';
import 'package:provider/provider.dart';

import 'inner_screens/cat_screen.dart';
import 'inner_screens/feeds_screen.dart';
import 'inner_screens/product_details.dart';
import 'providers/cart_provider.dart';
import 'providers/wishlist_provider.dart';
import 'screens/auth/forget_pass.dart';
import 'screens/auth/login.dart';
import 'screens/auth/register.dart';
import 'screens/customer/orders/orders_screen.dart';
import 'screens/customer/wishlist/wishlist_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBqMewmQiRz5Bg3Z0qP0Hb4XKii61JpM8k",
      appId: "com.example.grocery_app",
      messagingSenderId: "441312537994",
      projectId: "grocery-app-771e8",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProductsProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CartProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => WishlistProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ViewedProdProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => OrdersProvider(),
        ),
      ],
      child: MaterialApp(
          theme: ThemeData(
            fontFamily: 'NunitoSans',
            scaffoldBackgroundColor: AppColors.darkScaffoldbg,
            appBarTheme: AppBarTheme(
              backgroundColor: AppColors.darkScaffoldbg,
              foregroundColor: AppColors.primary,
              titleTextStyle:
                  getbodyStyle(fontSize: 20, color: AppColors.primary),
              centerTitle: true,
            ),
            datePickerTheme: DatePickerThemeData(
                backgroundColor: AppColors.darkScaffoldbg,
                headerBackgroundColor: AppColors.primary,
                headerForegroundColor: AppColors.white),
            cardColor: AppColors.shadeColor,
            colorScheme: ColorScheme.fromSeed(
              primary: AppColors.primary,
              background: AppColors.darkScaffoldbg,
              error: Colors.red,
              secondary: AppColors.shadeColor,
              onSurface: AppColors.white,
              seedColor: AppColors.shadeColor,
            ),
            inputDecorationTheme: InputDecorationTheme(
              contentPadding: const EdgeInsets.only(
                  left: 10, top: 10, bottom: 10, right: 10),
              enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: AppColors.shadeColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: AppColors.shadeColor),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: AppColors.redColor),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: AppColors.redColor),
              ),
              hintStyle: getsmallStyle(),
              suffixIconColor: AppColors.primary,
              prefixIconColor: AppColors.primary,
            ),
            dividerTheme: DividerThemeData(
              color: AppColors.white,
              indent: 10,
              endIndent: 10,
            ),
            progressIndicatorTheme:
                ProgressIndicatorThemeData(color: AppColors.primary),
          ),
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          home: const FetchScreen(),
          routes: {
            OnSaleScreen.routeName: (ctx) => const OnSaleScreen(),
            FeedsScreen.routeName: (ctx) => const FeedsScreen(),
            ProductDetails.routeName: (ctx) => const ProductDetails(),
            WishlistScreen.routeName: (ctx) => const WishlistScreen(),
            OrdersScreen.routeName: (ctx) => const OrdersScreen(),
            ViewedRecentlyScreen.routeName: (ctx) =>
                const ViewedRecentlyScreen(),
            RegisterScreen.routeName: (ctx) => const RegisterScreen(),
            LoginScreen.routeName: (ctx) => const LoginScreen(),
            ForgetPasswordScreen.routeName: (ctx) =>
                const ForgetPasswordScreen(),
            CategoryScreen.routeName: (ctx) => const CategoryScreen(),
          }),
    );
  }
}
