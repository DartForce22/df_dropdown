import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/df_dropdown.dart';
import '../providers/base_dropdown_provider.dart';

class DropdownContainer<T extends BaseDropdownProvider>
    extends StatelessWidget {
  const DropdownContainer({
    super.key,
    required this.disabled,
    this.addDropdownKey = true,
    this.onTapInside,
    this.onTapOutside,
    this.labelText,
    this.disableInput = false,
    this.outlineBorderVisible = true,
    this.suffixTapEnabled = true,
    this.suffixWidget,
    this.decoration,
    this.child,
    this.contentPadding = const EdgeInsets.symmetric(
      vertical: 6,
      horizontal: 12,
    ),
    required this.dropdownType,
  });

  final VoidCallback? onTapInside;
  final VoidCallback? onTapOutside;
  final bool outlineBorderVisible;
  final String? labelText;
  final bool disableInput;
  final Widget? suffixWidget;
  final bool suffixTapEnabled;
  final bool addDropdownKey;
  final Widget? child;
  final EdgeInsetsGeometry? contentPadding;

  final DropdownDecoration? decoration;
  final bool disabled;
  final DropdownType dropdownType;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return IgnorePointer(
      ignoring: disabled,
      child: Opacity(
        opacity: disabled ? 0.4 : 1,
        child: Consumer<T>(
          builder: (_, provider, child) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FormField(
                builder: (s) => const SizedBox(),
                validator: provider.onValidateField,
              ),
              Container(
                key: addDropdownKey ? provider.dropdownKey : null,
                padding: contentPadding,
                decoration: BoxDecoration(
                  color: decoration?.backgroundColor ?? Colors.transparent,
                  border: Border.all(
                    color: provider.fieldBorderColor(
                      borderColor: decoration?.borderColor,
                      errorBorderColor: decoration?.errorBorderColor,
                    ),
                  ),
                  borderRadius:
                      decoration?.borderRadius ?? BorderRadius.circular(12),
                  boxShadow: [
                    if (outlineBorderVisible &&
                        provider.validationError == null)
                      BoxShadow(
                        color: (decoration?.outlineBorderColor ??
                            (Colors.teal[450] ?? Colors.teal)),
                        spreadRadius: 4,
                      ),
                    if (outlineBorderVisible &&
                        provider.validationError == null)
                      const BoxShadow(
                        color: Colors.white,
                        spreadRadius: 2,
                      )
                  ],
                ),
                height: decoration?.fieldHeight ?? 52,
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TapRegion(
                        onTapOutside: (_) {
                          if (onTapOutside != null &&
                              provider.textFieldFocusNode.hasFocus) {
                            onTapOutside!();
                          }
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
                            if (child != null) child,
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
              ), //An error message [Text] widget displayed only when validation returns an error

              if (((dropdownType == DropdownType.expandable &&
                          !provider.suggestionsExpanded) ||
                      dropdownType == DropdownType.overlay) &&
                  (decoration?.reserveSpaceForValidationMessage != false ||
                      provider.validationError != null))
                Padding(
                  padding: const EdgeInsets.only(
                    top: 4,
                  ),
                  child: Text(
                    provider.validationError ?? "",
                    style: decoration?.errorMessageTextStyle ??
                        textTheme.bodySmall?.copyWith(
                          color: Colors.red.shade500,
                        ),
                  ),
                )
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
