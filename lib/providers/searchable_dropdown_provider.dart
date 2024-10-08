import 'package:flutter/material.dart';

import '/models/drop_down_model.dart';
import '/providers/base_dropdown_provider.dart';

class SearchableDropdownProvider<T> extends BaseDropdownProvider<T> {
  SearchableDropdownProvider({
    this.selectedValue,
    this.onOptionSelected,
    this.onSearch,
    this.selectorMaxHeight,
    super.initData,
    super.validator,
    required super.context,
  }) {
    if (selectedValue != null) {
      searchTextController.text = selectedValue!.text;
    }
  }

  DropDownModel<T>? selectedValue;
  final List<DropDownModel<T>> _searchResults = [];
  final Function(DropDownModel<T>?)? onOptionSelected;
  final Future<List<DropDownModel<T>>> Function(String searchText)? onSearch;
  final double? selectorMaxHeight;

  List<DropDownModel<T>> get searchResults =>
      [if (selectedValue != null) selectedValue!, ..._searchResults];

  @override
  double get dropdownHeight {
    double height = 0;

    if (suggestionsExpanded) {
      height = dropdownMaxHeight;
    }

    return height;
  }

  double get dropdownMaxHeight {
    double height = 0;

    int dataLength =
        (searchResults.isNotEmpty || searchTextController.text.isNotEmpty
            ? searchResults.length
            : initData.length);

    if (dataLength < 5) {
      height = dataLength * 40;
    } else {
      height = selectorMaxHeight ?? 200;
    }

    return height > 0 ? height : 40;
  }

  void onSelectSuggestion(DropDownModel<T>? value) {
    if (value == selectedValue) return;
    selectedValue = value;
    validationError = null;
    closeSuggestions();
    if (value != null) {
      searchTextController.text = value.text;
    }
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
  void closeSuggestions() {
    if (selectedValue != null &&
        selectedValue?.text != searchTextController.text) {
      searchTextController.text = selectedValue!.text;
    }
    super.closeSuggestions();
  }

  @override
  void onInputChanged(String text) {
    if (onSearch != null) {
      onSearch!(text).then((values) {
        _searchResults.clear();
        _searchResults.addAll(values);
        notifyListeners();
      });
    } else {
      _searchResults.clear();

      _searchResults.addAll(
        initData.where(
          (el) => el.text.toLowerCase().startsWith(
                text.toLowerCase(),
              ),
        ),
      );
      super.onInputChanged(text);
    }
  }

  void onTapOutside(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
    notifyListeners();
  }

  List<DropDownModel<T>> get getDropdownData {
    if (searchTextController.text.isNotEmpty || searchResults.isNotEmpty) {
      _searchResults.removeWhere((el) => el == selectedValue);
      return searchResults;
    }
    return initData;
  }
}
