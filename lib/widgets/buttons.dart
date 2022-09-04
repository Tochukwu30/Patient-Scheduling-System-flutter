import 'package:flutter/material.dart';

class FormButton extends StatefulWidget {
  const FormButton(
      {Key? key,
      required this.onPressed,
      this.backgroundColor = Colors.purple,
      this.padding,
      this.text = "Form Button",
      this.child})
      : super(key: key);
  final void Function()? onPressed;
  final Color? backgroundColor;
  final EdgeInsets? padding;
  final String text;
  final Widget? child;

  @override
  State<FormButton> createState() => _FormButtonState();
}

class _FormButtonState extends State<FormButton> {
  @override
  Widget build(BuildContext context) {
    var vw = MediaQuery.of(context).size.width;
    return TextButton(
      onPressed: widget.onPressed,
      style: TextButton.styleFrom(
        backgroundColor: widget.backgroundColor,
        padding: EdgeInsets.symmetric(
          vertical: 20.0,
          horizontal: vw > 250 ? 80.0 : 0.2 * vw,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      child: widget.child != null
          ? widget.child!
          : Text(
              widget.text,
              style: TextStyle(
                fontSize: vw > 250 ? 20.0 : 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
    );
  }
}
