import '/models/drop_down_model.dart';
import '/providers/base_dropdown_provider.dart';

class SimpleDropdownProvider<T> extends BaseDropdownProvider<T> {
  SimpleDropdownProvider({
    this.selectedValue,
    this.onOptionSelected,
    this.maxHeight,
    super.initData,
    super.asyncNestedInitData,
    super.validator,
    required super.asyncInitData,
    required super.context,
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
      height = dropdownMaxHeight;
    }
    return height;
  }

  double get dropdownMaxHeight {
    double height = 0;

    if (dropdownData.length < 5) {
      height = dropdownData.length * 40;
    } else {
      height = maxHeight ?? 200;
    }

    return height;
  }

  void onSelectSuggestion(DropDownModel<T> value) {
    selectedValue = value;
    setValidationError = null;
    closeSuggestions();
    searchTextController.text = value.text;
    if (onOptionSelected != null) {
      onOptionSelected!(value);
    }
    notifyListeners();
  }

  List<DropDownModel<T>> get dropdownData {
    if (initData.isNotEmpty) return initData;
    return baseSearchResults;
  }

  @override
  String? onValidateField(text) {
    if (validator != null) {
      setValidationError = validator!(selectedValue);
    }
    notifyListeners();
    return super.onValidateField(text);
  }
}
