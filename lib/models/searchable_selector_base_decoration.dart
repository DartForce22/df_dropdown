import 'package:flutter/material.dart';

class SearchableSelectorBaseDecoration {
  /// The border radius for the multi-selector widget.
  ///
  /// This property defines the corner radius of the multi-selector's border.
  final BorderRadius? borderRadius;

  /// The elevation of the multi-selector widget.
  ///
  /// This affects the shadow depth of the multi-selector. A higher value indicates more elevation.
  final double? elevation;

  /// The maximum height of the multi-selector when it expands.
  ///
  /// This sets a limit on how tall the multi-selector dropdown can grow.
  final double? maxHeight;

  /// The background color of the multi-selector widget.
  ///
  /// This color is applied to the background of the entire multi-selector dropdown.
  final Color? selectorColor;

  /// The background color of individual items in the multi-selector.
  ///
  /// This color is applied to each selectable item within the multi-selector dropdown.
  final Color? itemColor;

  /// The color of the divider between items in the multi-selector dropdown.
  ///
  /// This is used to visually separate each item with a line.
  final Color? dividerColor;

  /// The text style of each option in the multi-selector.
  ///
  /// This style defines how the text of the dropdown items will appear.
  final TextStyle? optionTextStyle;

  /// A custom icon for the search field in the multi-selector.
  ///
  /// This icon appears in the search field when the user wants to filter options.
  final Widget? searchIcon;

  /// Determines whether the search icon is displayed.
  ///
  /// This boolean controls the visibility of the search icon. Defaults to `true`.
  final bool showSearchIcon;

  /// The text style for the search input field.
  ///
  /// This style applies to the text entered in the search field when filtering options.
  final TextStyle? searchTextStyle;

  /// The text to display for clearing all selections.
  ///
  /// This text is shown as an option to clear all selected items in the multi-selector.
  final String? clearSelectionText;

  /// The text style for the clear selection option.
  ///
  /// This style defines how the "Clear Selection" text will appear.
  final TextStyle? clearSelectionTextStyle;

  /// The background color for selected items.
  ///
  /// This color is applied to items that are currently selected in the dropdown.
  final Color? selectedItemColor;

  /// Creates a new [SearchableSelectorBaseDecoration] instance with optional customization.
  ///
  /// - [borderRadius]: Sets the corner radius of the multi-selector.
  /// - [elevation]: Defines the shadow depth of the multi-selector dropdown.
  /// - [maxHeight]: Restricts the maximum height the multi-selector can expand to.
  /// - [selectorColor]: Sets the background color of the multi-selector.
  /// - [itemColor]: Sets the background color of individual items.
  /// - [dividerColor]: Defines the color of the divider between dropdown items.
  /// - [optionTextStyle]: Sets the style for the text inside dropdown options.
  /// - [searchIcon]: Customizes the search icon displayed in the search field.
  /// - [searchTextStyle]: Sets the style for text entered in the search field.
  /// - [clearSelectionText]: Defines the text to show for clearing selections.
  /// - [clearSelectionTextStyle]: Customizes the text style for the clear selection option.
  /// - [selectedItemColor]: Sets the background color for selected items.
  /// - [selectedItemIcon]: Customizes the icon displayed next to the selected option.

  const SearchableSelectorBaseDecoration({
    this.borderRadius,
    this.elevation,
    this.maxHeight,
    this.selectorColor,
    this.itemColor,
    this.dividerColor,
    this.optionTextStyle,
    this.searchIcon,
    this.searchTextStyle,
    this.clearSelectionText,
    this.clearSelectionTextStyle,
    this.selectedItemColor,
    this.showSearchIcon = true,
  });
}
