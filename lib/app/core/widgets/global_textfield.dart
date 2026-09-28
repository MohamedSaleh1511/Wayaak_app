import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wayaak/app/data/extensions/extensions.dart';

class GlobalTextField extends StatelessWidget {
  final String hintText;
  final String? prefixIcon;
  final String? suffixIcon;
  final String? suffixText;
  final VoidCallback? onSuffixTap;
  final bool obsecure;
  final TextInputType inputType;
  final List<TextInputFormatter>? textInputFormatters;
  final TextInputAction textInputAction;
  final Function(String?)? onSaved;
  final Function(String?)? onChanged;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final Color? suffixColor;
  final int maxLines;
  final double? contentPadding;
  final bool noBorder;
  final Color? fillColor;
  final VoidCallback? onTap;
  const GlobalTextField({
    super.key,
    required this.hintText,
    this.prefixIcon,
    this.suffixText,
    this.contentPadding,
    this.noBorder = false,
    this.onSuffixTap,
    this.onTap,
    this.onChanged,
    this.fillColor,
    this.textInputFormatters,
    this.suffixIcon,
    this.maxLines = 1,
    this.obsecure = false,
    this.inputType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.onSaved,
    this.validator,
    this.controller,
    this.suffixColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: TextFormField(
        onTap: onTap,
        readOnly: onTap != null,
        inputFormatters: textInputFormatters,
        controller: controller,
        obscureText: obsecure,
        keyboardType: inputType,
        textInputAction: textInputAction,
        onSaved: onSaved,
        validator: validator,
        onChanged: onChanged,
        maxLines: maxLines,
        decoration: CustomInputDecoration.decorate(
          hintText: hintText,
          prefixIcon: prefixIcon,
          onSuffixTap: onSuffixTap,
          contentPadding: contentPadding,
          noBorder: noBorder,
          suffixIcon: suffixIcon,
          suffixText: suffixText,
          suffixColor: suffixColor,
        ),
      ),
    );
  }
}
