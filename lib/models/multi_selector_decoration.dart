import 'package:flutter/material.dart';

class MultiSelectorDecoration {
  final BorderRadius? borderRadius;
  final double? elevation;
  final double? maxHeight;
  final Color? selectorColor;
  final Color? itemColor;
  final Color? dividerColor;
  final TextStyle? optionTextStyle;
  final Widget? searchIcon;
  final bool showSearchIcon;
  final TextStyle? searchTextStyle;
  final String? clearSelectionText;
  final TextStyle? clearSelectionTextStyle;
  final String? selectedItemsTitle;
  final TextStyle? selectedItemsTitleStyle;
  final Color? selectedItemColor;
  final bool? showSelectedItems;

  const MultiSelectorDecoration({
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
    this.selectedItemsTitle,
    this.selectedItemsTitleStyle,
    this.showSearchIcon = true,
    this.showSelectedItems = true,
  });
}
