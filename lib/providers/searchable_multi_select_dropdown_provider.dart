import 'package:flutter/material.dart';

import '/models/drop_down_model.dart';
import '/providers/base_dropdown_provider.dart';

class SearchableMultiSelectDropdownProvider<T> extends BaseDropdownProvider<T> {
  SearchableMultiSelectDropdownProvider({
    this.selectedValue,
    this.onOptionSelected,
    this.onSearch,
    super.initData,
    super.validator,
  }) : super(
          selectedValues: selectedValue != null ? [selectedValue] : [],
        );

  DropDownModel<T>? selectedValue;
  final List<DropDownModel<T>> searchResults = [];
  final Function(DropDownModel<T>?)? onOptionSelected;
  final Future<List<DropDownModel<T>>> Function(String searchText)? onSearch;
  final TextEditingController selectorTextEditingController =
      TextEditingController();

  @override
  double get dropdownHeight {
    double height = 0;

    int dataLength = searchResults.isNotEmpty ||
            selectorTextEditingController.text.isNotEmpty
        ? searchResults.length
        : initData.length;

    if (suggestionsExpanded) {
      if (dataLength < 5) {
        height = (dataLength * 40) + 40;
      } else {
        height = 200;
      }
    }

    return height;
  }

  void onSelectSuggestion(DropDownModel<T> value) {
    selectedValue = value;
    validationError = null;
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

  @override
  void onInputChanged(String text) {
    if (onSearch != null && text.isNotEmpty) {
      onSearch!(text).then((values) {
        searchResults.clear();
        searchResults.addAll(values);
        notifyListeners();
      });
    } else {
      searchResults.clear();

      searchResults.addAll(
        initData.where(
          (el) => el.text.toLowerCase().startsWith(
                text.toLowerCase(),
              ),
        ),
      );
      super.onInputChanged(text);
    }
  }

  void clearSelection() {
    selectedValue = null;
    searchTextController.text = "";
    selectorTextEditingController.text = "";
    if (onOptionSelected != null) {
      onOptionSelected!(null);
    }
    notifyListeners();
  }

  void onTapOutside(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
    notifyListeners();
  }

  List<DropDownModel<T>> get getDropdownData {
    if (selectorTextEditingController.text.isNotEmpty ||
        searchResults.isNotEmpty) {
      return searchResults;
    }
    return initData;
  }
}
