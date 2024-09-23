import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/models/drop_down_model.dart';
import '/models/dropdown_decoration.dart';
import '/models/simple_selector_decoration.dart';
import '/widgets/dropdown_field.dart';
import '/widgets/simple_dropdown_selector.dart';
import 'providers/searchable_dropdown_provider.dart';

class DfSearchableDropdown<T> extends StatelessWidget {
  /// Constructor for [DfSearchableDropdown].
  ///
  /// - [initData]: Initial list of data for the dropdown.
  /// - [selectedValue]: Currently selected value.
  /// - [labelText]: Text for the label of the dropdown.
  /// - [hintText]: Placeholder text shown when no value is selected.
  /// - [onOptionSelected]: Callback function triggered when an option is selected.
  /// - [validator]: Optional validation function for the dropdown selection.
  /// - [onSearch]: Function to perform a search based on user input, returning a filtered list of dropdown options.
  /// - [decoration]: Custom styling for the dropdown field.
  /// - [selectorDecoration]: Additional custom styling for the dropdown selector.
  /// - [arrowWidget]: Widget for the arrow icon displayed in the dropdown.
  const DfSearchableDropdown({
    super.key,
    this.initData = const [],
    this.selectedValue,
    this.labelText,
    this.hintText,
    this.onOptionSelected,
    this.validator,
    this.onSearch,
    this.decoration,
    this.selectorDecoration,
    this.arrowWidget,
  });

  /// Initial list of dropdown options.
  final List<DropDownModel<T>> initData;

  /// Decoration for customizing the simple dropdown selector (e.g., background color, height, etc.).
  final SimpleSelectorDecoration? selectorDecoration;

  /// The currently selected dropdown value.
  final DropDownModel<T>? selectedValue;

  /// The label text for the dropdown field.
  final String? labelText;

  /// Placeholder text displayed when no value is selected.
  final String? hintText;

  /// Callback triggered when an option from the dropdown is selected.
  final Function(DropDownModel<T>)? onOptionSelected;

  /// Validator function for validating the selected dropdown option.
  final String? Function(DropDownModel<T>?)? validator;

  /// Function that performs the search operation based on the user's input. It returns a list of filtered options.
  final Future<List<DropDownModel<T>>> Function(String searchText)? onSearch;

  /// Decoration for customizing the dropdown's appearance (e.g., border, padding, etc.).
  final DropdownDecoration? decoration;

  /// Widget displayed for the dropdown arrow icon.
  final Widget? arrowWidget;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SearchableDropdownProvider<T>(
        initData: initData,
        selectedValue: selectedValue,
        onOptionSelected: onOptionSelected,
        validator: validator,
        onSearch: onSearch,
        selectorMaxHeight: selectorDecoration?.maxHeight,
        context: context,
      ),
      child: _Dropdown<T>(
        decoration: decoration,
        hintText: hintText,
        labelText: labelText,
        selectorDecoration: selectorDecoration,
        arrowWidget: arrowWidget,
      ),
    );
  }
}

class _Dropdown<T> extends StatelessWidget {
  const _Dropdown({
    this.labelText,
    this.hintText,
    required this.decoration,
    required this.selectorDecoration,
    required this.arrowWidget,
  });
  final SimpleSelectorDecoration? selectorDecoration;
  final DropdownDecoration? decoration;
  final String? labelText;
  final String? hintText;
  final Widget? arrowWidget;

  @override
  Widget build(BuildContext context) {
    final provider =
        Provider.of<SearchableDropdownProvider<T>>(context, listen: false);
    return Column(
      children: [
        DropdownField<SearchableDropdownProvider<T>>(
          decoration: decoration,
          hintText: hintText,
          labelText: labelText,
          outlineBorderVisible: provider.suggestionsExpanded ||
              provider.textFieldFocusNode.hasFocus,
          onTapInside: provider.expandSuggestions,
          onTapOutside: () {
            provider.onTapOutside(context);
          },
          suffixTapEnabled: false,
          suffixWidget: GestureDetector(
            onTap: provider.toggleSuggestionsExpanded,
            child: SizedBox(
              height: 48,
              child: arrowWidget ??
                  Icon(
                    context
                            .watch<SearchableDropdownProvider<T>>()
                            .suggestionsExpanded
                        ? Icons.keyboard_arrow_up_outlined
                        : Icons.keyboard_arrow_down_outlined,
                  ),
            ),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Consumer<SearchableDropdownProvider<T>>(
          builder: (_, provider, __) => provider.suggestionsExpanded
              ? SimpleDropdownSelector<T>(
                  selectorDecoration: selectorDecoration,
                  dropdownData: provider.getDropdownData,
                  dropdownHeight: provider.dropdownHeight,
                  onSelectSuggestion: provider.onSelectSuggestion,
                )
              : const SizedBox(),
        )
      ],
    );
  }
}
