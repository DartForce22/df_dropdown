import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/enums/dropdown_type.dart';
import '/models/drop_down_model.dart';
import '/models/dropdown_decoration.dart';
import '/models/simple_selector_decoration.dart';
import '/widgets/dropdown_field.dart';
import '/widgets/simple_dropdown_selector.dart';
import 'providers/searchable_dropdown_provider.dart';

class DfSearchableDropdown<T> extends StatelessWidget {
  /// Constructor for [DfSearchableDropdown].
  ///
  /// - [initData]: Initial list of data for the dropdown.
  /// - [selectedValue]: Currently selected value.
  /// - [labelText]: Text for the label of the dropdown.
  /// - [hintText]: Placeholder text shown when no value is selected.
  /// - [onOptionSelected]: Callback function triggered when an option is selected.
  /// - [validator]: Optional validation function for the dropdown selection.
  /// - [onSearch]: Function to perform a search based on user input, returning a filtered list of dropdown options.
  /// - [decoration]: Custom styling for the dropdown field.
  /// - [selectorDecoration]: Additional custom styling for the dropdown selector.
  /// - [arrowWidget]: Widget for the arrow icon displayed in the dropdown.
  /// - [dropdownType]: Default value is `DropdownType.expandable`, and it's used to switch between the expandable, and
  /// the overlay appearance
  const DfSearchableDropdown({
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
    this.closeOnTapOutside = true,
    this.rememberSelectedValue = true,
    this.asyncInitData,
    this.expandableSelectorBottomMargin = 4,
  }) : assert(initData.length == 0 || asyncInitData == null,
            "initData and asyncInitData cannot be provided at the same time");

  ///Default value is `DropdownType.expandable`, and it's used to switch between the expandable, and
  /// the overlay appearance
  final DropdownType dropdownType;

  /// Initial list of dropdown options.
  final List<DropDownModel<T>> initData;

  /// Future that provides the initial list of dropdown options.
  final Future<List<DropDownModel<T>>>? asyncInitData;

  /// Decoration for customizing the simple dropdown selector (e.g., background color, height, etc.).
  final SimpleSelectorDecoration? selectorDecoration;

  /// The currently selected dropdown value.
  final DropDownModel<T>? selectedValue;

  /// The label text for the dropdown field.
  final String? labelText;

  /// Placeholder text displayed when no value is selected.
  final String? hintText;

  /// Callback triggered when an option from the dropdown is selected.
  final Function(DropDownModel<T>?)? onOptionSelected;

  /// Provides a [DropDownModel] object if selected, and `null` if not
  ///
  /// Should return `null` when no validation error is present,
  /// and a [String] if there is an error
  ///
  final String? Function(DropDownModel<T>?)? validator;

  /// Function that performs the search operation based on the user's input. It returns a list of filtered options.
  final Future<List<DropDownModel<T>>> Function(String searchText)? onSearch;

  /// Decoration for customizing the dropdown's appearance (e.g., border, padding, etc.).
  final DropdownDecoration? decoration;

  /// Widget displayed for the dropdown arrow icon.
  final Widget? arrowWidget;

  final bool disabled;

  ///Selector widget will be `closed` when pressed outside of the field
  final bool closeOnTapOutside;

  ///Default is set to _true_, and if set to _false_, the selected value will not be remembered
  ///when the dropdown is closed and reopened
  final bool rememberSelectedValue;

  /// Bottom margin when the [DropdownType] is set to [DropdownType.expandable]
  /// Default is set to `4`
  final double expandableSelectorBottomMargin;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SearchableDropdownProvider<T>(
        rememberSelectedValue: rememberSelectedValue,
        initData: initData,
        selectedValue: selectedValue,
        onOptionSelected: onOptionSelected,
        validator: validator,
        onSearch: onSearch,
        selectorMaxHeight: selectorDecoration?.maxHeight,
        context: context,
        asyncInitData: asyncInitData,
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
        expandableSelectorBottomMargin: expandableSelectorBottomMargin,
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
    required this.expandableSelectorBottomMargin,
  });

  final SimpleSelectorDecoration? selectorDecoration;
  final DropdownDecoration? decoration;
  final String? labelText;
  final String? hintText;
  final Widget? arrowWidget;
  final DropdownType dropdownType;
  final bool disabled;
  final bool closeOnTapOutside;
  final double expandableSelectorBottomMargin;

  @override
  State<_Dropdown<T>> createState() => _DropdownState<T>();
}

class _DropdownState<T> extends State<_Dropdown<T>> {
  late final Widget selectorWidget;

  @override
  void initState() {
    final selectorProvider = context.read<SearchableDropdownProvider<T>>();

    selectorWidget = TapRegion(
      onTapOutside: (_) {
        if (selectorProvider.suggestionsExpanded && widget.closeOnTapOutside) {
          if (selectorProvider.fieldTapOutside) {
            selectorProvider.fieldTapOutside = false;
            selectorProvider.closeSuggestions();
          } else {
            selectorProvider.selectorTapOutside = true;
          }
        }
      },
      child: Consumer<SearchableDropdownProvider<T>>(
        builder: (_, provider, __) {
          final footerWidgetHeight =
              widget.selectorDecoration?.footerWidget != null && provider.suggestionsExpanded ? 40 : 0;
          return SimpleDropdownSelector<T>(
            asyncInitData: provider.asyncInitDataValue,
            selectorDecoration: widget.selectorDecoration,
            selectedOption: provider.selectedValue,
            dropdownData: provider.suggestionsExpanded ? provider.getDropdownData : [],
            dropdownHeight: provider.dropdownHeight + footerWidgetHeight,
            onSelectSuggestion: provider.onSelectSuggestion,
          );
        },
      ),
    );
    super.initState();
    if (widget.dropdownType == DropdownType.overlay) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        selectorProvider.updateSelectorPositionIfNeeded(
          selectorWidget: ChangeNotifierProvider.value(
            value: selectorProvider,
            child: selectorWidget,
          ),
        );
      });
    }

    selectorProvider.textFieldFocusNode.addListener(() {
      if (selectorProvider.textFieldFocusNode.hasFocus && !selectorProvider.suggestionsExpanded) {
        expandCloseSelector(context);
      }
    });
  }

  void expandCloseSelector(BuildContext context) {
    context.read<SearchableDropdownProvider<T>>().toggleSuggestionsExpanded(
          selectorWidget: widget.dropdownType == DropdownType.expandable
              ? null
              : ChangeNotifierProvider.value(
                  value: context.read<SearchableDropdownProvider<T>>(),
                  child: selectorWidget,
                ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SearchableDropdownProvider<T>>(context, listen: false);

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
          DropdownField<SearchableDropdownProvider<T>>(
            disabled: widget.disabled,
            onEditingComplete: () {
              if (provider.searchTextController.text.isEmpty) {
                provider.onSelectSuggestion(null);
              } else if (provider.selectedValue != null &&
                  provider.selectedValue?.text != provider.searchTextController.text) {
                provider.searchTextController.text = provider.selectedValue!.displayText;
              }

              FocusScope.of(context).requestFocus(FocusNode());
              provider.closeSuggestions();
            },
            dropdownType: widget.dropdownType,
            decoration: widget.decoration,
            hintText: widget.hintText,
            labelText: widget.labelText,
            outlineBorderVisible: provider.suggestionsExpanded || provider.textFieldFocusNode.hasFocus,
            onTapOutside: () {
              provider.onTapOutside(context);
            },
            suffixTapEnabled: false,
            suffixWidget: GestureDetector(
              onTap: () {
                expandCloseSelector(context);
              },
              child: SizedBox(
                height: 48,
                child: widget.arrowWidget ??
                    Icon(
                      context.watch<SearchableDropdownProvider<T>>().suggestionsExpanded
                          ? Icons.keyboard_arrow_up_outlined
                          : Icons.keyboard_arrow_down_outlined,
                    ),
              ),
            ),
          ),
          if (widget.dropdownType == DropdownType.expandable) ...[
            const SizedBox(
              height: 4,
            ),
            selectorWidget,
            SizedBox(
              height: widget.expandableSelectorBottomMargin,
            ),
          ],
        ],
      ),
    );
  }
}
