import 'package:df_dropdown/providers/simple_dropdown_provider.dart';
import 'package:df_dropdown/widgets/dropdown_field.dart';
import 'package:df_dropdown/widgets/simple_dropdown_selector.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SimpleDropdown extends StatelessWidget {
  const SimpleDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SimpleDropdownProvider(),
      builder: (_, __) => Column(
        children: [
          DropdownField(
            onTapInside: context
                .read<SimpleDropdownProvider>()
                .toggleSuggestionsExpanded,
          ),
          Consumer<SimpleDropdownProvider>(
            builder: (_, provider, __) => SimpleDropdownSelector(
              dropdownData: provider.initData,
              dropdownHeight: provider.dropdownHeight,
              onSelectSuggestion: provider.onSelectSuggestion,
              suggestionsExpanded: provider.suggestionsExpanded,
            ),
          )
        ],
      ),
    );
  }
}
