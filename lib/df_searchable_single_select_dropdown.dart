import 'package:df_dropdown/base_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/enums/dropdown_type.dart';
import '/models/drop_down_model.dart';
import '/models/dropdown_decoration.dart';
import '/models/single_selector_decoration.dart';
import '/widgets/dropdown_field.dart';
import '/widgets/searchable_single_select_dropdown_selector.dart';
import 'providers/searchable_single_select_dropdown_provider.dart';

class DfSearchableSingleSelectDropdown<T> extends BaseDropdown<T> {
  /// - [onSearch]: Function to perform a search based on user input. Returns a filtered list of dropdown options.
  const DfSearchableSingleSelectDropdown({
    super.key,
    super.initData = const [],
    super.selectedValue,
    super.labelText,
    super.hintText,
    super.onOptionSelected,
    super.validator,
    this.onSearch,
    super.decoration,
    this.selectorDecoration,
    super.arrowWidget,
    super.dropdownType = DropdownType.expandable,
    super.disabled = false,
    this.closeDropdownOnSelection = true,
    super.nestedInitData,
    super.asyncNestedInitData,
    super.asyncInitData,
  }) : assert(initData.length == 0 || asyncInitData == null,
            "initData and asyncInitData cannot be provided at the same time");

  /// Function that performs the search operation based on the user's input. It returns a list of filtered options.
  final Future<List<DropDownModel<T>>> Function(String searchText)? onSearch;

  /// Decoration for customizing the dropdown selector (e.g., background color, height, etc.).
  final SingleSelectorDecoration? selectorDecoration;

  /// Whether to close dropdown after an option has been selected
  final bool closeDropdownOnSelection;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SearchableSingleSelectDropdownProvider<T>(
        asyncInitData: asyncInitData,
        initData: initData,
        selectedValue: selectedValue,
        onOptionSelected: onOptionSelected,
        validator: validator,
        onSearch: onSearch,
        asyncNestedInitData: asyncNestedInitData,
        selectorMaxHeight: selectorDecoration?.maxHeight,
        closeDropdownOnSelection: closeDropdownOnSelection,
        nestedInitData: nestedInitData??[],
        context: context,
      ),
      child: _Dropdown<T>(
        selectorDecoration: selectorDecoration,
        decoration: decoration,
        hintText: hintText,
        labelText: labelText,
        arrowWidget: arrowWidget,
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
  final DropdownDecoration? decoration;
  final SingleSelectorDecoration? selectorDecoration;
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

  @override
  void initState() {
    selectorWidget = Consumer<SearchableSingleSelectDropdownProvider<T>>(
      builder: (_, provider, __) => SearchableSingleSelectDropdownSelector<T>(
        selectorDecoration: widget.selectorDecoration,
        asyncInitData: provider.asyncInitDataValue,
      ),
    );
    super.initState();
    if (widget.dropdownType == DropdownType.overlay) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context
            .read<SearchableSingleSelectDropdownProvider<T>>()
            .updateSelectorPositionIfNeeded(
              selectorWidget: ChangeNotifierProvider.value(
                value:
                    context.read<SearchableSingleSelectDropdownProvider<T>>(),
                child: selectorWidget,
              ),
            );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SearchableSingleSelectDropdownProvider<T>>(
        context,
        listen: false);

    return Column(
      children: [
        DropdownField<SearchableSingleSelectDropdownProvider<T>>(
          dropdownType: widget.dropdownType,
          disabled: widget.disabled,
          decoration: widget.decoration,
          hintText: widget.hintText,
          labelText: widget.labelText,
          disableInput: true,
          outlineBorderVisible: provider.suggestionsExpanded ||
              provider.textFieldFocusNode.hasFocus,
          onTapInside: () => provider.toggleSuggestionsExpanded(
            selectorWidget: widget.dropdownType == DropdownType.expandable
                ? null
                : ChangeNotifierProvider.value(
                    value: provider,
                    child: selectorWidget,
                  ),
          ),
          onTapOutside: () {
            provider.onTapOutside(context);
          },
          suffixTapEnabled: false,
          suffixWidget: SizedBox(
            height: 48,
            child: widget.arrowWidget ??
                Icon(
                  context
                          .watch<SearchableSingleSelectDropdownProvider<T>>()
                          .suggestionsExpanded
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
