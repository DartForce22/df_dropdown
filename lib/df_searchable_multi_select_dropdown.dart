import 'package:df_dropdown/models/dropdown_decoration.dart';

import '/widgets/searchable_multi_select_dropdown_selector.dart';
import 'package:flutter/material.dart' hide Icons;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '/constants/icons.dart';
import '/models/drop_down_model.dart';
import '/widgets/dropdown_field.dart';
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
  });

  final List<DropDownModel<T>> initData;
  final List<DropDownModel<T>>? selectedValues;
  final String? labelText;
  final String? hintText;
  final Function(List<DropDownModel<T>>)? onOptionSelected;
  final String? Function(List<DropDownModel<T>>?)? validator;
  final Future<List<DropDownModel<T>>> Function(String searchText)? onSearch;
  final DropdownDecoration? decoration;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SearchableMultiSelectDropdownProvider<T>(
        initData: initData,
        selectedValues: selectedValues,
        onOptionSelected: onOptionSelected,
        multiSelectValidator: validator,
        onSearch: onSearch,
      ),
      child: _Dropdown<T>(
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
    this.decoration,
  });
  final DropdownDecoration? decoration;
  final String? labelText;
  final String? hintText;

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
              ? SearchableMultiSelectDropdownSelector<T>()
              : const SizedBox(),
        )
      ],
    );
  }
}
