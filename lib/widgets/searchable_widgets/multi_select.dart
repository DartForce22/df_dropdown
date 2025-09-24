import 'package:df_dropdown/widgets/suggestion_title.dart';
import 'package:flutter/material.dart';

import '/models/multi_selector_decoration.dart';

class MultiSelect extends StatelessWidget {
  const MultiSelect({
    super.key,
    required this.text,
    required this.subtext,
    required this.onTap,
    required this.selected,
    required this.selectorDecoration,
  });

  final String text;
  final String? subtext;
  final VoidCallback onTap;
  final bool selected;
  final MultiSelectorDecoration? selectorDecoration;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selectorDecoration?.itemColor ?? Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            borderRadius: selectorDecoration?.borderRadius ?? BorderRadius.circular(12),
            color: Colors.transparent,
          ),
          width: double.infinity,
          child: Row(
            children: [
              SizedBox(
                height: 20,
                width: 20,
                child: Checkbox(
                  visualDensity: VisualDensity.compact,
                  value: selected,
                  activeColor: selectorDecoration?.selectedItemColor ?? Colors.teal.shade400,
                  side: BorderSide(
                    color: Colors.grey.shade400,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  onChanged: (_) {
                    onTap();
                  },
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              SuggestionTitle(
                text: text,
                textStyle: selectorDecoration?.optionTextStyle,
                subtext: subtext,
                subTextStyle: selectorDecoration?.optionSubtextStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
