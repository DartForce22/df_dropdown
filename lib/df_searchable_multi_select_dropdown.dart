import 'package:df_dropdown/base_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/enums/dropdown_type.dart';
import '/models/drop_down_model.dart';
import '/models/dropdown_decoration.dart';
import '/models/multi_selector_decoration.dart';
import '/widgets/dropdown_field.dart';
import '/widgets/searchable_multi_select_dropdown_selector.dart';
import 'providers/searchable_multi_select_dropdown_provider.dart';

class DfSearchableMultiSelectDropdown<T> extends BaseDropdown<T> {
  /// Constructor for [DfSearchableMultiSelectDropdown].
  /// - [onOptionsSelected]: Callback function triggered when options are selected.
  /// - [multiSelectValidator]: Optional validation function for dropdown selection.
  /// - [onSearch]: Function to perform a search based on user input. Returns a filtered list of dropdown options.
  /// - [selectorDecoration]: Additional custom styling for the dropdown selector.
  const DfSearchableMultiSelectDropdown({
    super.key,
    this.selectedValues,
    this.onSearch,
    this.selectorDecoration,
    super.initData = const [],
    super.labelText,
    super.hintText,
    this.onOptionsSelected,
    this.multiSelectValidator,
    super.decoration,
    super.arrowWidget,
    super.dropdownType = DropdownType.expandable,
    super.disabled = false,
    super.asyncInitData,
    this.closeOnTapOutside = true,
    this.displayResultsCount,
  }) : assert(initData.length == 0 || asyncInitData == null,
            "initData and asyncInitData cannot be provided at the same time");

  /// The currently selected list of dropdown values.
  final List<DropDownModel<T>>? selectedValues;

  /// Callback triggered when options from the dropdown are selected.
  final Function(List<DropDownModel<T>>)? onOptionsSelected;

  /// Provides a [DropDownModel] object if selected, and `null` if not
  ///
  /// Should return `null` when no validation error is present,
  /// and a [String] if there is an error
  ///
  final String? Function(List<DropDownModel<T>>?)? multiSelectValidator;

  /// Function that performs the search operation based on the user's input. It returns a list of filtered options.
  final Future<List<DropDownModel<T>>> Function(String searchText)? onSearch;

  /// Decoration for customizing the multi-select dropdown selector (e.g., background color, height, etc.).
  final MultiSelectorDecoration? selectorDecoration;

  ///Define max count of displayed elements in the dropdown selector
  ///_Default_ value is null, and all available results will be displayed
  final int? displayResultsCount;

  ///Selector widget will be `closed` when pressed outside of the field
  final bool closeOnTapOutside;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SearchableMultiSelectDropdownProvider<T>(
        asyncInitData: asyncInitData,
        initData: initData,
        selectedValues: selectedValues,
        onOptionSelected: onOptionsSelected,
        multiSelectValidator: multiSelectValidator,
        onSearch: onSearch,
        selectorMaxHeight: selectorDecoration?.maxHeight,
        context: context,
        displayResultsCount: displayResultsCount,
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
        closeOnTapOutside: closeOnTapOutside,
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
    required this.closeOnTapOutside,
  });
  final DropdownType dropdownType;
  final DropdownDecoration? decoration;
  final String? labelText;
  final String? hintText;
  final MultiSelectorDecoration? selectorDecoration;
  final Widget? arrowWidget;
  final bool disabled;
  final bool closeOnTapOutside;

  @override
  State<_Dropdown<T>> createState() => _DropdownState<T>();
}

class _DropdownState<T> extends State<_Dropdown<T>> {
  late final Widget selectorWidget;
  @override
  void initState() {
    selectorWidget = Consumer<SearchableMultiSelectDropdownProvider<T>>(
      builder: (_, provider, __) => TapRegion(
        onTapOutside: (_) {
          if (provider.suggestionsExpanded && widget.closeOnTapOutside) {
            if (provider.fieldTapOutside) {
              provider.fieldTapOutside = false;
              provider.closeSuggestions();
            } else {
              provider.selectorTapOutside = true;
            }
          }
        },
        child: SearchableMultiSelectDropdownSelector<T>(
          selectorDecoration: widget.selectorDecoration,
          asyncInitData: provider.asyncInitDataValue,
        ),
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

    return TapRegion(
      onTapOutside: (_) {
        if (provider.suggestionsExpanded && widget.closeOnTapOutside) {
          if (widget.dropdownType == DropdownType.expandable) {
            provider.closeSuggestions();
          } else if (provider.selectorTapOutside) {
            provider.selectorTapOutside = false;
            provider.closeSuggestions();
          } else {
            provider.fieldTapOutside = true;
          }
        }
      },
      child: Column(
        children: [
          DropdownField<SearchableMultiSelectDropdownProvider<T>>(
            disabled: widget.disabled,
            dropdownType: widget.dropdownType,
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
              height: 4,
            ),
            selectorWidget,
          ],
        ],
      ),
    );
  }
}
