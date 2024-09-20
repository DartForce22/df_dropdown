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
  });

  final List<DropDownModel<T>> initData;
  final DropDownModel<T>? selectedValue;
  final String? labelText;
  final String? hintText;
  final Function(DropDownModel<T>?)? onOptionSelected;
  final String? Function(DropDownModel<T>?)? validator;
  final Future<List<DropDownModel<T>>> Function(String searchText)? onSearch;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SearchableSingleSelectDropdownProvider<T>(
        initData: initData,
        selectedValue: selectedValue,
        onOptionSelected: onOptionSelected,
        validator: validator,
        onSearch: onSearch,
      ),
      child: _Dropdown<T>(
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
  });
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
          height:  8,
        ),
        Consumer<SearchableSingleSelectDropdownProvider<T>>(
          builder: (_, provider, __) => provider.suggestionsExpanded
              ? SearchableSingleSelectDropdownSelector<T>()
              : const SizedBox(),
        )
      ],
    );
  }
}
