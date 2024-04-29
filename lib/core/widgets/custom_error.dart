import 'package:flutter/material.dart';

showErrorDialog(BuildContext context, error, [Color? color]) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: color ?? Colors.red,
      content: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          child: Text(error))));
}
