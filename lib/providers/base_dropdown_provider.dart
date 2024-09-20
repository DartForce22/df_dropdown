import 'package:flutter/material.dart';

import '/models/drop_down_model.dart';

class BaseDropdownProvider<T> with ChangeNotifier {
  BaseDropdownProvider({
    this.initData = const [],
    this.validator,
  });

  bool suggestionsExpanded = false;
  final List<DropDownModel<T>> initData;
  final TextEditingController searchTextController = TextEditingController();
  String? _validationError;
  FocusNode textFieldFocusNode = FocusNode();
  final String? Function(DropDownModel<T>?)? validator;
  String? validationError;

  set setValidationError(String? error) {
    _validationError = error;
    notifyListeners();
  }

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

  void onInputChanged(String text) {
    notifyListeners();
  }

  double get dropdownHeight {
    return 200;
  }

  String? onValidateField(text) {
    return validationError;
  }

  /// Returns the color to be used for the border of a form field, based on validation state.
  /// By default, the border color is a shade of grey with reduced opacity. If there is a
  /// validation error, the border color changes to red, indicating an issue.
  ///
  /// Returns:
  /// - `Color`: The color to be applied to the field's border.
  Color fieldBorderColor({
    Color? borderColor,
    Color? errorBorderColor,
  }) {
    Color color = (borderColor ?? Colors.grey[950] ?? Colors.grey.shade900)
        .withOpacity(0.12);

    if (_validationError != null) {
      borderColor = errorBorderColor ?? Colors.red.shade500;
    }

    return color;
  }
}
