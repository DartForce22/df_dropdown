import 'package:flutter/material.dart';

class SingleSelect extends StatelessWidget {
  const SingleSelect({
    super.key,
    required this.text,
    required this.onTap,
    required this.selected,
  });

  final String text;
  final VoidCallback onTap;
  final bool selected;

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
                ? Colors.teal[400]?.withOpacity(0.04)
                : Colors.transparent,
          ),
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                text,
                style: textTheme.labelMedium?.copyWith(
                  color: selected ? Colors.teal[400] : null,
                ),
                textAlign: TextAlign.start,
              ),
              if (selected)
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
