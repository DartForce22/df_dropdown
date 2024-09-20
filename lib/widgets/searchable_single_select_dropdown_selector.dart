import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/providers/single_select_searchable_dropdown_provider.dart';
import '/widgets/searchable_widgets/single_select.dart';

class SearchableSingleSelectDropdownSelector<T> extends StatelessWidget {
  const SearchableSingleSelectDropdownSelector({
    super.key,
  });

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
    final provider = Provider.of<SingleSelectSearchableDropdownProvider<T>>(
      context,
      listen: false,
    );
    return Material(
      clipBehavior: Clip.hardEdge,
      borderRadius: BorderRadius.circular(12),
      elevation: 4,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Row(
                children: [
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
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              height: 1,
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
                            InkWell(
                              onTap: provider.clearSelection,
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
                      Column(
                        children: provider.getDropdownData.map(
                          (suggestion) {
                            return SingleSelect(
                              text: suggestion.text,
                              selected: suggestion == provider.selectedValue,
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
