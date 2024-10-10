import 'dart:developer';

import 'package:df_dropdown/df_dropdown.dart';
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
                clipBehavior: Clip.none,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DfDropdownWrapper(
                      validator: (obj) {
                        return "This is a really long validation error, an this is how it will be displayed...";
                      },
                      child: Row(
                        children: [
                          SizedBox(
                            width: 4,
                          ),
                          Icon(Icons.car_rental),
                          SizedBox(
                            width: 4,
                          ),
                          Text("Custom Dropdown Example"),
                        ],
                      ),
                      decoration: DropdownDecoration(
                        backgroundColor: Colors.greenAccent,
                      ),
                      selectorDecoration: SimpleSelectorDecoration(
                        selectedItemIcon: Icon(
                          Icons.cabin,
                        ),
                        selectedItemColor: Colors.blue.withOpacity(
                          0.4,
                        ),
                      ),
                      onOptionSelected: (option) {
                        log("Option selected ${option}");
                      },
                      selectedValue: DropDownModel<String>(
                        key: "1",
                        value: "1",
                        text: "New York City",
                      ),
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
                    DfSimpleDropdown<String>(
                      validator: (obj) {
                        return "This is a really long validation error, an this is how it will be displayed...";
                      },
                      //dropdownType: DropdownType.overlay,
                      decoration: DropdownDecoration(
                        borderRadius: BorderRadius.circular(999),
                        borderColor: Colors.blue,
                        backgroundColor: Colors.green.withOpacity(0.2),
                        reserveSpaceForValidationMessage: false,
                      ),
                      selectorDecoration: SimpleSelectorDecoration(
                        selectorColor: Colors.amber.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                      hintText: "Select an option...",
                      labelText: "Simple Dropdown",
                      selectedValue: DropDownModel<String>(
                          key: "2", value: "2", text: "Los Angeles"),
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
                    DfSearchableDropdown<String>(
                      validator: (obj) {
                        return obj == null
                            ? null
                            : "This is a really long validation error, an this is how it will be displayed...";
                      },
                      dropdownType: DropdownType.overlay,
                      hintText: "Start typing..",
                      labelText: "Searchable Dropdown",
                      onOptionSelected: (value) {
                        log("SELECTED VALUE ${value?.value}");
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
                    const SizedBox(
                      height: 80,
                    ),
                    DfSearchableSingleSelectDropdown<String>(
                      validator: (obj) {
                        return "This is a really long validation error, an this is how it will be displayed...";
                      },
                      //dropdownType: DropdownType.overlay,
                      hintText: "Select...",
                      labelText: "Single Select",
                      selectorDecoration: const SingleSelectorDecoration(
                        selectedItemIcon: Icon(Icons.circle),
                      ),
                      onOptionSelected: (value) {
                        log("SELECTED VALUE ${value?.value}");
                      },
                      selectedValue: DropDownModel<String>(
                          key: "3", value: "3", text: "Chicago"),
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
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    DfSearchableMultiSelectDropdown<String>(
                      validator: (obj) {
                        return "This is a really long validation error, an this is how it will be displayed...";
                      },
                      //dropdownType: DropdownType.overlay,
                      hintText: "Select options...",
                      decoration: const DropdownDecoration(
                        borderColor: Colors.amber,
                        outlineBorderColor: Colors.blue,
                      ),
                      selectorDecoration: const MultiSelectorDecoration(
                          selectedItemColor: Colors.orange),
                      onOptionSelected: (value) {
                        log("SELECTED VALUE ${value.length}");
                      },
                      selectedValues: [
                        DropDownModel<String>(
                            key: "1", value: "1", text: "New York City"),
                        DropDownModel<String>(
                            key: "2", value: "2", text: "Los Angeles"),
                      ],
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
                            key: "6", value: "3", text: "Philadelphia"),
                        DropDownModel<String>(
                            key: "7", value: "4", text: "San Antonio"),
                        DropDownModel<String>(
                            key: "8", value: "5", text: "San Diego"),
                        DropDownModel<String>(
                            key: "9", value: "3", text: "Dallas"),
                        DropDownModel<String>(
                            key: "10", value: "4", text: "Austin"),
                        DropDownModel<String>(
                            key: "11", value: "5", text: "Texas"),
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
