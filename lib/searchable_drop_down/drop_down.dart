import 'package:flutter/material.dart' hide Icons;
import 'package:provider/provider.dart';

import '/constants/dropdown_enums.dart';
import '/widgets/dropdown_field.dart';
import '/widgets/searchable_dropdown_selector.dart';
import '/widgets/simple_dropdown_selector.dart';
import 'providers/dropdown_provider.dart';

class DropDown extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final String? Function(String?)? validator;

  const DropDown({
    this.labelText,
    this.hintText,
    this.validator,
    super.key,
  });

  ///[InputDecoration] used to remove all predefined values from the [TextFormField]
  final InputDecoration fieldInputDecoration = const InputDecoration(
    error: null,
    errorStyle: TextStyle(
      fontSize: 0,
    ),
    contentPadding: EdgeInsets.all(0),
    border: InputBorder.none,
    errorBorder: InputBorder.none,
    focusedBorder: InputBorder.none,
    enabledBorder: InputBorder.none,
    disabledBorder: InputBorder.none,
    isDense: true,
  );

  @override
  Widget build(BuildContext context) {
    final dropdownProvider =
        Provider.of<DropdownProvider>(context, listen: false);
    return TapRegion(
      onTapOutside: (pointerDownEvent) {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Column(
        children: [
          //Dropdown text input field and validation error text
          Consumer<DropdownProvider>(
            builder: (_, provider, __) => DropdownField(
              onTapInside: () {
                if (!dropdownProvider.enabledTextInput) {
                  dropdownProvider.toggleSuggestionsExpanded();
                }
              },
            ),
            /*  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TapRegion(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: dropdownProvider.fieldBorderColor,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        if (dropdownProvider.suggestionsExpanded)
                          BoxShadow(
                            color: Colors.teal[450] ?? Colors.teal,
                            spreadRadius: 4,
                          ),
                        if (dropdownProvider.suggestionsExpanded)
                          const BoxShadow(
                            color: Colors.white,
                            spreadRadius: 2,
                          )
                      ],
                    ),
                    height: 52,
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (dropdownProvider
                                      .searchTextController.text.isNotEmpty &&
                                  labelText != null)
                                Flexible(
                                  child: FittedBox(
                                    child: Text(
                                      labelText!,
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ),
                                ),
                              TextFormField(
                                focusNode: dropdownProvider.textFieldFocusNode,
                                ignorePointers:
                                    !dropdownProvider.enabledTextInput,
                                validator: (text) {
                                  if (validator != null) {
                                    dropdownProvider.setValidationError =
                                        validator!(text);
                                  }

                                  if (dropdownProvider
                                          .validationError?.isNotEmpty ==
                                      true) {
                                    return '';
                                  }
                                  return null;
                                },
                                controller:
                                    dropdownProvider.searchTextController,
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                                onChanged: dropdownProvider.onInputChanged,
                                decoration: fieldInputDecoration.copyWith(
                                  hintText: dropdownProvider
                                          .searchTextController.text.isEmpty
                                      ? hintText
                                      : null,
                                  hintStyle: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: dropdownProvider.enabledTextInput
                              ? dropdownProvider.toggleSuggestionsExpanded
                              : null,
                          child: SizedBox(
                            height: 48,
                            child: SvgPicture.asset(
                              dropdownProvider.suggestionsExpanded
                                  ? Icons.upIcon
                                  : Icons.downIcon,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),

                //An error message [Text] widget displayed only when validation returns an error
                if (provider.validationError != null &&
                    (!dropdownProvider.suggestionsExpanded ||
                        dropdownProvider.searchResults.isEmpty))
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 4,
                    ),
                    child: Text(
                      provider.validationError!,
                      style: textTheme.bodySmall?.copyWith(
                        color: Colors.red.shade500,
                      ),
                    ),
                  )
              ],
            ),*/
          ),
          const SizedBox(
            height: 6,
          ),

          if (dropdownProvider.dropdownType ==
                  DropdownType.searchableDropdown ||
              dropdownProvider.dropdownType == DropdownType.simpleDropdown)
            //Dropdown suggestions container
            Consumer<DropdownProvider>(
              builder: (_, provider, __) => SimpleDropdownSelector(
                dropdownData: provider.dropdownData,
                dropdownHeight: provider.dropdownHeight,
                onSelectSuggestion: provider.onSelectSuggestion,
                suggestionsExpanded: provider.suggestionsExpanded,
              ),
            ),

          if (dropdownProvider.dropdownType ==
                  DropdownType.searchableMultiSelectDropdown ||
              dropdownProvider.dropdownType ==
                  DropdownType.searchableSingleSelectDropdown)
            //Dropdown suggestions container
            Consumer<DropdownProvider>(
              builder: (_, provider, __) => SearchableDropdownSelector(
                dropdownHeight: provider.dropdownHeight,
                selectedValue: provider.selectedValue,
                onSelectSuggestion: (value) {
                  if (dropdownProvider.dropdownType ==
                      DropdownType.searchableSingleSelectDropdown) {
                    provider.onSelectSuggestion(value);
                  }
                },
                onAddSuggestion: (value) {
                  if (dropdownProvider.dropdownType ==
                      DropdownType.searchableMultiSelectDropdown) {
                    provider.onMultiSelectSuggestion(value);
                  }
                },
                suggestionsExpanded: provider.suggestionsExpanded,
                selectedValues: provider.selectedValues,
                dropdownType: provider.dropdownType,
                onClearSelection: provider.onClearSelection,
              ),
            ),
        ],
      ),
    );
  }
}
