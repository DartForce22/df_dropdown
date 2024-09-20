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
  });

  final List<DropDownModel<T>> initData;
  final DropDownModel<T>? selectedValue;
  final String? labelText;
  final String? hintText;
  final Function(DropDownModel<T>)? onOptionSelected;
  final String? Function(DropDownModel<T>?)? validator;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SearchableDropdownProvider<T>(
        initData: initData,
        selectedValue: selectedValue,
        onOptionSelected: onOptionSelected,
        validator: validator,
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
    return Column(
      children: [
        DropdownField<SearchableDropdownProvider<T>>(
          hintText: hintText,
          labelText: labelText,
          outlineBorderVisible:
              context.read<SearchableDropdownProvider<T>>().suggestionsExpanded,
          onTapInside: context
              .read<SearchableDropdownProvider<T>>()
              .toggleSuggestionsExpanded,
          suffixWidget: SizedBox(
            height: 48,
            child: SvgPicture.asset(
              context.watch<SearchableDropdownProvider<T>>().suggestionsExpanded
                  ? Icons.upIcon
                  : Icons.downIcon,
            ),
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        Consumer<SearchableDropdownProvider<T>>(
          builder: (_, provider, __) => provider.suggestionsExpanded
              ? SimpleDropdownSelector<T>(
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
