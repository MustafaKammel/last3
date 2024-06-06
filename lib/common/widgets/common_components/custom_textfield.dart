import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String? hint;
  final TextEditingController? textController;
  final Color textColor;
  final Color borderColor;
  final Color inputColor;

  const CustomTextField({
    super.key,
    required this.hint,
    this.textController,
    this.textColor = Colors.black,
    this.borderColor = Colors.black,
    this.inputColor = Colors.black,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.textController,
      cursorColor: Colors.white,
      style: TextStyle(color: widget.inputColor),
      decoration: InputDecoration(
        isDense: true,
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: widget.borderColor)),
        hintText: widget.hint,
        hintStyle: TextStyle(color: widget.textColor),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: widget.borderColor),
        ),
      ),
    );
  }
}
