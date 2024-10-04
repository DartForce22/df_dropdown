import 'package:flutter/material.dart';

import '/models/drop_down_model.dart';
import '/models/simple_selector_decoration.dart';

class SimpleDropdownSelector<T> extends StatelessWidget {
  const SimpleDropdownSelector({
    super.key,
    required this.dropdownData,
    required this.dropdownHeight,
    required this.onSelectSuggestion,
    this.selectorDecoration,
    this.expanded = true,
  });

  final List<DropDownModel<T>> dropdownData;
  final double dropdownHeight;
  final SimpleSelectorDecoration? selectorDecoration;
  final Function(DropDownModel<T>) onSelectSuggestion;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    return Material(
      clipBehavior: Clip.hardEdge,
      borderRadius:
          selectorDecoration?.borderRadius ?? BorderRadius.circular(12),
      elevation: selectorDecoration?.elevation ?? 4,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius:
              selectorDecoration?.borderRadius ?? BorderRadius.circular(12),
          color: selectorDecoration?.selectorColor ?? Colors.white,
        ),
        width: expanded ? double.infinity : null,
        height: dropdownHeight,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: dropdownData
                .map(
                  (suggestion) => _DropdownSuggestion(
                    expanded: expanded,
                    selectorDecoration: selectorDecoration,
                    text: suggestion.text,
                    onTap: () {
                      onSelectSuggestion(suggestion);
                    },
                  ),
                )
                .toList(),
          ),
        ),
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
class _DropdownSuggestion extends StatelessWidget {
  const _DropdownSuggestion({
    required this.text,
    required this.onTap,
    required this.selectorDecoration,
    required this.expanded,
  });

  final String text;
  final VoidCallback onTap;
  final SimpleSelectorDecoration? selectorDecoration;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Material(
      color: Colors.transparent,
      borderRadius:
          selectorDecoration?.borderRadius ?? BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            borderRadius:
                selectorDecoration?.borderRadius ?? BorderRadius.circular(12),
            color: selectorDecoration?.itemColor ?? Colors.transparent,
          ),
          width: expanded ? double.infinity : 164,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  text,
                  style: selectorDecoration?.optionTextStyle ??
                      textTheme.labelMedium,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(
                width: 4,
              ),
              Icon(
                Icons.check,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
