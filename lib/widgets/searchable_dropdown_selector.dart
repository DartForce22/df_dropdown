import 'package:flutter/material.dart';

import '/models/drop_down_model.dart';

class SearchableDropdownSelector extends StatelessWidget {
  const SearchableDropdownSelector({
    super.key,
    required this.suggestionsExpanded,
    required this.dropdownData,
    required this.dropdownHeight,
    required this.onSelectSuggestion,
    required this.selectedValues,
  });

  final bool suggestionsExpanded;
  final List<DropDownModel> dropdownData;
  final double dropdownHeight;
  final Function(DropDownModel) onSelectSuggestion;
  final List<DropDownModel<dynamic>> selectedValues;

  ///[InputDecoration] used to remove all predefined values from the [TextFormField]
  final InputDecoration fieldInputDecoration = const InputDecoration(
    border: InputBorder.none,
    errorBorder: InputBorder.none,
    focusedBorder: InputBorder.none,
    enabledBorder: InputBorder.none,
    disabledBorder: InputBorder.none,
  );

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
            ? Column(
                children: [
                  TextField(
                    decoration: fieldInputDecoration.copyWith(
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ),
                  const Divider(
                    height: 1,
                  ),
                  Expanded(
                    child: Scrollbar(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: dropdownData
                              .map(
                                (suggestion) => _DropdownSuggestion(
                                  text: suggestion.text,
                                  selected: selectedValues.contains(suggestion),
                                  onTap: () {
                                    onSelectSuggestion(suggestion);
                                  },
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                  ),
                ],
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
    required this.selected,
  });

  final String text;
  final VoidCallback onTap;
  final bool selected;

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
          child: Row(
            children: [
              SizedBox(
                height: 20,
                width: 20,
                child: Checkbox(
                  visualDensity: VisualDensity.compact,
                  value: selected,
                  activeColor: Colors.teal.shade400,
                  side: BorderSide(
                    color: Colors.grey.shade400,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  onChanged: (_) {
                    onTap();
                  },
                ),
              ),
              const SizedBox(
                width: 4,
              ),
              Text(
                text,
                style: textTheme.labelMedium,
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
