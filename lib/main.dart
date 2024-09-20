import 'dart:developer';

import 'package:df_dropdown/df_searchable_dropdown.dart';

import '/models/drop_down_model.dart';
import 'df_simple_dropdown.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SafeArea(
        child: Scaffold(
          body: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    DfSimpleDropdown<String>(
                      hintText: "Select an option...",
                      labelText: "Simple Dropdown",
                      onOptionSelected: (value) {
                        log("SELECTED VALUE ${value.value}");
                      },
                      initData: [
                        DropDownModel<String>(
                            key: "1", value: "1", text: "New York City"),
                        DropDownModel<String>(
                            key: "2", value: "2", text: "Los Angeles"),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    DfSearchableDropdown(
                      hintText: "Start typing..",
                      labelText: "Searchable Dropdown",
                      onSearch: (context) async {
                        return [
                          DropDownModel<String>(
                              key: "4", value: "4", text: "Houston")
                        ];
                      },
                      initData: [
                        DropDownModel<String>(
                            key: "1", value: "1", text: "New York City"),
                        DropDownModel<String>(
                            key: "2", value: "2", text: "Los Angeles"),
                        DropDownModel<String>(
                            key: "3", value: "3", text: "Chicago"),
                        DropDownModel<String>(
                            key: "4", value: "4", text: "Houston"),
                        DropDownModel<String>(
                            key: "5", value: "5", text: "Phoenix"),
                        DropDownModel<String>(
                            key: "3", value: "3", text: "Philadelphia"),
                        DropDownModel<String>(
                            key: "4", value: "4", text: "San Antonio"),
                        DropDownModel<String>(
                            key: "5", value: "5", text: "San Diego"),
                        DropDownModel<String>(
                            key: "3", value: "3", text: "Dallas"),
                        DropDownModel<String>(
                            key: "4", value: "4", text: "Austin"),
                        DropDownModel<String>(
                            key: "5", value: "5", text: "Texas"),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        var isValidForm = formKey.currentState?.validate();

                        log("isValidForm $isValidForm");
                      },
                      child: const Text("Submit"),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
