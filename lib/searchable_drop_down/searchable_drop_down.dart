import 'package:df_dropdown/constants/dropdown_enums.dart';
import 'package:df_dropdown/searchable_drop_down/provider/dropdown_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'drop_down.dart';
import '../models/drop_down_model.dart';

class SearchableDropDown extends StatelessWidget {
  /// A custom dropdown widget for an e-commerce application that provides search
  /// and autocomplete functionality.
  ///
  /// Parameters:
  /// - `hint` (String): The label text displayed on the left top corner of the dropdown input field.
  /// - `onItemSelect` (Function(DropDownModel)): The callback function triggered when an item is selected.
  /// - `initialData` (List<DropDownModel>): The initial list of data displayed in the dropdown.
  /// - `initialValue` (DropDownModel?): The initial value selected in the dropdown (optional).
  /// - `validator` (String? Function(String?)?): A validator function to validate the input text (optional).
  /// - `searchFunction` (Future<List<DropDownModel>> Function(String)): The function used to search for items based on user input.
  /// - `disabled` (bool): A flag to indicate whether the dropdown should be disabled. Defaults to `false`.
  /// - `margin` (EdgeInsets): Default value is set to `bottom: 20`.
  ///
  /// Notes:
  /// - When `disabled` is set to `true`, the dropdown becomes unresponsive and has reduced opacity.
  /// - The widget uses a `ChangeNotifierProvider` to manage state, with a `DropdownProvider` to handle the search function and selected value.
  /// - The `CustomAutoCompleteWidget` is used internally to render the dropdown with the specified label, item selection, and validation logic.
  ///

  const SearchableDropDown({
    super.key,
    this.onItemSelect,
    this.onMultiSelect,
    required this.initialData,
    this.searchFunction,
    this.label,
    this.dropdownType = DropdownType.searchableDropdown,
    this.hint,
    this.validator,
    this.initialValue,
    this.disabled = false,
    this.margin = const EdgeInsets.only(
      bottom: 20,
    ),
  });

  final String? label;
  final String? hint;
  final Function(DropDownModel?)? onItemSelect;
  final List<DropDownModel> initialData;
  final DropDownModel? initialValue;
  final String? Function(String?)? validator;
  final Future<List<DropDownModel>> Function(String)? searchFunction;
  final Function(List<DropDownModel>)? onMultiSelect;
  final bool disabled;
  final EdgeInsets margin;
  final DropdownType dropdownType;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DropdownProvider(
        searchFunction: searchFunction,
        initData: initialData,
        selectedValue: initialValue,
        onItemSelect: onItemSelect,
        dropdownType: dropdownType,
        onMultiItemSelect: onMultiSelect,
      ),
      child: Container(
        margin: margin,
        child: Opacity(
          opacity: disabled ? 0.4 : 1,
          child: IgnorePointer(
            ignoring: disabled,
            child: DropDown(
              labelText: label,
              hintText: hint,
              validator: validator,
            ),
          ),
        ),
      ),
    );
  }
}
