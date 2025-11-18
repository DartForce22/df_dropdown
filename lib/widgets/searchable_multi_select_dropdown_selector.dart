import 'package:df_dropdown/df_dropdown.dart';
import 'package:df_dropdown/models/searchable_dropdown_selector_model.dart';
import 'package:flutter/material.dart';

import '/widgets/searchable_widgets/multi_select.dart';

class SearchableMultiSelectDropdownSelector<T> extends StatelessWidget {
  const SearchableMultiSelectDropdownSelector({
    super.key,
    required this.selectorDecoration,
    required this.asyncInitData,
    required this.selectorModel,
    required this.selectorTextEditingController,
    required this.suggestionsExpanded,
    required this.onInputChanged,
    required this.clearSelection,
    required this.onSelectSuggestion,
  });

  /// Future that provides the initial list of dropdown options.
  final Future<void> asyncInitData;

  ///[InputDecoration] used to remove all predefined values from the [TextFormField]
  final InputDecoration fieldInputDecoration = const InputDecoration(
    border: InputBorder.none,
    errorBorder: InputBorder.none,
    focusedBorder: InputBorder.none,
    enabledBorder: InputBorder.none,
    disabledBorder: InputBorder.none,
  );
  final MultiSelectorDecoration? selectorDecoration;
  final SearchableDropdownSelectorModel<T> selectorModel;
  final TextEditingController selectorTextEditingController;
  final bool suggestionsExpanded;
  final void Function(String) onInputChanged;
  final void Function() clearSelection;
  final void Function(DropDownModel<T>) onSelectSuggestion;

  @override
  Widget build(BuildContext context) {
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
        child: FutureBuilder(
          future: asyncInitData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting &&
                selectorModel.dropdownData.isEmpty &&
                suggestionsExpanded) {
              return selectorDecoration?.loadingIndicator ??
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(4.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
            }

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (suggestionsExpanded)
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
                            controller: selectorTextEditingController,
                            onChanged: onInputChanged,
                            decoration: fieldInputDecoration,
                            style: selectorDecoration?.searchTextStyle,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (suggestionsExpanded)
                  Divider(
                    height: 1,
                    color: selectorDecoration?.dividerColor,
                  ),
                Flexible(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: double.infinity,
                    height: selectorModel.dropdownHeight,
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
                                  if (selectorModel.selectedValues.isNotEmpty &&
                                      selectorDecoration?.showSelectedItems !=
                                          false)
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
                                    onTap: clearSelection,
                                    child: Text(
                                      selectorDecoration?.clearSelectionText ??
                                          "Clear selection",
                                      style: selectorDecoration
                                              ?.clearSelectionTextStyle ??
                                          const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            //Primary color TANGERINE shade 400
                                            color: Color(0xffF38C0D),
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (selectorModel.selectedValues.isNotEmpty &&
                                selectorDecoration?.showSelectedItems != false)
                              Column(
                                children: suggestionsExpanded
                                    ? [
                                        ...selectorModel.selectedValues.map(
                                          (suggestion) {
                                            return MultiSelect(
                                              selectorDecoration:
                                                  selectorDecoration,
                                              text: suggestion.text,
                                              subtext: suggestion.subtext,
                                              selected: true,
                                              onTap: () {
                                                if (suggestion.disabled) return;
                                                onSelectSuggestion(suggestion);
                                              },
                                            );
                                          },
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16),
                                          child: Divider(
                                            height: 1,
                                            color: selectorDecoration
                                                ?.dividerColor,
                                          ),
                                        )
                                      ]
                                    : [],
                              ),
                            Column(
                              children: suggestionsExpanded
                                  ? selectorModel.dropdownData.map(
                                      (suggestion) {
                                        return MultiSelect(
                                          selectorDecoration:
                                              selectorDecoration,
                                          text: suggestion.text,
                                          subtext: suggestion.subtext,
                                          selected: selectorModel.selectedValues
                                              .map((el) => el.key)
                                              .contains(
                                                suggestion.key,
                                              ),
                                          onTap: () {
                                            if (suggestion.disabled) return;

                                            onSelectSuggestion(suggestion);
                                          },
                                        );
                                      },
                                    ).toList()
                                  : [],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
