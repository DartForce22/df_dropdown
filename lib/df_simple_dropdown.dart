import 'package:df_dropdown/base_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/enums/dropdown_type.dart';
import '/models/dropdown_decoration.dart';
import '/models/simple_selector_decoration.dart';
import '/widgets/dropdown_field.dart';
import '/widgets/simple_dropdown_selector.dart';
import 'providers/simple_dropdown_provider.dart';

class DfSimpleDropdown<T> extends BaseDropdown<T> {
  const DfSimpleDropdown({
    super.key,
    super.initData = const [],
    super.selectedValue,
    super.labelText,
    super.hintText,
    super.onOptionSelected,
    super.validator,
    super.decoration,
    super.arrowWidget,
    super.dropdownType = DropdownType.expandable,
    super.disabled = false,
    super.asyncInitData,
    this.selectorDecoration,
  }) : assert(initData.length == 0 || asyncInitData == null,
            "initData and asyncInitData cannot be provided at the same time");

  /// Decoration for customizing the dropdown selector (e.g., background color, height, etc.).
  final SimpleSelectorDecoration? selectorDecoration;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SimpleDropdownProvider<T>(
        asyncInitData: asyncInitData,
        initData: initData,
        selectedValue: selectedValue,
        onOptionSelected: onOptionSelected,
        validator: validator,
        maxHeight: selectorDecoration?.maxHeight,
        context: context,
      ),
      child: _Dropdown<T>(
        arrowWidget: arrowWidget,
        selectorDecoration: selectorDecoration,
        decoration: decoration,
        hintText: hintText,
        labelText: labelText,
        dropdownType: dropdownType,
        disabled: disabled,
      ),
    );
  }
}

class _Dropdown<T> extends StatefulWidget {
  const _Dropdown({
    this.labelText,
    this.hintText,
    required this.decoration,
    required this.selectorDecoration,
    required this.arrowWidget,
    required this.dropdownType,
    required this.disabled,
  });
  final SimpleSelectorDecoration? selectorDecoration;
  final DropdownDecoration? decoration;
  final String? labelText;
  final String? hintText;
  final Widget? arrowWidget;
  final DropdownType dropdownType;
  final bool disabled;

  @override
  State<_Dropdown<T>> createState() => _DropdownState<T>();
}

class _DropdownState<T> extends State<_Dropdown<T>> {
  late final Widget selectorWidget;

  late SimpleDropdownProvider<T> provider;

  @override
  void initState() {
    provider = Provider.of<SimpleDropdownProvider<T>>(context, listen: false);
    selectorWidget = Consumer<SimpleDropdownProvider<T>>(
      builder: (_, provider, __) => SimpleDropdownSelector<T>(
        asyncInitData: provider.asyncInitDataValue,
        selectorDecoration: widget.selectorDecoration,
        selectedOption: provider.selectedValue,
        dropdownData: provider.suggestionsExpanded ? provider.dropdownData : [],
        dropdownHeight: provider.dropdownHeight,
        onSelectSuggestion: provider.onSelectSuggestion,
      ),
    );
    super.initState();

    if (widget.dropdownType == DropdownType.overlay) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        provider.updateSelectorPositionIfNeeded(
          selectorWidget: ChangeNotifierProvider.value(
            value: provider,
            child: selectorWidget,
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownField<SimpleDropdownProvider<T>>(
          dropdownType: widget.dropdownType,
          decoration: widget.decoration,
          disabled: widget.disabled,
          hintText: widget.hintText,
          labelText: widget.labelText,
          disableInput: true,
          outlineBorderVisible: provider.suggestionsExpanded,
          onTapInside: () => provider.toggleSuggestionsExpanded(
            selectorWidget: widget.dropdownType == DropdownType.expandable
                ? null
                : ChangeNotifierProvider.value(
                    value: provider,
                    child: selectorWidget,
                  ),
          ),
          suffixWidget: SizedBox(
            height: 48,
            child: widget.arrowWidget ??
                Icon(
                  context.watch<SimpleDropdownProvider<T>>().suggestionsExpanded
                      ? Icons.keyboard_arrow_up_outlined
                      : Icons.keyboard_arrow_down_outlined,
                ),
          ),
        ),
        if (widget.dropdownType == DropdownType.expandable) ...[
          const SizedBox(
            height: 4,
          ),
          selectorWidget,
        ],
      ],
    );
  }
}
