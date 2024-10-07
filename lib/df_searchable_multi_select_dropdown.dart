import 'package:df_dropdown/enums/dropdown_type.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/models/drop_down_model.dart';
import '/models/dropdown_decoration.dart';
import '/models/multi_selector_decoration.dart';
import '/widgets/dropdown_field.dart';
import '/widgets/searchable_multi_select_dropdown_selector.dart';
import 'providers/searchable_multi_select_dropdown_provider.dart';

class DfSearchableMultiSelectDropdown<T> extends StatelessWidget {
  /// Constructor for [DfSearchableMultiSelectDropdown].
  ///
  /// - [initData]: Initial list of data for the dropdown.
  /// - [selectedValues]: Currently selected list of values.
  /// - [labelText]: Text for the label of the dropdown.
  /// - [hintText]: Placeholder text shown when no value is selected.
  /// - [onOptionSelected]: Callback function triggered when options are selected.
  /// - [validator]: Optional validation function for dropdown selection.
  /// - [onSearch]: Function to perform a search based on user input. Returns a filtered list of dropdown options.
  /// - [decoration]: Custom styling for the dropdown field.
  /// - [selectorDecoration]: Additional custom styling for the dropdown selector.
  /// - [arrowWidget]: Widget for the arrow icon displayed in the dropdown.
  /// - [dropdownType]: Default value is `DropdownType.expandable`, and it's used to switch between the expandable, and
  /// the overlay appearance
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
    this.arrowWidget,
    this.dropdownType = DropdownType.expandable,
    this.disabled = false,
  });

  ///Default value is `DropdownType.expandable`, and it's used to switch between the expandable, and
  /// the overlay appearance
  final DropdownType dropdownType;

  /// Initial list of dropdown options.
  final List<DropDownModel<T>> initData;

  /// The currently selected list of dropdown values.
  final List<DropDownModel<T>>? selectedValues;

  /// The label text for the dropdown field.
  final String? labelText;

  /// Placeholder text displayed when no value is selected.
  final String? hintText;

  /// Callback triggered when options from the dropdown are selected.
  final Function(List<DropDownModel<T>>)? onOptionSelected;

  /// Validator function for validating the list of selected dropdown options.
  final String? Function(List<DropDownModel<T>>?)? validator;

  /// Function that performs the search operation based on the user's input. It returns a list of filtered options.
  final Future<List<DropDownModel<T>>> Function(String searchText)? onSearch;

  /// Decoration for customizing the dropdown's appearance (e.g., border, padding, etc.).
  final DropdownDecoration? decoration;

  /// Decoration for customizing the multi-select dropdown selector (e.g., background color, height, etc.).
  final MultiSelectorDecoration? selectorDecoration;

  /// Widget displayed for the dropdown arrow icon.
  final Widget? arrowWidget;

  final bool disabled;

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
        context: context,
        selectedDataVisible: selectorDecoration?.showSelectedItems ?? true,
      ),
      child: _Dropdown<T>(
        decoration: decoration,
        hintText: hintText,
        labelText: labelText,
        selectorDecoration: selectorDecoration,
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
  final DropdownType dropdownType;
  final DropdownDecoration? decoration;
  final String? labelText;
  final String? hintText;
  final MultiSelectorDecoration? selectorDecoration;
  final Widget? arrowWidget;
  final bool disabled;

  @override
  State<_Dropdown<T>> createState() => _DropdownState<T>();
}

class _DropdownState<T> extends State<_Dropdown<T>> {
  late final Widget selectorWidget;
  @override
  void initState() {
    selectorWidget = Consumer<SearchableMultiSelectDropdownProvider<T>>(
      builder: (_, provider, __) => SearchableMultiSelectDropdownSelector<T>(
        selectorDecoration: widget.selectorDecoration,
      ),
    );
    super.initState();
    if (widget.dropdownType == DropdownType.overlay) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context
            .read<SearchableMultiSelectDropdownProvider<T>>()
            .updateSelectorPositionIfNeeded(
              selectorWidget: ChangeNotifierProvider.value(
                value: context.read<SearchableMultiSelectDropdownProvider<T>>(),
                child: selectorWidget,
              ),
            );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SearchableMultiSelectDropdownProvider<T>>(
        context,
        listen: false);
    return Column(
      children: [
        DropdownField<SearchableMultiSelectDropdownProvider<T>>(
          key: context
              .read<SearchableMultiSelectDropdownProvider<T>>()
              .dropdownKey,
          disabled: widget.disabled,
          decoration: widget.decoration,
          hintText: widget.hintText,
          labelText: widget.labelText,
          disableInput: true,
          outlineBorderVisible: provider.suggestionsExpanded ||
              provider.textFieldFocusNode.hasFocus,
          onTapInside: () => context
              .read<SearchableMultiSelectDropdownProvider<T>>()
              .toggleSuggestionsExpanded(
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
                          .watch<SearchableMultiSelectDropdownProvider<T>>()
                          .suggestionsExpanded
                      ? Icons.keyboard_arrow_up_outlined
                      : Icons.keyboard_arrow_down_outlined,
                ),
          ),
        ),
        if (widget.dropdownType == DropdownType.expandable) ...[
          const SizedBox(
            height: 8,
          ),
          selectorWidget,
        ]
      ],
    );
  }
}
