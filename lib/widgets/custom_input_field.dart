import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {

  final String? labelText;
  final String? initialValue;
  final String? hintText;
  final String? helperText;
  final int? maxLines;
  final int? minLines;
  final IconData? icon;
  final TextInputType? keyboardType;
  final bool isPassword;
  final Color color;

  final Function validator;
  final Function onChange;

  const CustomInputField({
    Key? key, 
    this.labelText, 
    this.initialValue, 
    this.hintText, 
    this.helperText, 
    this.icon,
    this.keyboardType, 
    this.maxLines, 
    this.minLines, 
    this.isPassword = false, 
    required this.color, 
    required this.validator, 
    required this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      minLines: minLines != null ? minLines : 1,
      maxLines: maxLines != null ? maxLines : 1,
      initialValue: initialValue != null ? initialValue : '',
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