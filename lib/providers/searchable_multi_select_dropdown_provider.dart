import 'package:flutter/material.dart';

import '/models/drop_down_model.dart';
import '/providers/base_dropdown_provider.dart';

class SearchableMultiSelectDropdownProvider<T> extends BaseDropdownProvider<T> {
  SearchableMultiSelectDropdownProvider({
    List<DropDownModel<T>>? selectedValues,
    this.onOptionSelected,
    this.onSearch,
    super.initData,
    this.multiSelectValidator,
    this.selectorMaxHeight,
    required super.context,
  }) {
    this.selectedValues.addAll(selectedValues ?? []);
    if (selectedValues != null && selectedValues.isNotEmpty) {
      searchTextController.text = selectedValues.first.text;
      if (selectedValues.length > 1) {
        searchTextController.text += " (+${selectedValues.length - 1})";
      }
    }
  }

  final List<DropDownModel<T>> selectedValues = [];
  final List<DropDownModel<T>> searchResults = [];
  final Function(List<DropDownModel<T>>)? onOptionSelected;
  final Future<List<DropDownModel<T>>> Function(String searchText)? onSearch;
  final TextEditingController selectorTextEditingController =
      TextEditingController();
  final String? Function(List<DropDownModel<T>>)? multiSelectValidator;
  final double? selectorMaxHeight;

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
        height = selectorMaxHeight ?? 200;
      }
    }

    return height;
  }

  void onSelectSuggestion(DropDownModel<T> value) {
    if (selectedValues.map((el) => el.key).contains(value.key)) {
      selectedValues.removeWhere((el) => el.key == value.key);
    } else {
      selectedValues.add(value);
    }

    if (selectedValues.isNotEmpty) {
      searchTextController.text = selectedValues.first.text;
      if (selectedValues.length > 1) {
        searchTextController.text += " (+${selectedValues.length - 1})";
      }
    } else {
      searchTextController.text = "";
    }

    validationError = null;
    if (onOptionSelected != null) {
      onOptionSelected!(selectedValues);
    }
    notifyListeners();
  }

  @override
  String? onValidateField(text) {
    if (validator != null) {
      validationError = multiSelectValidator!(selectedValues);
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
    selectedValues.clear();
    searchTextController.text = "";
    selectorTextEditingController.text = "";
    if (onOptionSelected != null) {
      onOptionSelected!(selectedValues);
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
