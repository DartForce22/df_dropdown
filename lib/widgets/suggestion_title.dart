import 'package:flutter/material.dart';

class SuggestionTitle extends StatelessWidget {
  const SuggestionTitle({
    required this.text,
    this.subtext,
    this.textStyle,
    this.subTextStyle,
    super.key,
  });

  final String text;
  final String? subtext;
  final TextStyle? textStyle;
  final TextStyle? subTextStyle;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Expanded(
      child: Row(
        spacing: 4,
        children: [
          Flexible(
            flex: 1,
            child: Text(
              text,
              style: textStyle ?? textTheme.labelMedium,
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (subtext != null)
            Expanded(
              flex: 2,
              child: Text(
                subtext!,
                style: subTextStyle ?? textTheme.labelMedium,
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
      ),
    );
  }
}
