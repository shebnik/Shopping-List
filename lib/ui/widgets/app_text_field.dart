import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    Key? key,
    required this.controller,
    required this.label,
    this.hint = '',
    this.showError = false,
    this.isPassword = false,
    this.errorText,
    this.focusNode,
    this.prefixIcon,
    this.accountToggle,
  }) : super(key: key);

  final TextEditingController controller;
  final String label;
  final String hint;
  final bool showError;
  final bool isPassword;
  final String? errorText;
  final FocusNode? focusNode;
  final Icon? prefixIcon;
  final VoidCallback? accountToggle;

  @override
  Widget build(BuildContext context) {
    var _obscureText = ValueNotifier<bool>(true);
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: ValueListenableBuilder(
        valueListenable: _obscureText,
        builder: (context, value, child) {
          return TextField(
            focusNode: focusNode,
            controller: controller,
            obscureText: isPassword ? _obscureText.value : false,
            decoration: InputDecoration(
              labelText: label,
              isDense: true,
              hintText: hint,
              errorText: showError ? errorText : null,
              prefixIcon: prefixIcon,
              suffixIcon: isPassword
                  ? GestureDetector(
                      dragStartBehavior: DragStartBehavior.down,
                      onTap: () => _obscureText.value = !_obscureText.value,
                      child: Icon(
                        _obscureText.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                    )
                  : null,
            ),
          );
        },
      ),
    );
  }
}
