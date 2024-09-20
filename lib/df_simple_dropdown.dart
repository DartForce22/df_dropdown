import 'package:df_dropdown/models/dropdown_decoration.dart';
import 'package:df_dropdown/models/simple_selector_decoration.dart';
import 'package:flutter/material.dart' hide Icons;
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '/constants/icons.dart';
import '/models/drop_down_model.dart';
import 'providers/simple_dropdown_provider.dart';
import '/widgets/dropdown_field.dart';
import '/widgets/simple_dropdown_selector.dart';

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
  });

  final List<DropDownModel<T>> initData;
  final DropDownModel<T>? selectedValue;
  final String? labelText;
  final String? hintText;
  final Function(DropDownModel<T>)? onOptionSelected;
  final String? Function(DropDownModel<T>?)? validator;
  final DropdownDecoration? decoration;
  final SimpleSelectorDecoration? selectorDecoration;

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
  final SimpleSelectorDecoration? selectorDecoration;
  final DropdownDecoration? decoration;
  final String? labelText;
  final String? hintText;

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
            child: SvgPicture.asset(
              context.watch<SimpleDropdownProvider<T>>().suggestionsExpanded
                  ? Icons.upIcon
                  : Icons.downIcon,
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
