import 'package:df_dropdown/base_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/df_dropdown.dart';
import '/widgets/dropdown_container.dart';
import '/widgets/simple_dropdown_selector.dart';
import 'providers/simple_dropdown_provider.dart';

class DfDropdownWrapper<T> extends BaseDropdown<T> {
  /// Constructor for [DfDropdownWrapper].
  /// - [selectorDecoration]: Additional custom styling for the dropdown selector.
  /// - [child]: Custom widget to be displayed in the dropdown field.
  /// - [closeOnTapOutside]: Whether to close the dropdown when the user taps outside the dropdown.
  const DfDropdownWrapper({
    super.key,
    super.initData = const [],
    super.selectedValue,
    super.labelText,
    super.onOptionSelected,
    super.validator,
    super.decoration,
    super.arrowWidget,
    super.disabled = false,
    super.asyncInitData,
    this.selectorDecoration,
    this.child,
    this.closeOnTapOutside = true,
  }) : assert(initData.length == 0 || asyncInitData == null,
            "initData and asyncInitData cannot be provided at the same time");

  /// Decoration for customizing the dropdown selector (e.g., background color, height, etc.).
  final SimpleSelectorDecoration? selectorDecoration;

  final Widget? child;

  final bool closeOnTapOutside;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => SimpleDropdownProvider<T>(
        asyncInitData: asyncInitData,
        initData: initData,
        selectedValue: selectedValue,
        onOptionSelected: onOptionSelected,
        validator: validator,
        maxHeight: selectorDecoration?.maxHeight,
        context: context,
      ),
      child: _Dropdown<T>(
        disabled: disabled,
        arrowWidget: arrowWidget,
        selectorDecoration: selectorDecoration,
        decoration: decoration,
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
    required this.decoration,
    required this.selectorDecoration,
    required this.arrowWidget,
    required this.child,
    required this.closeOnTapOutside,
    required this.disabled,
  });
  final SimpleSelectorDecoration? selectorDecoration;
  final DropdownDecoration? decoration;
  final String? labelText;
  final Widget? arrowWidget;
  final Widget? child;
  final bool closeOnTapOutside;
  final bool disabled;

  @override
  State<_Dropdown<T>> createState() => _DropdownState<T>();
}

class _DropdownState<T> extends State<_Dropdown<T>> {
  late final Widget selectorWidget;

  late SimpleDropdownProvider<T> provider;

  bool tapOutside = false;

  @override
  void initState() {
    provider = Provider.of<SimpleDropdownProvider<T>>(context, listen: false);
    selectorWidget = Consumer<SimpleDropdownProvider<T>>(
      builder: (_, provider, __) => TapRegion(
        onTapOutside: provider.suggestionsExpanded && widget.closeOnTapOutside
            ? (_) {
                tapOutside = true;
                provider.closeSuggestions();
                Future.delayed(const Duration(milliseconds: 200), () {
                  tapOutside = false;
                });
              }
            : null,
        child: SimpleDropdownSelector<T>(
          expanded: false,
          asyncInitData: provider.asyncInitDataValue,
          selectedOption: provider.selectedValue,
          selectorDecoration: widget.selectorDecoration,
          dropdownData:
              provider.suggestionsExpanded ? provider.dropdownData : [],
          dropdownHeight: provider.dropdownHeight,
          onSelectSuggestion: provider.onSelectSuggestion,
        ),
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
          disabled: widget.disabled,
          addDropdownKey: false,
          dropdownType: DropdownType.overlay,
          contentPadding: const EdgeInsets.all(0),
          decoration: widget.decoration,
          labelText: widget.labelText,
          disableInput: true,
          outlineBorderVisible: provider.suggestionsExpanded,
          suffixTapEnabled: true,
          suffixWidget: InkWell(
            key: provider.dropdownKey,
            onTap: () {
              if (!tapOutside) {
                provider.toggleSuggestionsExpanded(
                  expanded: false,
                  selectorWidget: ChangeNotifierProvider.value(
                    value: provider,
                    child: selectorWidget,
                  ),
                );
              }
            },
            child: SizedBox(
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
