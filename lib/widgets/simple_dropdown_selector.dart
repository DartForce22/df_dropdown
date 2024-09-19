import 'package:flutter/material.dart';

import '/models/drop_down_model.dart';

class SimpleDropdownSelector extends StatelessWidget {
  const SimpleDropdownSelector({
    super.key,
    required this.suggestionsExpanded,
    required this.dropdownData,
    required this.dropdownHeight,
    required this.onSelectSuggestion,
  });

  final bool suggestionsExpanded;
  final List<DropDownModel> dropdownData;
  final double dropdownHeight;
  final Function(DropDownModel) onSelectSuggestion;

  @override
  Widget build(BuildContext context) {
    return Material(
      clipBehavior: Clip.hardEdge,
      borderRadius: BorderRadius.circular(12),
      elevation: 4,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        width: double.infinity,
        height: dropdownHeight,
        child: suggestionsExpanded
            ? SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: dropdownData
                      .map(
                        (suggestion) => _DropdownSuggestion(
                          text: suggestion.text,
                          onTap: () {
                            onSelectSuggestion(suggestion);
                          },
                        ),
                      )
                      .toList(),
                ),
              )
            : const SizedBox(),
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
  });

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.transparent,
          ),
          width: double.infinity,
          child: Text(
            text,
            style: textTheme.labelMedium,
            textAlign: TextAlign.start,
          ),
        ),
      ),
    );
  }
}
