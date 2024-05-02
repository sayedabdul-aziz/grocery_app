import 'package:flutter/material.dart';
import 'package:grocery_app/core/widgets/custom_button.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({
    super.key,
    required this.fct,
    required this.buttonText,
    this.primary = Colors.white38,
  });
  final Function() fct;
  final String buttonText;
  final Color primary;
  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: buttonText,
      onTap: fct,
    );
  }
}
