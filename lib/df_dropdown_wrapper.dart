import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/models/drop_down_model.dart';
import '/models/dropdown_decoration.dart';
import '/models/simple_selector_decoration.dart';
import '/widgets/dropdown_container.dart';
import '/widgets/simple_dropdown_selector.dart';
import 'providers/simple_dropdown_provider.dart';

class DfDropdownWrapper<T> extends StatelessWidget {
  /// Constructor for [DfDropdownWrapper].
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
  const DfDropdownWrapper({
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
    this.child,
    this.closeOnTapOutside = true,
  });

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

  final Widget? child;

  final bool closeOnTapOutside;

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
        closeOnTapOutside: closeOnTapOutside,
        child: child,
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
    required this.child,
    required this.closeOnTapOutside,
  });
  final SimpleSelectorDecoration? selectorDecoration;
  final DropdownDecoration? decoration;
  final String? labelText;
  final String? hintText;
  final Widget? arrowWidget;
  final Widget? child;
  final bool closeOnTapOutside;

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
        expanded: false,
        selectorDecoration: widget.selectorDecoration,
        dropdownData: provider.suggestionsExpanded ? provider.initData : [],
        dropdownHeight: provider.dropdownHeight,
        onSelectSuggestion: provider.onSelectSuggestion,
      ),
    );
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.updateSelectorPositionIfNeeded(
        expanded: false,
        selectorWidget: ChangeNotifierProvider.value(
          value: provider,
          child: selectorWidget,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownContainer<SimpleDropdownProvider<T>>(
          contentPadding: const EdgeInsets.all(0),
          decoration: widget.decoration,
          labelText: widget.labelText,
          disableInput: true,
          outlineBorderVisible: provider.suggestionsExpanded,
          onTapOutside: () {
            if (widget.closeOnTapOutside) provider.closeSuggestions();
          },
          suffixWidget: InkWell(
            onTap: () {
              provider.toggleSuggestionsExpanded(
                expanded: false,
                selectorWidget: ChangeNotifierProvider.value(
                  value: provider,
                  child: selectorWidget,
                ),
              );
            },
            child: SizedBox(
              key: provider.dropdownKey,
              child: widget.arrowWidget ??
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 8,
                    ),
                    child: Icon(
                      context
                              .watch<SimpleDropdownProvider<T>>()
                              .suggestionsExpanded
                          ? Icons.keyboard_arrow_up_outlined
                          : Icons.keyboard_arrow_down_outlined,
                    ),
                  ),
            ),
          ),
          child: widget.child,
        ),
      ],
    );
  }
}
