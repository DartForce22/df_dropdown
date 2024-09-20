import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/models/multi_selector_decoration.dart';
import '/providers/searchable_multi_select_dropdown_provider.dart';
import '/widgets/searchable_widgets/multi_select.dart';

class SearchableMultiSelectDropdownSelector<T> extends StatelessWidget {
  const SearchableMultiSelectDropdownSelector({
    super.key,
    required this.selectorDecoration,
  });

  ///[InputDecoration] used to remove all predefined values from the [TextFormField]
  final InputDecoration fieldInputDecoration = const InputDecoration(
    border: InputBorder.none,
    errorBorder: InputBorder.none,
    focusedBorder: InputBorder.none,
    enabledBorder: InputBorder.none,
    disabledBorder: InputBorder.none,
  );
  final MultiSelectorDecoration? selectorDecoration;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SearchableMultiSelectDropdownProvider<T>>(
      context,
      listen: false,
    );
    return Material(
      clipBehavior: Clip.hardEdge,
      borderRadius:
          selectorDecoration?.borderRadius ?? BorderRadius.circular(12),
      elevation: selectorDecoration?.elevation ?? 4,
      child: Container(
        decoration: BoxDecoration(
          borderRadius:
              selectorDecoration?.borderRadius ?? BorderRadius.circular(12),
          color: selectorDecoration?.selectorColor ?? Colors.white,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Row(
                children: [
                  if (selectorDecoration?.showSearchIcon != false)
                    selectorDecoration?.searchIcon ??
                        Icon(
                          Icons.search,
                          color: Colors.grey.shade400,
                        ),
                  const SizedBox(
                    width: 4,
                  ),
                  Expanded(
                    child: TextField(
                      controller: provider.selectorTextEditingController,
                      onChanged: provider.onInputChanged,
                      decoration: fieldInputDecoration,
                      style: selectorDecoration?.searchTextStyle,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 1,
              color: selectorDecoration?.dividerColor,
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: double.infinity,
              height: provider.dropdownHeight,
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (provider.selectedValues.isNotEmpty &&
                                selectorDecoration?.showSelectedItems != false)
                              Text(
                                selectorDecoration?.selectedItemsTitle ??
                                    "Selected",
                                style: selectorDecoration
                                        ?.selectedItemsTitleStyle ??
                                    const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            InkWell(
                              onTap: provider.clearSelection,
                              child: Text(
                                selectorDecoration?.clearSelectionText ??
                                    "Clear selection",
                                style: selectorDecoration
                                        ?.clearSelectionTextStyle ??
                                    TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.teal.shade400,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (provider.selectedValues.isNotEmpty &&
                          selectorDecoration?.showSelectedItems != false)
                        Column(
                          children: [
                            ...provider.selectedValues.map(
                              (suggestion) {
                                return MultiSelect(
                                  selectorDecoration: selectorDecoration,
                                  text: suggestion.text,
                                  selected: true,
                                  onTap: () {
                                    provider.onSelectSuggestion(suggestion);
                                  },
                                );
                              },
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Divider(
                                height: 1,
                                color: selectorDecoration?.dividerColor,
                              ),
                            )
                          ],
                        ),
                      Column(
                        children: provider.getDropdownData.map(
                          (suggestion) {
                            return MultiSelect(
                              selectorDecoration: selectorDecoration,
                              text: suggestion.text,
                              selected: provider.selectedValues
                                  .map((el) => el.key)
                                  .contains(
                                    suggestion.key,
                                  ),
                              onTap: () {
                                provider.onSelectSuggestion(suggestion);
                              },
                            );
                          },
                        ).toList(),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
