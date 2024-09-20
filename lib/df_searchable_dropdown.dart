import 'package:df_dropdown/models/dropdown_decoration.dart';
import 'package:flutter/material.dart' hide Icons;
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '/constants/icons.dart';
import '/models/drop_down_model.dart';
import 'providers/searchable_dropdown_provider.dart';
import '/widgets/dropdown_field.dart';
import '/widgets/simple_dropdown_selector.dart';

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
  });

  final List<DropDownModel<T>> initData;
  final DropDownModel<T>? selectedValue;
  final String? labelText;
  final String? hintText;
  final Function(DropDownModel<T>)? onOptionSelected;
  final String? Function(DropDownModel<T>?)? validator;
  final Future<List<DropDownModel<T>>> Function(String searchText)? onSearch;
  final DropdownDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SearchableDropdownProvider<T>(
        initData: initData,
        selectedValue: selectedValue,
        onOptionSelected: onOptionSelected,
        validator: validator,
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
              child: SvgPicture.asset(
                context
                        .watch<SearchableDropdownProvider<T>>()
                        .suggestionsExpanded
                    ? Icons.upIcon
                    : Icons.downIcon,
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
