import 'package:df_dropdown/enums/dropdown_type.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/models/drop_down_model.dart';
import '/models/dropdown_decoration.dart';
import '/models/single_selector_decoration.dart';
import '/widgets/dropdown_field.dart';
import '/widgets/searchable_single_select_dropdown_selector.dart';
import 'providers/searchable_single_select_dropdown_provider.dart';

class DfSearchableSingleSelectDropdown<T> extends StatelessWidget {
  /// Constructor for [DfSearchableSingleSelectDropdown].
  ///
  /// - [initData]: Initial list of data for the dropdown.
  /// - [selectedValue]: Currently selected dropdown value.
  /// - [labelText]: Text for the label of the dropdown.
  /// - [hintText]: Placeholder text shown when no value is selected.
  /// - [onOptionSelected]: Callback function triggered when an option is selected.
  /// - [validator]: Optional validation function for dropdown selection.
  /// - [onSearch]: Function to perform a search based on user input. Returns a filtered list of dropdown options.
  /// - [decoration]: Custom styling for the dropdown field.
  /// - [selectorDecoration]: Additional custom styling for the dropdown selector.
  /// - [arrowWidget]: Widget for the arrow icon displayed in the dropdown.
  ///  - [dropdownType]: Default value is `DropdownType.expandable`, and it's used to switch between the expandable, and
  /// the overlay appearance
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
    this.arrowWidget,
    this.dropdownType = DropdownType.expandable,
    this.disabled = false,
  });

  ///Default value is `DropdownType.expandable`, and it's used to switch between the expandable, and
  /// the overlay appearance
  final DropdownType dropdownType;

  /// Initial list of dropdown options.
  final List<DropDownModel<T>> initData;

  /// The currently selected dropdown value.
  final DropDownModel<T>? selectedValue;

  /// The label text for the dropdown field.
  final String? labelText;

  /// Placeholder text displayed when no value is selected.
  final String? hintText;

  /// Callback triggered when an option from the dropdown is selected.
  final Function(DropDownModel<T>?)? onOptionSelected;

  /// Validator function for validating dropdown selection.
  final String? Function(DropDownModel<T>?)? validator;

  /// Function that performs the search operation based on the user's input. It returns a list of filtered options.
  final Future<List<DropDownModel<T>>> Function(String searchText)? onSearch;

  /// Decoration for customizing the dropdown's appearance (e.g., border, padding, etc.).
  final DropdownDecoration? decoration;

  /// Decoration for customizing the dropdown selector (e.g., background color, height, etc.).
  final SingleSelectorDecoration? selectorDecoration;

  /// Widget displayed for the dropdown arrow icon.
  final Widget? arrowWidget;

  final bool disabled;

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
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        DropdownField<SearchableSingleSelectDropdownProvider<T>>(
          key: provider.dropdownKey,
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
        //An error message [Text] widget displayed only when validation returns an error
        if ((!provider.suggestionsExpanded &&
                widget.dropdownType == DropdownType.expandable) ||
            (widget.decoration?.reserveSpaceForValidationMessage != false ||
                provider.validationError != null))
          Padding(
            padding: const EdgeInsets.only(
              top: 4,
            ),
            child: Text(
              provider.validationError ?? "",
              style: widget.decoration?.errorMessageTextStyle ??
                  textTheme.bodySmall?.copyWith(
                    color: Colors.red.shade500,
                  ),
            ),
          ),
      ],
    );
  }
}
