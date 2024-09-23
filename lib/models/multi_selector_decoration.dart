import 'package:flutter/material.dart';

import '/models/searchable_selector_base_decoration.dart';

/// A class to define and customize the appearance and behavior of a multi-selection widget.
///
/// This class allows customization of various visual and interactive elements,
/// such as the search icon, colors, text styles, and more for a multi-selector component.
class MultiSelectorDecoration extends SearchableSelectorBaseDecoration {
  /// The title text for displaying selected items.
  ///
  /// This is the title shown when selected items are displayed.
  final String? selectedItemsTitle;

  /// The text style for the selected items title.
  ///
  /// This style defines how the selected items title text will appear.
  final TextStyle? selectedItemsTitleStyle;

  /// The background color for selected items.
  ///
  /// This color is applied to items that are currently selected in the dropdown.
  final Color? selectedItemColor;

  /// Determines whether to show the list of selected items.
  ///
  /// This boolean controls the visibility of the selected items. Defaults to `true`.
  final bool? showSelectedItems;

  /// Creates a new [MultiSelectorDecoration] instance with optional customization.
  ///
  /// - [borderRadius]: Sets the corner radius of the multi-selector.
  /// - [elevation]: Defines the shadow depth of the multi-selector dropdown.
  /// - [maxHeight]: Restricts the maximum height the multi-selector can expand to.
  /// - [selectorColor]: Sets the background color of the multi-selector.
  /// - [itemColor]: Sets the background color of individual items.
  /// - [dividerColor]: Defines the color of the divider between dropdown items.
  /// - [optionTextStyle]: Sets the style for the text inside dropdown options.
  /// - [searchIcon]: Customizes the search icon displayed in the search field.
  /// - [showSearchIcon]: Controls whether the search icon is visible (default is `true`).
  /// - [searchTextStyle]: Sets the style for text entered in the search field.
  /// - [clearSelectionText]: Defines the text to show for clearing selections.
  /// - [clearSelectionTextStyle]: Customizes the text style for the clear selection option.
  /// - [selectedItemsTitle]: Specifies the title text for selected items.
  /// - [selectedItemsTitleStyle]: Defines the style for the selected items title.
  /// - [selectedItemColor]: Sets the background color for selected items.
  /// - [showSelectedItems]: Controls whether selected items are visible (default is `true`).
  const MultiSelectorDecoration({
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
    this.selectedItemColor,
    this.selectedItemsTitle,
    this.selectedItemsTitleStyle,
    this.showSelectedItems = true,
  });
}
