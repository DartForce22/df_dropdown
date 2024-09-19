import 'package:flutter/material.dart' hide Icons;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '/constants/icons.dart';
import 'provider/dropdown_provider.dart';

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
    final textTheme = Theme.of(context).textTheme;
    return TapRegion(
      onTapOutside: dropdownProvider.enabledTextInput
          ? null
          : (pointerDownEvent) {
              FocusScope.of(context).requestFocus(FocusNode());
            },
      child: Column(
        children: [
          //Dropdown text input field and validation error text
          Consumer<DropdownProvider>(
            builder: (_, provider, __) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TapRegion(
                  onTapInside: (_) {
                    dropdownProvider.toggleSuggestionsExpanded();
                  },
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
            ),
          ),

          //Dropdown suggestions container
          Material(
            clipBehavior: Clip.hardEdge,
            borderRadius: BorderRadius.circular(12),
            elevation: 4,
            child: Consumer<DropdownProvider>(
              builder: (_, provider, __) => AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                width: double.infinity,
                height: dropdownProvider.dropdownHeight,
                child: provider.suggestionsExpanded
                    ? SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: provider.dropdownData
                              .map(
                                (suggestion) => _DropdownSuggestion(
                                  text: suggestion.text,
                                  onTap: () {
                                    provider.onSelectSuggestion(suggestion);
                                  },
                                ),
                              )
                              .toList(),
                        ),
                      )
                    : const SizedBox(),
              ),
            ),
          )
        ],
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
  });

  final String text;
  final VoidCallback onTap;

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
          child: Text(
            text,
            style: textTheme.labelMedium,
            textAlign: TextAlign.start,
          ),
        ),
      ),
    );
  }
}
