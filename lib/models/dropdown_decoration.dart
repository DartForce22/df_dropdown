import 'package:flutter/material.dart';

/// A class to define and customize the visual appearance of a dropdown widget.
///
/// This class provides customizable styling options for different aspects
/// of a dropdown field such as text styles, border colors, and field height.
class DropdownDecoration {
  /// Text style for the label of the dropdown field.
  ///
  /// This style is applied to the label that is typically displayed above the dropdown.
  final TextStyle? labelTextStyle;

  /// Text style for the hint text displayed inside the dropdown.
  ///
  /// This style is used when no value is selected and a placeholder hint is shown.
  final TextStyle? hintTextStyle;

  /// Text style for the items displayed within the dropdown menu.
  ///
  /// This style defines how the dropdown items will appear.
  final TextStyle? dropdownTextStyle;

  /// Text style for displaying error messages below the dropdown field.
  ///
  /// This style is applied when an error message is shown, such as validation errors.
  final TextStyle? errorMessageTextStyle;

  /// Color for the outline border of the dropdown field.
  ///
  /// This color is used when the dropdown field is focused or in an active state.
  final Color? outlineBorderColor;

  /// Color for the border of the dropdown field in its normal state.
  ///
  /// This color is applied when the dropdown field is enabled and not focused.
  final Color? borderColor;

  /// Color for the dropdown field background, default is `transparent`.
  ///.
  final Color? backgroundColor;

  /// Color for the border of the dropdown field when an error occurs.
  ///
  /// This color is applied when the dropdown field displays an error.
  final Color? errorBorderColor;

  /// Height of the dropdown field.
  ///
  /// The height of the field can be customized using this value. Default is `52`.
  final double fieldHeight;

  /// The border radius for the dropdown field.
  ///
  /// This allows customizing the corners of the dropdown field with a specific radius.
  final BorderRadius? borderRadius;

  ///Indicator wether validation error container will be present even
  ///there is no error to display
  ///
  ///Default is `true`
  final bool reserveSpaceForValidationMessage;

  /// Creates a new [DropdownDecoration] instance with optional customization.
  ///
  /// - [labelTextStyle]: Style for the label text.
  /// - [hintTextStyle]: Style for the hint text.
  /// - [dropdownTextStyle]: Style for the text inside the dropdown items (default font size is `14`).
  /// - [errorMessageTextStyle]: Style for error messages.
  /// - [outlineBorderColor]: Color for the outline border.
  /// - [borderColor]: Color for the normal state border.
  /// - [errorBorderColor]: Color for the error state border.
  /// - [fieldHeight]: Height of the dropdown field (default is `52`).
  /// - [borderRadius]: Border radius for rounded corners.
  /// - [backgroundColor]: Color for the dropdown background.
  /// - [reserveSpaceForValidationMessage]: Indicator wether validation error container will be present
  /// even  there is no error to display
  ///
  const DropdownDecoration({
    this.labelTextStyle,
    this.hintTextStyle,
    this.errorMessageTextStyle,
    this.outlineBorderColor,
    this.borderColor,
    this.errorBorderColor,
    this.fieldHeight = 52,
    this.borderRadius,
    this.backgroundColor,
    this.reserveSpaceForValidationMessage = true,
    this.dropdownTextStyle = const TextStyle(
      fontSize: 14,
    ),
  });
}
