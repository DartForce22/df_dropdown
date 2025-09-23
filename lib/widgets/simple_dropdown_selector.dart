import 'package:df_dropdown/widgets/suggestion_title.dart';
import 'package:flutter/material.dart';

import '/models/drop_down_model.dart';
import '/models/simple_selector_decoration.dart';

const footerTapEvent = "footer_tap";

class SimpleDropdownSelector<T> extends StatelessWidget {
  const SimpleDropdownSelector({
    super.key,
    required this.dropdownData,
    required this.dropdownHeight,
    required this.onSelectSuggestion,
    required this.selectedOption,
    required this.asyncInitData,
    this.selectorDecoration,
    this.expanded = true,
  });

  final List<DropDownModel<T>> dropdownData;
  final double dropdownHeight;
  final SimpleSelectorDecoration? selectorDecoration;
  final Function(DropDownModel<T>) onSelectSuggestion;
  final bool expanded;
  final DropDownModel<T>? selectedOption;

  /// Future that provides the initial list of dropdown options.
  final Future<void> asyncInitData;

  @override
  Widget build(BuildContext context) {
    return Material(
      clipBehavior: Clip.hardEdge,
      borderRadius: selectorDecoration?.borderRadius ?? BorderRadius.circular(12),
      elevation: selectorDecoration?.elevation ?? 4,
      child: FutureBuilder(
        future: asyncInitData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting && dropdownData.isEmpty && dropdownHeight > 0) {
            return selectorDecoration?.loadingIndicator ??
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(4.0),
                    child: CircularProgressIndicator(),
                  ),
                );
          }

          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              borderRadius: selectorDecoration?.borderRadius ?? BorderRadius.circular(12),
              color: selectorDecoration?.selectorColor ?? Colors.white,
            ),
            width: expanded ? double.infinity : null,
            height: dropdownHeight,
            child: dropdownData.isNotEmpty
                ? SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ...dropdownData.map(
                          (suggestion) => _DropdownSuggestion(
                            expanded: expanded,
                            selectorDecoration: selectorDecoration,
                            selected: suggestion == selectedOption,
                            onTap: () {
                              onSelectSuggestion(suggestion);
                            },
                            suggestion: suggestion,
                          ),
                        ),
                        if (selectorDecoration?.footerWidget != null)
                          InkWell(
                            onTap: () {
                              onSelectSuggestion(
                                DropDownModel(
                                  key: footerTapEvent,
                                  text: "",
                                ),
                              );
                            },
                            child: selectorDecoration!.footerWidget!,
                          ),
                      ],
                    ),
                  )
                : Center(
                    child: selectorDecoration?.noAvailableDataWidget ??
                        Text(
                          selectorDecoration?.noAvailableDataText ?? "No available options",
                        ),
                  ),
          );
        },
      ),
    );
  }
}

/// A private stateless widget representing a single suggestion item in a dropdown list.
///
/// Parameters:
/// - `text` (String): The text to be displayed for the suggestion.
/// - `onTap` (VoidCallback): The callback function that is triggered when the
///   suggestion item is tapped.
class _DropdownSuggestion<T> extends StatelessWidget {
  const _DropdownSuggestion({
    required this.onTap,
    required this.selectorDecoration,
    required this.expanded,
    required this.selected,
    required this.suggestion,
  });

  final VoidCallback onTap;
  final SimpleSelectorDecoration? selectorDecoration;
  final bool expanded;
  final bool selected;
  final DropDownModel<T> suggestion;

  TextStyle? get optionTextStyle {
    if (suggestion.disabled && selectorDecoration?.disabledTextStyle != null) {
      return selectorDecoration!.disabledTextStyle;
    } else if (selected && selectorDecoration?.optionTextStyle != null) {
      return selectorDecoration!.optionTextStyle;
    }

    return null;
  }

  TextStyle? get suffixTextStyle {
    if (suggestion.disabled && selectorDecoration?.disabledSuffixTextStyle != null) {
      return selectorDecoration!.disabledSuffixTextStyle;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Material(
      color: selected ? selectorDecoration?.selectedItemColor ?? Colors.transparent : Colors.transparent,
      borderRadius: selectorDecoration?.borderRadius ?? BorderRadius.circular(12),
      child: InkWell(
        onTap: suggestion.disabled ? null : onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            borderRadius: selectorDecoration?.borderRadius ?? BorderRadius.circular(12),
            color: selectorDecoration?.itemColor ?? Colors.transparent,
          ),
          width: expanded ? double.infinity : selectorDecoration?.selectorWidth ?? 164,
          child: Row(
            children: [
              if (suggestion.prefixWidget != null) suggestion.prefixWidget!,
              SuggestionTitle(
                text: suggestion.text,
                subtext: suggestion.subtext,
                subTextStyle: selectorDecoration?.optionSubtextStyle,
                textStyle: optionTextStyle,
              ),
              if (selectorDecoration?.selectedItemIcon != null && selected && !suggestion.disabled) ...[
                const SizedBox(
                  width: 4,
                ),
                selectorDecoration!.selectedItemIcon!,
              ],
              if (suggestion.disabled) ...[
                const SizedBox(
                  width: 4,
                ),
                Flexible(
                  fit: FlexFit.tight,
                  child: Text(
                    suggestion.disabledText ?? "",
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                    style: suffixTextStyle ?? textTheme.labelMedium,
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
