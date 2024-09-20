import 'package:flutter/material.dart';

final hintStyle = TextStyle(
  color: Colors.grey.shade600,
  fontSize: 14,
  fontWeight: FontWeight.w400,
);

class DropdownDecoration {
  final TextStyle? labelTextStyle;
  final TextStyle? hintTextStyle;
  final TextStyle? dropdownTextStyle;
  final TextStyle? errorMessageTextStyle;
  final Color? outlineBorderColor;
  final Color? borderColor;
  final Color? errorBorderColor;
  final double fieldHeight;
  final BorderRadius? borderRadius;

  const DropdownDecoration({
    this.labelTextStyle,
    this.hintTextStyle,
    this.errorMessageTextStyle,
    this.outlineBorderColor,
    this.borderColor,
    this.errorBorderColor,
    this.fieldHeight = 52,
    this.borderRadius,
    this.dropdownTextStyle = const TextStyle(
      fontSize: 14,
    ),
  });
}
