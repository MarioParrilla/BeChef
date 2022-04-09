import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {

  final String? labelText;
  final String? hintText;
  final String? helperText;
  final IconData? icon;
  final TextInputType? keyboardType;
  final bool isPassword;
  final Color color;

  final Function validator;
  final Function onChange;

  const CustomInputField({
    Key? key, 
    this.labelText, 
    this.hintText, 
    this.helperText, 
    this.icon,
    this.keyboardType, 
    this.isPassword = false, 
    required this.color, 
    required this.validator, 
    required this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autocorrect: false,
      keyboardType: keyboardType ?? TextInputType.text,
      obscureText: isPassword,
      onChanged: (value) => onChange(value),
      validator: (value) => validator(value),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.black54),
        helperText: helperText,
        prefixIcon: icon == null ? null : Icon(icon, color: color),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: color
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: color
          )
        ),
      ),
    );
  }
}