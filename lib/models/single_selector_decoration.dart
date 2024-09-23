import 'package:flutter/material.dart';

import '/models/searchable_selector_base_decoration.dart';

/// A class to define and customize the appearance and behavior of a single-selection widget.
///
/// This class allows customization of various visual and interactive elements,
/// such as the search icon, colors, text styles, and more for a single-selector component.
class SingleSelectorDecoration extends SearchableSelectorBaseDecoration {
  ///Controls whether selected item icon indicator is visible (default is `true`).
  final bool? selectedItemIconVisible;

  ///Customizes the icon displayed next to the selected option.
  final Widget? selectedItemIcon;

  /// Creates a new [SingleSelectorDecoration] instance with optional customization.
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
  /// - [selectedItemIconVisible]: Controls whether selected item icon indicator is visible (default is `true`).
  /// - [showSearchIcon]: Controls whether the search icon is visible (default is `true`).

  const SingleSelectorDecoration({
    super.borderRadius,
    super.elevation,
    super.maxHeight,
    super.selectorColor,
    super.itemColor,
    super.dividerColor,
    super.optionTextStyle,
    super.searchIcon,
    super.searchTextStyle,
    super.clearSelectionText,
    super.clearSelectionTextStyle,
    super.showSearchIcon = true,
    super.selectedItemColor,
    this.selectedItemIconVisible = true,
    this.selectedItemIcon,
  });
}
