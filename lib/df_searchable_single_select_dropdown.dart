import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/models/drop_down_model.dart';
import '/models/dropdown_decoration.dart';
import '/models/single_selector_decoration.dart';
import '/widgets/dropdown_field.dart';
import '/widgets/searchable_single_select_dropdown_selector.dart';
import 'providers/searchable_single_select_dropdown_provider.dart';

class DfSearchableSingleSelectDropdown<T> extends StatelessWidget {
  const DfSearchableSingleSelectDropdown({
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
  final DropDownModel<T>? selectedValue;
  final String? labelText;
  final String? hintText;
  final Function(DropDownModel<T>?)? onOptionSelected;
  final String? Function(DropDownModel<T>?)? validator;
  final Future<List<DropDownModel<T>>> Function(String searchText)? onSearch;
  final DropdownDecoration? decoration;
  final SingleSelectorDecoration? selectorDecoration;
  final Widget? arrowWidget;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SearchableSingleSelectDropdownProvider<T>(
        initData: initData,
        selectedValue: selectedValue,
        onOptionSelected: onOptionSelected,
        validator: validator,
        onSearch: onSearch,
        selectorMaxHeight: selectorDecoration?.maxHeight,
      ),
      child: _Dropdown<T>(
        selectorDecoration: selectorDecoration,
        decoration: decoration,
        hintText: hintText,
        labelText: labelText,
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
  final DropdownDecoration? decoration;
  final SingleSelectorDecoration? selectorDecoration;
  final String? labelText;
  final String? hintText;
  final Widget? arrowWidget;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SearchableSingleSelectDropdownProvider<T>>(
        context,
        listen: false);
    return Column(
      children: [
        DropdownField<SearchableSingleSelectDropdownProvider<T>>(
          decoration: decoration,
          hintText: hintText,
          labelText: labelText,
          disableInput: true,
          outlineBorderVisible: provider.suggestionsExpanded ||
              provider.textFieldFocusNode.hasFocus,
          onTapInside: provider.toggleSuggestionsExpanded,
          onTapOutside: () {
            provider.onTapOutside(context);
          },
          suffixTapEnabled: false,
          suffixWidget: SizedBox(
            height: 48,
            child: arrowWidget ??
                Icon(
                  context
                          .watch<SearchableSingleSelectDropdownProvider<T>>()
                          .suggestionsExpanded
                      ? Icons.keyboard_arrow_up_outlined
                      : Icons.keyboard_arrow_down_outlined,
                ),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Consumer<SearchableSingleSelectDropdownProvider<T>>(
          builder: (_, provider, __) => provider.suggestionsExpanded
              ? SearchableSingleSelectDropdownSelector<T>(
                  selectorDecoration: selectorDecoration,
                )
              : const SizedBox(),
        )
      ],
    );
  }
}
