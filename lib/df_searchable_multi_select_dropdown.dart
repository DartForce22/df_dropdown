import 'package:flutter/material.dart' hide Icons;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '/constants/icons.dart';
import '/models/drop_down_model.dart';
import '/models/dropdown_decoration.dart';
import '/models/multi_selector_decoration.dart';
import '/widgets/dropdown_field.dart';
import '/widgets/searchable_multi_select_dropdown_selector.dart';
import 'providers/searchable_multi_select_dropdown_provider.dart';

class DfSearchableMultiSelectDropdown<T> extends StatelessWidget {
  const DfSearchableMultiSelectDropdown({
    super.key,
    this.initData = const [],
    this.selectedValues,
    this.labelText,
    this.hintText,
    this.onOptionSelected,
    this.validator,
    this.onSearch,
    this.decoration,
    this.selectorDecoration,
  });

  final List<DropDownModel<T>> initData;
  final List<DropDownModel<T>>? selectedValues;
  final String? labelText;
  final String? hintText;
  final Function(List<DropDownModel<T>>)? onOptionSelected;
  final String? Function(List<DropDownModel<T>>?)? validator;
  final Future<List<DropDownModel<T>>> Function(String searchText)? onSearch;
  final DropdownDecoration? decoration;
  final MultiSelectorDecoration? selectorDecoration;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SearchableMultiSelectDropdownProvider<T>(
        initData: initData,
        selectedValues: selectedValues,
        onOptionSelected: onOptionSelected,
        multiSelectValidator: validator,
        onSearch: onSearch,
        selectorMaxHeight: selectorDecoration?.maxHeight,
      ),
      child: _Dropdown<T>(
        decoration: decoration,
        hintText: hintText,
        labelText: labelText,
        selectorDecoration: selectorDecoration,
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
  });
  final DropdownDecoration? decoration;
  final String? labelText;
  final String? hintText;
  final MultiSelectorDecoration? selectorDecoration;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SearchableMultiSelectDropdownProvider<T>>(
        context,
        listen: false);
    return Column(
      children: [
        DropdownField<SearchableMultiSelectDropdownProvider<T>>(
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
            child: SvgPicture.asset(
              context
                      .watch<SearchableMultiSelectDropdownProvider<T>>()
                      .suggestionsExpanded
                  ? Icons.upIcon
                  : Icons.downIcon,
            ),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Consumer<SearchableMultiSelectDropdownProvider<T>>(
          builder: (_, provider, __) => provider.suggestionsExpanded
              ? SearchableMultiSelectDropdownSelector<T>(
                  selectorDecoration: selectorDecoration,
                )
              : const SizedBox(),
        )
      ],
    );
  }
}
