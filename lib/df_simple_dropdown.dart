import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/enums/dropdown_type.dart';
import '/models/drop_down_model.dart';
import '/models/dropdown_decoration.dart';
import '/models/simple_selector_decoration.dart';
import '/widgets/dropdown_field.dart';
import '/widgets/simple_dropdown_selector.dart';
import 'providers/simple_dropdown_provider.dart';

class DfSimpleDropdown<T> extends StatelessWidget {
  /// Constructor for [DfSimpleDropdown].
  ///
  /// - [initData]: Initial list of data for the dropdown.
  /// - [selectedValue]: Currently selected dropdown value.
  /// - [labelText]: Text for the label of the dropdown.
  /// - [hintText]: Placeholder text shown when no value is selected.
  /// - [onOptionSelected]: Callback function triggered when an option is selected.
  /// - [validator]: Optional validation function for dropdown selection.
  /// - [decoration]: Custom styling for the dropdown field.
  /// - [selectorDecoration]: Additional custom styling for the dropdown selector.
  /// - [arrowWidget]: Widget for the arrow icon displayed in the dropdown.
  /// - [dropdownType]: Default value is `DropdownType.expandable`, and it's used to switch between the expandable, and
  /// the overlay appearance
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
  final Function(DropDownModel<T>)? onOptionSelected;

  /// Validator function for validating dropdown selection.
  final String? Function(DropDownModel<T>?)? validator;

  /// Decoration for customizing the dropdown's appearance (e.g., border, padding, etc.).
  final DropdownDecoration? decoration;

  /// Decoration for customizing the dropdown selector (e.g., background color, height, etc.).
  final SimpleSelectorDecoration? selectorDecoration;

  /// Widget displayed for the dropdown arrow icon.
  final Widget? arrowWidget;

  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => SimpleDropdownProvider<T>(
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
        selectorDecoration: widget.selectorDecoration,
        selectedOption: provider.selectedValue,
        dropdownData: provider.suggestionsExpanded ? provider.initData : [],
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
          key: provider.dropdownKey,
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
