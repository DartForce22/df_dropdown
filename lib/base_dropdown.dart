import 'package:df_dropdown/df_dropdown.dart';
import 'package:flutter/material.dart';

abstract class BaseDropdown<T> extends StatelessWidget {
  /// Base class for dropdown widgets.
  ///
  /// - [initData]: Initial list of data for the dropdown.
  /// - [selectedValue]: Currently selected dropdown value.
  /// - [labelText]: Text for the label of the dropdown.
  /// - [hintText]: Placeholder text shown when no value is selected.
  /// - [onOptionSelected]: Callback function triggered when an option is selected.
  /// - [validator]: Optional validation function for dropdown selection.
  /// - [decoration]: Custom styling for the dropdown field.
  /// - [arrowWidget]: Widget for the arrow icon displayed in the dropdown.
  /// - [dropdownType]: Default value is `DropdownType.expandable`, and it's used to switch between the expandable, and
  /// the overlay appearance
  /// - [disabled]: Whether the dropdown is disabled.
  /// - [asyncInitData]: Future that provides the initial list of dropdown options.
  /// - [closeOnTapOutside]: Whether to close the dropdown when the user taps outside the dropdown.
  ///
  final bool closeOnTapOutside;

  const BaseDropdown({
    super.key,
    this.initData = const [],
    this.selectedValue,
    this.labelText,
    this.hintText,
    this.onOptionSelected,
    this.validator,
    this.decoration,
    this.arrowWidget,
    this.dropdownType = DropdownType.expandable,
    this.disabled = false,
    this.asyncInitData,
    this.closeOnTapOutside = true,
    this.nestedInitData,
    this.asyncNestedInitData,
  }) : assert(initData.length == 0 || asyncInitData == null,
            "initData and asyncInitData cannot be provided at the same time");

  ///Default value is `DropdownType.expandable`, and it's used to switch between the expandable, and
  /// the overlay appearance
  final DropdownType dropdownType;

  /// Initial list of dropdown options.
  final List<DropDownModel<T>> initData;

  /// Initial list of dropdown options.
  final List<DropDownNestedModel<T>>? nestedInitData;

  /// The currently selected dropdown value.
  final DropDownModel<T>? selectedValue;

  /// The label text for the dropdown field.
  final String? labelText;

  /// Placeholder text displayed when no value is selected.
  final String? hintText;

  /// Callback triggered when an option from the dropdown is selected.
  final Function(DropDownModel<T>?)? onOptionSelected;

  /// Provides a [DropDownModel] object if selected, and `null` if not
  ///
  /// Should return `null` when no validation error is present,
  /// and a [String] if there is an error
  ///
  final String? Function(DropDownModel<T>?)? validator;

  /// Decoration for customizing the dropdown's appearance (e.g., border, padding, etc.).
  final DropdownDecoration? decoration;

  /// Widget displayed for the dropdown arrow icon.
  final Widget? arrowWidget;

  final bool disabled;

  /// Future that provides the initial list of dropdown options.
  final Future<List<DropDownModel<T>>>? asyncInitData;

  /// Future that provides the initial list of dropdown options.
  final Future<List<DropDownNestedModel<T>>>? asyncNestedInitData;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
