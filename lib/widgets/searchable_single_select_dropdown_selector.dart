import 'package:df_dropdown/models/models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/models/single_selector_decoration.dart';
import '/widgets/searchable_widgets/single_select.dart';
import '../providers/searchable_single_select_dropdown_provider.dart';

class SearchableSingleSelectDropdownSelector<T> extends StatelessWidget {
  const SearchableSingleSelectDropdownSelector({
    super.key,
    required this.selectorDecoration,
    required this.asyncInitData,
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

  final SingleSelectorDecoration? selectorDecoration;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SearchableSingleSelectDropdownProvider<T>>(
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
        child: FutureBuilder(
          future: asyncInitData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting &&
                provider.getDropdownData.isEmpty &&
                provider.suggestionsExpanded) {
              return selectorDecoration?.loadingIndicator ??
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(4.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
            }

            return Column(
              children: [
                if (provider.suggestionsExpanded)
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
                if (provider.suggestionsExpanded)
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
                                InkWell(
                                  onTap: provider.clearSelection,
                                  child: Text(
                                    selectorDecoration?.clearSelectionText ??
                                        "Clear selection",
                                    style:
                                        selectorDecoration?.clearSelectionTextStyle ??
                                            TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.teal.shade400,
                                            ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (provider.getNestedDropdownData.isNotEmpty)
                            Container(
                              width: double.infinity,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: provider.getNestedDropdownData
                                    .map(
                                      (element) => NestedListWidget(
                                        data: element,
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          if (provider.getNestedDropdownData.isEmpty)
                            Column(
                              children: provider.suggestionsExpanded
                                  ? provider.getDropdownData.map(
                                      (suggestion) {
                                        return SingleSelect(
                                          selectorDecoration:
                                              selectorDecoration,
                                          text: suggestion.text,
                                          selected: suggestion ==
                                              provider.selectedValue,
                                          onTap: () {
                                            if (suggestion.disabled) return;
                                            provider
                                                .onSelectSuggestion(suggestion);
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
              ],
            );
          },
        ),
      ),
    );
  }
}

class NestedListWidget extends StatelessWidget {
  const NestedListWidget({super.key, required this.data});

  final DropDownNestedModel data;

  @override
  Widget build(BuildContext context) {
    if (data.title != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(data.title!),
        ],
      );
    }
    if (data.children != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Text(data.title!)],
      );
    }

    if (data.values != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [],
      );
    }

    return SizedBox.shrink();
  }
}
