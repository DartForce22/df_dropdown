import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/models/drop_down_model.dart';
import '/models/dropdown_decoration.dart';
import '/models/simple_selector_decoration.dart';
import '/widgets/dropdown_field.dart';
import '/widgets/simple_dropdown_selector.dart';
import 'providers/searchable_dropdown_provider.dart';

class DfSearchableDropdown<T> extends StatelessWidget {
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

  final List<DropDownModel<T>> initData;
  final SimpleSelectorDecoration? selectorDecoration;
  final DropDownModel<T>? selectedValue;
  final String? labelText;
  final String? hintText;
  final Function(DropDownModel<T>)? onOptionSelected;
  final String? Function(DropDownModel<T>?)? validator;
  final Future<List<DropDownModel<T>>> Function(String searchText)? onSearch;
  final DropdownDecoration? decoration;
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
