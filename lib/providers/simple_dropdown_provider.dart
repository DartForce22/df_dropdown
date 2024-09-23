import 'dart:developer';

import '/models/drop_down_model.dart';
import '/providers/base_dropdown_provider.dart';

class SimpleDropdownProvider<T> extends BaseDropdownProvider<T> {
  SimpleDropdownProvider({
    this.selectedValue,
    this.onOptionSelected,
    this.maxHeight,
    super.initData,
    super.validator,
    super.context,
  }) {
    if (selectedValue != null) {
      searchTextController.text = selectedValue!.text;
    }
  }

  DropDownModel<T>? selectedValue;
  final Function(DropDownModel<T>)? onOptionSelected;
  final double? maxHeight;

  @override
  double get dropdownHeight {
    double height = 0;

    if (suggestionsExpanded) {
      if (initData.length < 5) {
        height = initData.length * 40;
      } else {
        height = maxHeight ?? 200;
      }
    }
    return height;
  }

  double get dropdownMaxHeight {
    double height = 0;

    if (initData.length < 5) {
      height = initData.length * 40;
    } else {
      height = maxHeight ?? 200;
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
}
