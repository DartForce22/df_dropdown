import '/models/single_selector_decoration.dart';
import 'package:flutter/material.dart';

class SingleSelect extends StatelessWidget {
  const SingleSelect({
    super.key,
    required this.text,
    required this.onTap,
    required this.selected,
    required this.selectorDecoration,
  });

  final String text;
  final VoidCallback onTap;
  final bool selected;
  final SingleSelectorDecoration? selectorDecoration;

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
            color: selected
                ? (selectorDecoration?.selectedItemColor ?? Colors.teal[400])
                    ?.withOpacity(0.04)
                : Colors.transparent,
          ),
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                text,
                style: (selectorDecoration?.optionTextStyle ??
                        textTheme.labelMedium)
                    ?.copyWith(
                  color: selected
                      ? (selectorDecoration?.selectedItemColor ??
                          Colors.teal[400])
                      : null,
                ),
                textAlign: TextAlign.start,
              ),
              if (selected &&
                  selectorDecoration?.selectedItemIconVisible != false)
                selectorDecoration?.selectedItemIcon ??
                    Icon(
                      Icons.check,
                      size: 15,
                      color: Colors.teal[400],
                    )
            ],
          ),
        ),
      ),
    );
  }
}
