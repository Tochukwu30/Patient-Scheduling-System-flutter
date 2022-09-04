import 'package:flutter/material.dart';
import 'package:pss/utils.dart';

class PasswordField extends StatefulWidget {
  const PasswordField(
      {Key? key, this.labelText, this.controller, this.validator})
      : super(key: key);
  final String? labelText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: !_showPassword,
      autocorrect: false,
      decoration: InputDecoration(
        labelText: widget.labelText,
        prefixIcon: const Icon(
          Icons.lock_open_outlined,
        ),
        suffixIcon: IconButton(
          icon: _showPassword
              ? const Icon(Icons.visibility_off_outlined)
              : const Icon(Icons.visibility_outlined),
          onPressed: () {
            setState(() {
              _showPassword = !_showPassword;
            });
          },
        ),
      ),
      validator: widget.validator ?? validateEmpty,
    );
  }
}
