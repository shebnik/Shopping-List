import 'package:flutter/material.dart';

class AppTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isDisabled;

  const AppTextButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isDisabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(
        text,
        style: TextStyle(
          color: isDisabled ? Colors.black.withOpacity(0.35) : Colors.teal,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
      onPressed: isDisabled ? null : onPressed,
    );
  }
}
