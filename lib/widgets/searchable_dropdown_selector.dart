import 'package:df_dropdown/constants/dropdown_enums.dart';
import 'package:df_dropdown/searchable_drop_down/providers/dropdown_provider.dart';
import 'package:df_dropdown/widgets/searchable_widgets/single_select.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/models/drop_down_model.dart';

class SearchableDropdownSelector extends StatelessWidget {
  const SearchableDropdownSelector({
    super.key,
    required this.suggestionsExpanded,
    required this.dropdownHeight,
    this.onSelectSuggestion,
    this.onAddSuggestion,
    required this.selectedValues,
    required this.selectedValue,
    required this.dropdownType,
    required this.onClearSelection,
  });

  final bool suggestionsExpanded;
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
    final dropdownProvider =
        Provider.of<DropdownProvider>(context, listen: false);
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
                    controller: dropdownProvider.selectorSearchTextController,
                    onChanged: dropdownProvider.onSelectorInputChanged,
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
                            Selector<DropdownProvider, String>(
                              builder: (_, value, __) => Column(
                                children: [
                                  ...dropdownProvider.dropdownData.map(
                                    (suggestion) {
                                      if (dropdownType ==
                                          DropdownType
                                              .searchableSingleSelectDropdown) {
                                        return SingleSelect(
                                          text: suggestion.text,
                                          selected: suggestion == selectedValue,
                                          onTap: () {
                                            if (onSelectSuggestion != null) {
                                              onSelectSuggestion!(suggestion);
                                            }
                                          },
                                        );
                                      }
                                      return SizedBox();
                                    },
                                  ),
                                ],
                              ),
                              selector: (_, provider) =>
                                  provider.selectorSearchTextController.text,
                            )
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
