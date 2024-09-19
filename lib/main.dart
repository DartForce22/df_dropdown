import 'dart:developer';

import 'package:df_dropdown/constants/dropdown_enums.dart';
import 'package:df_dropdown/models/drop_down_model.dart';
import 'package:df_dropdown/searchable_drop_down/searchable_drop_down.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: SearchableDropDown(
                onMultiSelect: (items) {
                  log("items $items");
                },
                hint: "Select...",
                dropdownType: DropdownType.searchableSingleSelectDropdown,
                // initialValue: DropDownModel<String>(
                //     id: "1", value: "option 1", text: "Option 1"),
                initialData: [
                  DropDownModel<String>(id: "1", value: "1", text: "Option 1"),
                  DropDownModel<String>(id: "2", value: "2", text: "Option 2"),
                  DropDownModel<String>(id: "3", value: "3", text: "Option 3"),
                  DropDownModel<String>(id: "4", value: "4", text: "Option 4"),
                  DropDownModel<String>(id: "5", value: "5", text: "Option 5"),
                ],
                searchFunction: (text) async {
                  return [];
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
