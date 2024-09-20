import 'package:df_dropdown/constants/dropdown_enums.dart';
import 'package:df_dropdown/searchable_drop_down/providers/dropdown_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'drop_down.dart';
import '../models/drop_down_model.dart';

class SearchableDropDown extends StatelessWidget {
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
