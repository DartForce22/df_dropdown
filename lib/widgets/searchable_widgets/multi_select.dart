import 'package:flutter/material.dart';

class MultiSelect extends StatelessWidget {
  const MultiSelect({
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
                  activeColor: Colors.teal.shade400,
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
                width: 4,
              ),
              Text(
                text,
                style: textTheme.labelMedium,
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
