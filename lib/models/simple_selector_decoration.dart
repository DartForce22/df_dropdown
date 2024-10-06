import 'package:flutter/material.dart';

/// A class to define the decoration and styling for a simple selector widget.
///
/// This class provides customization options for the appearance of a simple selector
/// by allowing you to configure border radius, elevation, color, and text styles.
class SimpleSelectorDecoration {
  /// The border radius for the simple selector widget.
  ///
  /// This defines the rounding of the corners of the selector's border.
  final BorderRadius? borderRadius;

  /// The elevation of the simple selector widget.
  ///
  /// Elevation determines the shadow depth of the widget, with higher values producing more shadow.
  final double? elevation;

  /// The maximum height of the selector widget when it expands.
  ///
  /// This sets the upper limit on the vertical size of the selector dropdown.
  final double? maxHeight;

  /// The background color of the selector widget.
  ///
  /// This color is applied to the entire background of the selector.
  final Color? selectorColor;

  /// The background color of individual items in the selector dropdown.
  ///
  /// This color applies to each selectable option within the dropdown.
  final Color? itemColor;

  /// The text style for the options within the selector.
  ///
  /// This defines the appearance of the text in each dropdown option.
  final TextStyle? optionTextStyle;

  ///This is applied only when the [DfDropdownWrapper] widget is used
  final double? selectorWidth;

  final Widget? selectedItemIcon;

  final Color? selectedItemColor;

  /// Creates a new [SimpleSelectorDecoration] instance with optional customization.
  ///
  /// - [borderRadius]: Sets the border radius for the selector.
  /// - [elevation]: Adds shadow depth to the selector dropdown.
  /// - [maxHeight]: Restricts the maximum height of the selector when expanded.
  /// - [selectorColor]: Sets the background color for the selector dropdown.
  /// - [itemColor]: Defines the background color of each selectable item.
  /// - [optionTextStyle]: Specifies the text style for the dropdown options.
  /// - [selectedItemIcon]: Customizes the icon displayed next to the selected option.
  /// - [selectedItemColor]: Sets the background color for selected items.
  const SimpleSelectorDecoration({
    this.borderRadius,
    this.elevation,
    this.maxHeight,
    this.selectorColor,
    this.itemColor,
    this.optionTextStyle,
    this.selectorWidth,
    this.selectedItemIcon,
    this.selectedItemColor,
  });
}
