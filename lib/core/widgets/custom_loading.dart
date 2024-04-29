import 'package:flutter/material.dart';
import 'package:grocery_app/core/utils/colors.dart';

showLoaderDialog(BuildContext context) {
  showDialog(
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(.7),
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(
              color: AppColors.accentColor,
            ),
            Container(
                margin: const EdgeInsets.only(left: 15),
                child: const Text("Loading...")),
          ],
        ),
      );
    },
  );
}
