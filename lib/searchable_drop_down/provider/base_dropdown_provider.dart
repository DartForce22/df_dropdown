import 'package:df_dropdown/models/drop_down_model.dart';
import 'package:flutter/material.dart';

class BaseDropdownProvider with ChangeNotifier {
  BaseDropdownProvider({
    this.selectedValue,
    this.initData = const [],
  }) {
    if (selectedValue != null) {
      searchTextController.text = selectedValue!.text;
    }
  }

  bool suggestionsExpanded = false;
  final List<DropDownModel> searchResults = [];
  final List<DropDownModel> initData;
  DropDownModel? selectedValue;
  final List<DropDownModel> selectedValues = [];
  final TextEditingController searchTextController = TextEditingController();
  String? _validationError;
  FocusNode textFieldFocusNode = FocusNode();

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

  void onInputChanged(String text) {}

  double get dropdownHeight {
    return 200;
  }

  void onSelectSuggestion(DropDownModel value) {
    notifyListeners();
  }

  void onClearSelection() {
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
