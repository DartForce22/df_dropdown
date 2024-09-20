import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/models/dropdown_decoration.dart';
import '../providers/base_dropdown_provider.dart';

class DropdownField<T extends BaseDropdownProvider> extends StatelessWidget {
  const DropdownField({
    super.key,
    this.onTapInside,
    this.onTapOutside,
    this.labelText,
    this.hintText,
    this.disableInput = false,
    this.outlineBorderVisible = true,
    this.suffixTapEnabled = true,
    this.suffixWidget,
    this.decoration,
  });

  final VoidCallback? onTapInside;
  final VoidCallback? onTapOutside;
  final bool outlineBorderVisible;
  final String? labelText;
  final String? hintText;
  final bool disableInput;
  final Widget? suffixWidget;
  final bool suffixTapEnabled;

  final DropdownDecoration? decoration;

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
    final textTheme = Theme.of(context).textTheme;
    return Consumer<T>(
      builder: (_, provider, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 6,
              horizontal: 12,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: provider.fieldBorderColor(
                  borderColor: decoration?.borderColor,
                  errorBorderColor: decoration?.errorBorderColor,
                ),
              ),
              borderRadius:
                  decoration?.borderRadius ?? BorderRadius.circular(12),
              boxShadow: [
                if (outlineBorderVisible && provider.validationError == null)
                  BoxShadow(
                    color: (decoration?.outlineBorderColor ??
                        (Colors.teal[450] ?? Colors.teal)),
                    spreadRadius: 4,
                  ),
                if (outlineBorderVisible && provider.validationError == null)
                  const BoxShadow(
                    color: Colors.white,
                    spreadRadius: 2,
                  )
              ],
            ),
            height: decoration?.fieldHeight ?? 54,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TapRegion(
                    onTapOutside: (_) {
                      if (onTapOutside != null) onTapOutside!();
                    },
                    onTapInside: (_) {
                      if (onTapInside != null) onTapInside!();
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (labelText != null &&
                            provider.searchTextController.text.isNotEmpty)
                          Flexible(
                            child: FittedBox(
                              child: Text(
                                labelText!,
                                style: decoration?.labelTextStyle ??
                                    TextStyle(
                                      color: Colors.grey.shade600,
                                    ),
                              ),
                            ),
                          ),
                        TextFormField(
                          focusNode: provider.textFieldFocusNode,
                          ignorePointers: disableInput,
                          validator: provider.onValidateField,
                          controller: provider.searchTextController,
                          style: decoration?.dropdownTextStyle,
                          onChanged: provider.onInputChanged,
                          decoration: fieldInputDecoration.copyWith(
                            hintText: hintText,
                            hintStyle: decoration?.hintTextStyle ??
                                TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (suffixWidget != null)
                  GestureDetector(
                    onTap: onTapInside,
                    child: suffixWidget,
                  ),
              ],
            ),
          ),

          //An error message [Text] widget displayed only when validation returns an error
          if (provider.validationError != null && !provider.suggestionsExpanded)
            Padding(
              padding: const EdgeInsets.only(
                top: 4,
              ),
              child: Text(
                provider.validationError!,
                style: decoration?.errorMessageTextStyle ??
                    textTheme.bodySmall?.copyWith(
                      color: Colors.red.shade500,
                    ),
              ),
            )
        ],
      ),
    );
  }
}
