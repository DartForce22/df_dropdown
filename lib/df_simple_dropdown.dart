import 'package:df_dropdown/enums/dropdown_type.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/models/drop_down_model.dart';
import '/models/dropdown_decoration.dart';
import '/models/simple_selector_decoration.dart';
import '/widgets/dropdown_field.dart';
import '/widgets/simple_dropdown_selector.dart';
import 'providers/simple_dropdown_provider.dart';

class DfSimpleDropdown<T> extends StatelessWidget {
  /// Constructor for [DfSimpleDropdown].
  ///
  /// - [initData]: Initial list of data for the dropdown.
  /// - [selectedValue]: Currently selected dropdown value.
  /// - [labelText]: Text for the label of the dropdown.
  /// - [hintText]: Placeholder text shown when no value is selected.
  /// - [onOptionSelected]: Callback function triggered when an option is selected.
  /// - [validator]: Optional validation function for dropdown selection.
  /// - [decoration]: Custom styling for the dropdown field.
  /// - [selectorDecoration]: Additional custom styling for the dropdown selector.
  /// - [arrowWidget]: Widget for the arrow icon displayed in the dropdown.
  const DfSimpleDropdown({
    super.key,
    this.initData = const [],
    this.selectedValue,
    this.labelText,
    this.hintText,
    this.onOptionSelected,
    this.validator,
    this.decoration,
    this.selectorDecoration,
    this.arrowWidget,
    this.dropdownType = DropdownType.expandable,
  });

  final DropdownType dropdownType;

  /// Initial list of dropdown options.
  final List<DropDownModel<T>> initData;

  /// The currently selected dropdown value.
  final DropDownModel<T>? selectedValue;

  /// The label text for the dropdown field.
  final String? labelText;

  /// Placeholder text displayed when no value is selected.
  final String? hintText;

  /// Callback triggered when an option from the dropdown is selected.
  final Function(DropDownModel<T>)? onOptionSelected;

  /// Validator function for validating dropdown selection.
  final String? Function(DropDownModel<T>?)? validator;

  /// Decoration for customizing the dropdown's appearance (e.g., border, padding, etc.).
  final DropdownDecoration? decoration;

  /// Decoration for customizing the dropdown selector (e.g., background color, height, etc.).
  final SimpleSelectorDecoration? selectorDecoration;

  /// Widget displayed for the dropdown arrow icon.
  final Widget? arrowWidget;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => SimpleDropdownProvider<T>(
        initData: initData,
        selectedValue: selectedValue,
        onOptionSelected: onOptionSelected,
        validator: validator,
        maxHeight: selectorDecoration?.maxHeight,
        context: context,
      ),
      child: _Dropdown<T>(
        arrowWidget: arrowWidget,
        selectorDecoration: selectorDecoration,
        decoration: decoration,
        hintText: hintText,
        labelText: labelText,
        dropdownType: dropdownType,
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
    required this.dropdownType,
  });
  final SimpleSelectorDecoration? selectorDecoration;
  final DropdownDecoration? decoration;
  final String? labelText;
  final String? hintText;
  final Widget? arrowWidget;
  final DropdownType dropdownType;

  @override
  Widget build(BuildContext context) {
    final provider =
        Provider.of<SimpleDropdownProvider<T>>(context, listen: false);
    return Column(
      children: [
        DropdownField<SimpleDropdownProvider<T>>(
          key: provider.dropdownKey,
          decoration: decoration,
          hintText: hintText,
          labelText: labelText,
          disableInput: true,
          outlineBorderVisible: provider.suggestionsExpanded,
          onTapInside: () => provider.toggleSuggestionsExpanded(
            selectorWidget: dropdownType == DropdownType.expandable
                ? null
                : SimpleDropdownSelector<T>(
                    selectorDecoration: selectorDecoration,
                    dropdownData: provider.initData,
                    dropdownHeight: provider.dropdownMaxHeight,
                    onSelectSuggestion: provider.onSelectSuggestion,
                  ),
          ),
          suffixWidget: SizedBox(
            height: 48,
            child: arrowWidget ??
                Icon(
                  context.watch<SimpleDropdownProvider<T>>().suggestionsExpanded
                      ? Icons.keyboard_arrow_up_outlined
                      : Icons.keyboard_arrow_down_outlined,
                ),
          ),
        ),
        if (dropdownType == DropdownType.expandable) ...[
          const SizedBox(
            height: 8,
          ),
          Consumer<SimpleDropdownProvider<T>>(
            builder: (_, provider, __) => provider.suggestionsExpanded
                ? SimpleDropdownSelector<T>(
                    selectorDecoration: selectorDecoration,
                    dropdownData: provider.initData,
                    dropdownHeight: provider.dropdownHeight,
                    onSelectSuggestion: provider.onSelectSuggestion,
                  )
                : const SizedBox(),
          )
        ]
      ],
    );
  }
}
