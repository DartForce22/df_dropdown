import 'package:df_dropdown/widgets/suggestion_title.dart';
import 'package:flutter/material.dart';

import '/models/single_selector_decoration.dart';

class SingleSelect extends StatelessWidget {
  const SingleSelect({
    super.key,
    required this.text,
    required this.subtext,
    required this.onTap,
    required this.selected,
    required this.selectorDecoration,
    this.verticalPadding,
  });

  final String text;
  final String? subtext;
  final VoidCallback onTap;
  final bool selected;
  final SingleSelectorDecoration? selectorDecoration;
  final double? verticalPadding;

  @override
  Widget build(BuildContext context) {
    const orangePrimaryShade500 = Color(0xffff7621);
    final textTheme = Theme.of(context).textTheme;
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: verticalPadding ?? 10,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: selected
                ? selectorDecoration?.singleSelectedItemBgColor ??
                    (selectorDecoration?.selectedItemColor ??
                            orangePrimaryShade500)
                        .withValues(alpha: 0.04)
                : Colors.transparent,
          ),
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SuggestionTitle(
                text: text,
                textStyle: (selectorDecoration?.optionTextStyle ??
                        textTheme.labelMedium)
                    ?.copyWith(
                  color: selected
                      ? (selectorDecoration?.selectedItemColor ??
                          orangePrimaryShade500)
                      : null,
                ),
                subtext: subtext,
                subTextStyle: selectorDecoration?.optionSubtextStyle,
              ),
              if (selected &&
                  selectorDecoration?.selectedItemIconVisible != false)
                selectorDecoration?.selectedItemIcon ??
                    const Icon(
                      Icons.check,
                      size: 15,
                      color: orangePrimaryShade500,
                    )
            ],
          ),
        ),
      ),
    );
  }
}
