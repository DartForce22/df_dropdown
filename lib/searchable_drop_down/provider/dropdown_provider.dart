import 'dart:async';

import 'package:df_dropdown/constants/dropdown_enums.dart';
import 'package:flutter/material.dart';

import '../../models/drop_down_model.dart';

class DropdownProvider with ChangeNotifier {
  DropdownProvider({
    this.searchFunction,
    this.onItemSelect,
    required this.dropdownType,
    this.onMultiItemSelect,
    this.initData = const [],
    this.selectedValue,
  }) {
    if (selectedValue != null) {
      searchTextController.text = selectedValue!.text;
    }
  }

  bool suggestionsExpanded = false;
  final Future<List<DropDownModel>> Function(String)? searchFunction;
  final List<DropDownModel> searchResults = [];
  final List<DropDownModel> initData;
  DropDownModel? selectedValue;
  final List<DropDownModel> selectedValues = [];
  final TextEditingController searchTextController = TextEditingController();
  String? _validationError;
  FocusNode textFieldFocusNode = FocusNode();
  final Function(DropDownModel?)? onItemSelect;
  final Function(List<DropDownModel>)? onMultiItemSelect;
  Timer? _debounceTimer;
  final DropdownType dropdownType;

  set setValidationError(String? error) {
    _validationError = error;
    notifyListeners();
  }

  String? get validationError => _validationError;

  void toggleSuggestionsExpanded() {
    suggestionsExpanded = !suggestionsExpanded;
    notifyListeners();
  }

  void expandSuggestions() {
    suggestionsExpanded = true;
    notifyListeners();
  }

  void closeSuggestions() {
    suggestionsExpanded = false;
    notifyListeners();
  }

  bool get enabledTextInput => dropdownType == DropdownType.searchableDropdown;

  /// Handles input changes in the search field, updating the dropdown suggestions.
  ///
  /// The `onInputChanged` method is triggered whenever the user types in the search
  /// field. It uses a debounce mechanism to avoid frequent API calls or data processing
  /// when the user is rapidly typing. After a short delay, it clears the current
  /// search results, fetches new results based on the input text using the `searchFunction`,
  /// and updates the search results. If new results are found, the dropdown menu
  /// is expanded to show the suggestions.
  ///
  ///  Parameters:
  /// - `text` (String): The current text input from the user.
  void onInputChanged(String text) {
    if (searchFunction == null) return;
    selectedValue = null;
    if (onItemSelect != null) {
      onItemSelect!(null);
    }
    if (_debounceTimer?.isActive == true) {
      _debounceTimer?.cancel();
    }
    _debounceTimer = Timer(
      const Duration(
        milliseconds: 200,
      ),
      () async {
        searchResults.clear();
        List<DropDownModel> res = await searchFunction!(text);
        searchResults.addAll(res);
        if (searchResults.isNotEmpty && !suggestionsExpanded) {
          suggestionsExpanded = true;
        }
        notifyListeners();
      },
    );
  }

  List<DropDownModel> get dropdownData {
    final List<DropDownModel> data = [];
    if (searchTextController.text.isEmpty ||
        dropdownType != DropdownType.searchableDropdown) {
      data.addAll(initData);
    } else {
      data.addAll(searchResults);
    }

    return data;
  }

  /// Calculates and returns the height of the dropdown menu based on its content.
  /// If the number of items is less than 5, the height is calculated as the number of items multiplied by 40 pixels.
  /// Otherwise, the height is capped at 200 pixels.
  ///
  /// Returns:
  /// - `double`: The height of the dropdown menu in pixels.
  double get dropdownHeight {
    double height = 0;

    if (suggestionsExpanded) {
      if (dropdownData.length < 5) {
        height = dropdownData.length * 40;
      } else {
        height = 200;
      }
    }

    return height;
  }

  void onSelectSuggestion(DropDownModel value) {
    selectedValue = value;
    searchTextController.text = value.text;
    suggestionsExpanded = false;
    if (onItemSelect != null) {
      onItemSelect!(value);
    }
    setValidationError = null;
    notifyListeners();
  }

  void onMultiSelectSuggestion(DropDownModel value) {
    if (selectedValues.contains(value)) {
      selectedValues.remove(value);
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
    if (onMultiItemSelect != null) {
      onMultiItemSelect!(selectedValues);
    }
    setValidationError = null;
    notifyListeners();
  }

  void onClearSelection() {
    selectedValues.clear();
    selectedValue = null;
    searchTextController.text = "";
    if (onMultiItemSelect != null) {
      onMultiItemSelect!(selectedValues);
    }
    if (onItemSelect != null) {
      onItemSelect!(selectedValue);
    }
    setValidationError = null;
    notifyListeners();
  }

  /// Returns the color to be used for the border of a form field, based on validation state.
  /// By default, the border color is a shade of grey with reduced opacity. If there is a
  /// validation error, the border color changes to red, indicating an issue.
  ///
  /// Returns:
  /// - `Color`: The color to be applied to the field's border.
  Color get fieldBorderColor {
    Color borderColor =
        (Colors.grey[950] ?? Colors.grey.shade900).withOpacity(0.12);

    if (_validationError != null) {
      borderColor = Colors.red.shade500;
    }

    return borderColor;
  }
}
