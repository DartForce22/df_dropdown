import 'package:df_dropdown/models/dropdown_decoration.dart';
import 'package:df_dropdown/models/single_selector_decoration.dart';
import 'package:flutter/material.dart' hide Icons;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '/constants/icons.dart';
import '/models/drop_down_model.dart';
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
  final SingleSelectorDecoration? selectorDecoration;
  final String? labelText;
  final String? hintText;

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
            child: SvgPicture.asset(
              context
                      .watch<SearchableSingleSelectDropdownProvider<T>>()
                      .suggestionsExpanded
                  ? Icons.upIcon
                  : Icons.downIcon,
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
