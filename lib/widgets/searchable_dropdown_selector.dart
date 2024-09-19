import 'package:df_dropdown/constants/dropdown_enums.dart';
import 'package:df_dropdown/widgets/searchable_widgets/single_select.dart';
import 'package:flutter/material.dart';

import '/models/drop_down_model.dart';

class SearchableDropdownSelector extends StatelessWidget {
  const SearchableDropdownSelector({
    super.key,
    required this.suggestionsExpanded,
    required this.dropdownData,
    required this.dropdownHeight,
    this.onSelectSuggestion,
    this.onAddSuggestion,
    required this.selectedValues,
    required this.selectedValue,
    required this.dropdownType,
    required this.onClearSelection,
  });

  final bool suggestionsExpanded;
  final List<DropDownModel> dropdownData;
  final double dropdownHeight;
  final Function(DropDownModel)? onSelectSuggestion;
  final Function(DropDownModel)? onAddSuggestion;
  final List<DropDownModel> selectedValues;
  final DropDownModel? selectedValue;
  final DropdownType dropdownType;
  final VoidCallback onClearSelection;

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
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 8,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  if (dropdownType ==
                                      DropdownType
                                          .searchableMultiSelectDropdown)
                                    Text("Selected"),
                                  InkWell(
                                    onTap: onClearSelection,
                                    child: Text(
                                      "Clear selection",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.teal.shade400,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ...dropdownData.map(
                              (suggestion) => SingleSelect(
                                text: suggestion.text,
                                selected: selectedValues.contains(suggestion) ||
                                    suggestion == selectedValue,
                                onTap: () {
                                  if (dropdownType ==
                                          DropdownType
                                              .searchableMultiSelectDropdown &&
                                      onAddSuggestion != null) {
                                    onAddSuggestion!(suggestion);
                                  } else if (onSelectSuggestion != null) {
                                    onSelectSuggestion!(suggestion);
                                  }
                                },
                              ),
                            ),
                          ],
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
