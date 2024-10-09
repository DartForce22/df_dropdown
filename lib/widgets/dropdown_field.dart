import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/df_dropdown.dart';
import '/widgets/dropdown_container.dart';
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
    required this.disabled,
    required this.dropdownType,
    this.onEditingComplete,
  });

  final VoidCallback? onTapInside;
  final VoidCallback? onTapOutside;
  final bool outlineBorderVisible;
  final String? labelText;
  final String? hintText;
  final bool disableInput;
  final Widget? suffixWidget;
  final bool suffixTapEnabled;
  final bool disabled;
  final DropdownType dropdownType;

  final DropdownDecoration? decoration;
  final void Function()? onEditingComplete;

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
    final provider = Provider.of<T>(context, listen: false);
    return DropdownContainer<T>(
      disabled: disabled,
      decoration: decoration,
      disableInput: disableInput,
      labelText: labelText,
      onTapInside: provider.textFieldFocusNode.hasFocus ? null : onTapInside,
      outlineBorderVisible: outlineBorderVisible,
      suffixTapEnabled: suffixTapEnabled,
      suffixWidget: suffixWidget,
      dropdownType: dropdownType,
      child: TextFormField(
        focusNode: provider.textFieldFocusNode,
        ignorePointers: disableInput,
        controller: provider.searchTextController,
        style: decoration?.dropdownTextStyle,
        onChanged: provider.onInputChanged,
        onTapOutside: (_) {
          onTapOutside!();
        },
        onEditingComplete: onEditingComplete,
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
    );
  }
}
