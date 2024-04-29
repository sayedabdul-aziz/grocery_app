import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/core/utils/app_text_styles.dart';
import 'package:grocery_app/core/utils/colors.dart';

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      fontFamily: GoogleFonts.poppins().fontFamily,
      scaffoldBackgroundColor: AppColors.darkScaffoldbg,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkScaffoldbg,
        foregroundColor: AppColors.primary,
        titleTextStyle: getbodyStyle(fontSize: 20, color: AppColors.primary),
        centerTitle: true,
      ),
      datePickerTheme: DatePickerThemeData(
          backgroundColor: AppColors.darkScaffoldbg,
          headerBackgroundColor: AppColors.primary,
          headerForegroundColor: AppColors.white),
      colorScheme: ColorScheme.fromSeed(
        primary: AppColors.primary,
        background: AppColors.darkScaffoldbg,
        error: Colors.red,
        secondary: AppColors.shadeColor,
        onSurface: AppColors.white,
        seedColor: AppColors.shadeColor,
      ),
      inputDecorationTheme: InputDecorationTheme(
        contentPadding:
            const EdgeInsets.only(left: 10, top: 10, bottom: 10, right: 10),
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
    );
  }
}
