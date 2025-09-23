import 'package:df_dropdown/models/models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      borderRadius: selectorDecoration?.borderRadius ?? BorderRadius.circular(12),
      elevation: selectorDecoration?.elevation ?? 4,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: selectorDecoration?.borderRadius ?? BorderRadius.circular(12),
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
                                    selectorDecoration?.clearSelectionText ?? "Clear selection",
                                    style: selectorDecoration?.clearSelectionTextStyle ??
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
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: provider.getNestedDropdownData
                                    .map(
                                      (element) => NestedListWidget(
                                        data: element,
                                        selectorDecoration: selectorDecoration,
                                        selectedValue: provider.selectedValue,
                                        onSelectSuggestion: (suggestion) {
                                          if (suggestion.disabled) return;
                                          provider.onSelectSuggestion(suggestion);
                                        },
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
                                          selectorDecoration: selectorDecoration,
                                          text: suggestion.text,
                                          subtext: suggestion.subtext,
                                          selected: suggestion == provider.selectedValue,
                                          onTap: () {
                                            if (suggestion.disabled) return;
                                            provider.onSelectSuggestion(suggestion);
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

class NestedListWidget<T> extends StatelessWidget {
  const NestedListWidget({
    super.key,
    required this.data,
    required this.selectorDecoration,
    required this.onSelectSuggestion,
    required this.selectedValue,
    this.level = 0,
  });

  final DropDownNestedModel<T> data;
  final int level;
  final SingleSelectorDecoration? selectorDecoration;
  final void Function(DropDownModel<T>) onSelectSuggestion;
  final DropDownModel<T>? selectedValue;

  @override
  Widget build(BuildContext context) {
    String getTitle() {
      if (level == 0) {
        return (data.title ?? "").toUpperCase();
      }
      return data.title ?? "";
    }

    if (data.title != null) {
      return Padding(
        padding: EdgeInsets.only(left: level * 2, bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              getTitle(),
              style: selectorDecoration?.nestedOptionTitleTextStyle,
            ),
            const SizedBox(
              height: 8,
            ),
            if (data.children?.isNotEmpty == true)
              ...data.children!.map(
                (element) => NestedListWidget(
                  data: element,
                  level: level + 1,
                  selectorDecoration: selectorDecoration,
                  onSelectSuggestion: onSelectSuggestion,
                  selectedValue: selectedValue,
                ),
              ),
            if (data.values?.isNotEmpty == true)
              ...data.values!.map(
                (value) => NestedSelectableOption<T>(
                  option: value,
                  selectorDecoration: selectorDecoration,
                  onSelectSuggestion: onSelectSuggestion,
                  selectedValue: selectedValue,
                ),
              ),
          ],
        ),
      );
    }
    if (data.children != null) {
      return Padding(
        padding: EdgeInsets.only(left: level * 2, bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              getTitle(),
              style: selectorDecoration?.nestedOptionTitleTextStyle,
            ),
            const SizedBox(
              height: 4,
            ),
            if (data.children?.isNotEmpty == true)
              ...data.children!.map(
                (element) => NestedListWidget<T>(
                  data: element,
                  selectorDecoration: selectorDecoration,
                  onSelectSuggestion: onSelectSuggestion,
                  selectedValue: selectedValue,
                ),
              ),
          ],
        ),
      );
    }

    if (data.values != null) {
      return Padding(
        padding: EdgeInsets.only(left: level * 2, bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: data.values!
              .map(
                (el) => NestedSelectableOption<T>(
                  option: el,
                  selectorDecoration: selectorDecoration,
                  onSelectSuggestion: onSelectSuggestion,
                  selectedValue: selectedValue,
                ),
              )
              .toList(),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}

class NestedSelectableOption<T> extends StatelessWidget {
  const NestedSelectableOption({
    required this.option,
    required this.selectorDecoration,
    required this.onSelectSuggestion,
    required this.selectedValue,
    super.key,
  });

  final DropDownModel<T> option;
  final SingleSelectorDecoration? selectorDecoration;
  final void Function(DropDownModel<T>) onSelectSuggestion;
  final DropDownModel<T>? selectedValue;

  @override
  Widget build(BuildContext context) {
    return SingleSelect(
      selectorDecoration: selectorDecoration,
      text: option.text,
      subtext: option.subtext,
      verticalPadding: 4,
      selected: selectedValue == option,
      onTap: () {
        if (option.disabled) return;
        onSelectSuggestion(option);
      },
    );
  }
}
