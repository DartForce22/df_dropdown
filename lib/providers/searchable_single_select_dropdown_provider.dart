import 'package:df_dropdown/df_dropdown.dart';
import 'package:df_dropdown/models/searchable_dropdown_selector_model.dart';
import 'package:flutter/material.dart';

import '/providers/base_dropdown_provider.dart';

class SearchableSingleSelectDropdownProvider<T>
    extends BaseDropdownProvider<T> {
  SearchableSingleSelectDropdownProvider({
    this.selectedValue,
    this.onOptionSelected,
    this.onSearch,
    this.selectorMaxHeight,
    super.initData,
    super.validator,
    super.nestedInitData,
    super.asyncNestedInitData,
    required super.asyncInitData,
    required this.closeDropdownOnSelection,
    required super.context,
  }) {
    if (nestedInitData.isNotEmpty) {
      initData.addAll(nestedInitDataToFlatInitData(nestedInitData));
    }
    if (selectedValue != null) {
      searchTextController.text = selectedValue!.displayText;
    }
  }

  DropDownModel<T>? selectedValue;
  final Function(DropDownModel<T>?)? onOptionSelected;
  final Future<List<DropDownModel<T>>> Function(String searchText)? onSearch;
  final TextEditingController selectorTextEditingController =
      TextEditingController();
  final double? selectorMaxHeight;
  final bool closeDropdownOnSelection;

  @override
  double get dropdownHeight {
    double height = 0;

    int dataLength = 0;

    if (nestedInitData.isEmpty &&
        (baseSearchResults.isNotEmpty ||
            selectorTextEditingController.text.isNotEmpty)) {
      dataLength = baseSearchResults.isNotEmpty ||
              selectorTextEditingController.text.isNotEmpty
          ? baseSearchResults.length
          : initData.length;
    } else if (baseSearchResults.isNotEmpty ||
        selectorTextEditingController.text.isNotEmpty) {
      dataLength = baseSearchResults.length;
    } else if (suggestionsExpanded) {
      return 200;
    }

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
    if (value == selectedValue) {
      selectedValue = null;
      searchTextController.text = "";
    } else {
      selectedValue = value;
      searchTextController.text = value.displayText;
    }
    if (closeDropdownOnSelection) closeSuggestions();
    setValidationError = null;
    if (onOptionSelected != null) {
      onOptionSelected!(selectedValue);
    }
    notifyListeners();
  }

  @override
  String? onValidateField(text) {
    if (validator != null) {
      setValidationError = validator!(selectedValue);
    }
    notifyListeners();
    return super.onValidateField(text);
  }

  @override
  void onInputChanged(String text) {
    if (onSearch != null && text.isNotEmpty) {
      onSearch!(text).then((values) {
        baseSearchResults.clear();
        baseSearchResults.addAll(values);
        notifyListeners();
      });
    } else {
      baseSearchResults.clear();

      if (text.isNotEmpty) {
        baseSearchResults.addAll(
          initData.where(
            (el) => el.text.toLowerCase().startsWith(
                  text.toLowerCase(),
                ),
          ),
        );
      }
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
    baseSearchResults.clear();
    notifyListeners();
  }

  void onTapOutside(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
    notifyListeners();
  }

  SearchableDropdownSelectorModel<T> getSearchableDropdownSelectorModel() {
    return SearchableDropdownSelectorModel(
      dropdownHeight: dropdownHeight,
      dropdownData: getDropdownData,
      nestedDropdownData: getNestedDropdownData,
      selectedValue: selectedValue,
      //This list is used only for multiselect, so it is set as empty in single select component
      selectedValues: [],
    );
  }

  List<DropDownModel<T>> get getDropdownData {
    if (selectorTextEditingController.text.isNotEmpty ||
        baseSearchResults.isNotEmpty) {
      return baseSearchResults;
    }
    return initData;
  }

  List<DropDownNestedModel<T>> get getNestedDropdownData {
    if (selectorTextEditingController.text.isNotEmpty ||
        baseSearchResults.isNotEmpty) {
      return [];
    }
    return nestedInitData;
  }
}
