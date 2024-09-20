import 'package:flutter/material.dart';

class DropdownField extends StatelessWidget {
  const DropdownField({
    super.key,
    required this.onTapInside,
    required this.borderColor,
    this.labelVisible = true,
    this.labelText,
    this.hintVisible = true,
    this.hintText,
    this.focusNode,
    this.disableInput = false,
    this.outlineBorderVisible = true,
    this.validator,
    this.textController,
    this.onInputChanged,
    this.suffixWidget,
    this.validationError,
  });

  final VoidCallback onTapInside;
  final Color borderColor;
  final bool outlineBorderVisible;
  final bool labelVisible;
  final String? labelText;
  final bool hintVisible;
  final String? hintText;
  final bool disableInput;
  final FocusNode? focusNode;
  final String? Function(String?)? validator;
  final TextEditingController? textController;
  final void Function(String)? onInputChanged;
  final Widget? suffixWidget;
  final String? validationError;

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TapRegion(
          onTapInside: (_) {
            onTapInside();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 6,
              horizontal: 12,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: borderColor,
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
                      if (labelVisible && labelText != null)
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
                        focusNode: focusNode,
                        ignorePointers: disableInput,
                        validator: validator,
                        controller: textController,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                        onChanged: onInputChanged,
                        decoration: fieldInputDecoration.copyWith(
                          hintText:
                              hintText != null && hintVisible ? hintText : null,
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
        if (validationError != null)
          Padding(
            padding: const EdgeInsets.only(
              top: 4,
            ),
            child: Text(
              validationError!,
              style: textTheme.bodySmall?.copyWith(
                color: Colors.red.shade500,
              ),
            ),
          )
      ],
    );
  }
}
