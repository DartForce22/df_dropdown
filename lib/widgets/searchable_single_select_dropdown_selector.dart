import 'package:df_dropdown/models/models.dart';
import 'package:flutter/material.dart';

import '/widgets/searchable_widgets/single_select.dart';
import '../models/searchable_dropdown_selector_model.dart';

class SearchableSingleSelectDropdownSelector<T> extends StatelessWidget {
  const SearchableSingleSelectDropdownSelector({
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

  final SingleSelectorDecoration? selectorDecoration;
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
                            if (selectorModel.nestedDropdownData?.isNotEmpty ==
                                true)
                              Container(
                                width: double.infinity,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: selectorModel.nestedDropdownData!
                                      .map(
                                        (element) => NestedListWidget(
                                          data: element,
                                          selectorDecoration:
                                              selectorDecoration,
                                          selectedValue:
                                              selectorModel.selectedValue,
                                          onSelectSuggestion: (suggestion) {
                                            if (suggestion.disabled) return;

                                            onSelectSuggestion(suggestion);
                                          },
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            if (selectorModel.nestedDropdownData?.isEmpty ==
                                true)
                              Column(
                                children: suggestionsExpanded
                                    ? selectorModel.dropdownData.map(
                                        (suggestion) {
                                          return SingleSelect(
                                            selectorDecoration:
                                                selectorDecoration,
                                            text: suggestion.text,
                                            subtext: suggestion.subtext,
                                            selected: suggestion ==
                                                selectorModel.selectedValue,
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
