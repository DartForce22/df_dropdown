import 'package:flutter/material.dart';

import '/models/drop_down_model.dart';
import '/providers/base_dropdown_provider.dart';

class SearchableDropdownProvider<T> extends BaseDropdownProvider<T> {
  SearchableDropdownProvider({
    this.selectedValue,
    this.onOptionSelected,
    super.initData,
    super.validator,
  }) : super(
          selectedValues: selectedValue != null ? [selectedValue] : [],
        );

  DropDownModel<T>? selectedValue;
  final Function(DropDownModel<T>)? onOptionSelected;

  @override
  double get dropdownHeight {
    double height = 0;

    if (suggestionsExpanded) {
      if (initData.length < 5) {
        height = initData.length * 40;
      } else {
        height = 200;
      }
    }

    return height;
  }

  void onSelectSuggestion(DropDownModel<T> value) {
    selectedValue = value;
    validationError = null;
    closeSuggestions();
    searchTextController.text = value.text;
    if (onOptionSelected != null) {
      onOptionSelected!(value);
    }
    notifyListeners();
  }

  @override
  String? onValidateField(text) {
    if (validator != null) {
      validationError = validator!(selectedValue);
    }
    notifyListeners();
    return super.onValidateField(text);
  }

  void onTapOutside(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
    notifyListeners();
  }
}
