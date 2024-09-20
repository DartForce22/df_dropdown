import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    this.suffixWidget,
  });

  final VoidCallback? onTapInside;
  final VoidCallback? onTapOutside;
  final bool outlineBorderVisible;
  final String? labelText;
  final String? hintText;
  final bool disableInput;
  final Widget? suffixWidget;

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
          TapRegion(
            onTapOutside: (_) {
              if (onTapOutside != null) onTapOutside!();
            },
            onTapInside: (_) {
              if (onTapInside != null) onTapInside!();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 6,
                horizontal: 12,
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: provider.fieldBorderColor,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  if (outlineBorderVisible)
                    BoxShadow(
                      color: Colors.teal[450] ?? Colors.teal,
                      spreadRadius: 4,
                    ),
                  if (outlineBorderVisible)
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
                        if (labelText != null &&
                            provider.searchTextController.text.isNotEmpty)
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
                          focusNode: provider.textFieldFocusNode,
                          ignorePointers: disableInput,
                          validator: provider.onValidateField,
                          controller: provider.searchTextController,
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                          onChanged: provider.onInputChanged,
                          decoration: fieldInputDecoration.copyWith(
                            hintText: hintText,
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
                  if (suffixWidget != null) suffixWidget!,
                ],
              ),
            ),
          ),

          //An error message [Text] widget displayed only when validation returns an error
          if (provider.validationError != null)
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
    );
  }
}
