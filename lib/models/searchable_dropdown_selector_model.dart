import 'package:df_dropdown/df_dropdown.dart';

class SearchableDropdownSelectorModel<T> {
  final double? dropdownHeight;
  final List<DropDownModel<T>> dropdownData;
  final DropDownModel<T>? selectedValue;
  final List<DropDownModel<T>> selectedValues;
  final List<DropDownNestedModel<T>>? nestedDropdownData;

  SearchableDropdownSelectorModel({
    required this.dropdownHeight,
    required this.dropdownData,
    this.selectedValue,
    required this.selectedValues,
    this.nestedDropdownData,
  });
}
