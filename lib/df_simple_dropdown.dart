import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/models/drop_down_model.dart';
import '/models/dropdown_decoration.dart';
import '/models/simple_selector_decoration.dart';
import '/widgets/dropdown_field.dart';
import '/widgets/simple_dropdown_selector.dart';
import 'providers/simple_dropdown_provider.dart';

class DfSimpleDropdown<T> extends StatelessWidget {
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
  });

  final List<DropDownModel<T>> initData;
  final DropDownModel<T>? selectedValue;
  final String? labelText;
  final String? hintText;
  final Function(DropDownModel<T>)? onOptionSelected;
  final String? Function(DropDownModel<T>?)? validator;
  final DropdownDecoration? decoration;
  final SimpleSelectorDecoration? selectorDecoration;
  final Widget? arrowWidget;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SimpleDropdownProvider<T>(
        initData: initData,
        selectedValue: selectedValue,
        onOptionSelected: onOptionSelected,
        validator: validator,
        maxHeight: selectorDecoration?.maxHeight,
      ),
      child: _Dropdown<T>(
        arrowWidget: arrowWidget,
        selectorDecoration: selectorDecoration,
        decoration: decoration,
        hintText: hintText,
        labelText: labelText,
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
    return Column(
      children: [
        DropdownField<SimpleDropdownProvider<T>>(
          decoration: decoration,
          hintText: hintText,
          labelText: labelText,
          disableInput: true,
          outlineBorderVisible:
              context.read<SimpleDropdownProvider<T>>().suggestionsExpanded,
          onTapInside: context
              .read<SimpleDropdownProvider<T>>()
              .toggleSuggestionsExpanded,
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
      ],
    );
  }
}
