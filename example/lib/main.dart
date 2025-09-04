import 'dart:developer';

import 'package:df_dropdown/df_dropdown.dart';
import 'package:df_dropdown/widgets/simple_dropdown_selector.dart';
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
                        return obj == null ? "No selected option..." : null;
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
                        selectedItemColor: Colors.blue.withValues(
                          alpha: 0.4,
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
                        DropDownModel<String>(key: "1", value: "1", text: "New York City"),
                        DropDownModel<String>(key: "2", value: "2", text: "Los Angeles"),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    DfSimpleDropdown<String>(
                      validator: (obj) {
                        return obj == null ? "No selected option..." : null;
                      },
                      dropdownType: DropdownType.overlay,
                      decoration: DropdownDecoration(
                        borderRadius: BorderRadius.circular(999),
                        borderColor: Colors.blue,
                        backgroundColor: Colors.green.withValues(alpha: 0.2),
                      ),
                      selectorDecoration: SimpleSelectorDecoration(
                        selectorColor: Colors.amber.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                      hintText: "Select an option...",
                      labelText: "Simple Dropdown",
                      onOptionSelected: (value) {
                        log("SELECTED VALUE ${value?.value}");
                      },
                      initData: [
                        DropDownModel<String>(key: "1", value: "1", text: "New York City"),
                        DropDownModel<String>(key: "2", value: "2", text: "Los Angeles"),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    DfSearchableDropdown<String>(
                      validator: (obj) {
                        return obj != null
                            ? null
                            : "This is a really long validation error, an this is how it will be displayed...";
                      },
                      dropdownType: DropdownType.overlay,
                      hintText: "Start typing...",
                      labelText: "Searchable Dropdown",
                      onOptionSelected: (value) {
                        log("SELECTED VALUE IS FOOTER ${value?.key == footerTapEvent}");
                      },
                      selectorDecoration: SimpleSelectorDecoration(
                        footerWidget: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          color: Colors.red,
                          height: 40,
                          width: double.infinity,
                          child: Text(
                            "FOOTER TAP TEST",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      asyncInitData: () async {
                        await Future.delayed(const Duration(seconds: 20));
                        return [
                          DropDownModel<String>(
                            key: "1",
                            value: "1",
                            text: "New York City",
                          ),
                          DropDownModel<String>(
                            key: "2",
                            value: "2",
                            text: "Los Angeles",
                            disabled: true,
                            disabledText: "Sold out",
                          ),
                        ];
                      }(),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    DfSearchableSingleSelectDropdown<int>(
                      validator: (obj) {
                        return "This is a really long validation error, an this is how it will be displayed...";
                      },
                      //dropdownType: DropdownType.overlay,
                      hintText: "Select...",
                      labelText: "Single Select",
                      selectorDecoration: const SingleSelectorDecoration(
                        selectedItemIcon: Icon(Icons.circle),
                        searchTextStyle: TextStyle(fontSize: 14)
                      ),
                      onOptionSelected: (value) {
                        log("SELECTED VALUE ${value?.value}");
                      },
                      nestedInitData: [
                        DropDownNestedModel(
                          title: "Bosna i Hercegovina",
                          children: [
                            DropDownNestedModel(
                              title: "Republika Srpska",
                              children: [
                                DropDownNestedModel(
                                  title: "Sarajevsko-Zenička regija",
                                  values: [
                                    DropDownModel(key: "sarajevo", text: "Sarajevo", value: 1),
                                    DropDownModel(key: "zenica", text: "Zenica", value: 2),
                                  ],
                                ),
                                DropDownNestedModel(
                                  title: "Banjalučka regija",
                                  values: [
                                    DropDownModel(key: "banjaluka", text: "Banja Luka", value: 3),
                                    DropDownModel(key: "prijedor", text: "Prijedor", value: 4),
                                  ],
                                ),
                              ],
                            ),
                            DropDownNestedModel(
                              title: "Federacija BiH",
                              children: [
                                DropDownNestedModel(
                                  title: "Hercegovačka regija",
                                  values: [
                                    DropDownModel(key: "mostar", text: "Mostar", value: 5),
                                    DropDownModel(key: "trebinje", text: "Trebinje", value: 6),
                                  ],
                                ),
                                DropDownNestedModel(
                                  title: "Tuzlanska regija",
                                  values: [
                                    DropDownModel(key: "tuzla", text: "Tuzla", value: 7),
                                    DropDownModel(key: "brcko", text: "Brčko", value: 8),
                                  ],
                                ),
                                DropDownNestedModel(
                                  title: "Unsko-Sanska regija",
                                  values: [
                                    DropDownModel(key: "bihac", text: "Bihać", value: 9),
                                    DropDownModel(key: "cazin", text: "Cazin", value: 10),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        DropDownNestedModel(
                          title: "Srbija",
                          children: [
                            DropDownNestedModel(
                              title: "Beogradski region",
                              values: [
                                DropDownModel(key: "beograd", text: "Beograd", value: 1),
                              ],
                            ),
                            DropDownNestedModel(
                              title: "Vojvodina",
                              children: [
                                DropDownNestedModel(
                                  title: "Severnobački okrug",
                                  values: [
                                    DropDownModel(key: "subotica", text: "Subotica", value: 2),
                                  ],
                                ),
                                DropDownNestedModel(
                                  title: "Južnobački okrug",
                                  values: [
                                    DropDownModel(key: "novisad", text: "Novi Sad", value: 3),
                                    DropDownModel(key: "sombor", text: "Sombor", value: 4),
                                  ],
                                ),
                              ],
                            ),
                            DropDownNestedModel(
                              title: "Centralna Srbija",
                              children: [
                                DropDownNestedModel(
                                  title: "Šumadijski okrug",
                                  values: [
                                    DropDownModel(key: "kragujevac", text: "Kragujevac", value: 5),
                                  ],
                                ),
                                DropDownNestedModel(
                                  title: "Nišavski okrug",
                                  values: [
                                    DropDownModel(key: "nis", text: "Niš", value: 6),
                                    DropDownModel(key: "pirot", text: "Pirot", value: 7),
                                  ],
                                ),
                                DropDownNestedModel(
                                  title: "Pomoravski okrug",
                                  values: [
                                    DropDownModel(key: "jagodina", text: "Jagodina", value: 8),
                                    DropDownModel(key: "cuprija", text: "Ćuprija", value: 9),
                                  ],
                                ),
                              ],
                            ),
                            DropDownNestedModel(
                              title: "Zapadna Srbija",
                              values: [
                                DropDownModel(key: "uzice", text: "Užice", value: 10),
                              ],
                            ),
                          ],
                        ),
                      ],
                      // selectedValue: DropDownModel<String>(
                      //     key: "3", value: "3", text: "Chicago"),
                      // initData: [
                      //   DropDownModel<String>(
                      //       key: "1", value: "1", text: "New York City"),
                      //   DropDownModel<String>(
                      //       key: "2", value: "2", text: "Los Angeles"),
                      //   DropDownModel<String>(
                      //       key: "3", value: "3", text: "Chicago"),
                      //   DropDownModel<String>(
                      //       key: "4", value: "4", text: "Houston"),
                      //   DropDownModel<String>(
                      //       key: "5", value: "5", text: "Phoenix"),
                      // ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    DfSearchableMultiSelectDropdown<String>(
                      validator: (obj) {
                        return "This is a really long validation error, an this is how it will be displayed...";
                      },
                      closeOnTapOutside: false,
                      displayResultsCount: 5,
                      //dropdownType: DropdownType.overlay,
                      hintText: "Select options...",
                      decoration: const DropdownDecoration(
                        borderColor: Colors.amber,
                        outlineBorderColor: Colors.blue,
                      ),
                      selectorDecoration: const MultiSelectorDecoration(selectedItemColor: Colors.orange),
                      onOptionSelected: (value) {
                        log("SELECTED VALUE ${value.length}");
                      },
                      selectedValues: [
                        DropDownModel<String>(key: "1", value: "1", text: "New York City"),
                        DropDownModel<String>(key: "2", value: "2", text: "Los Angeles"),
                      ],
                      initData: [
                        DropDownModel<String>(key: "1", value: "1", text: "New York City"),
                        DropDownModel<String>(key: "2", value: "2", text: "Los Angeles"),
                        DropDownModel<String>(key: "3", value: "3", text: "Chicago"),
                        DropDownModel<String>(key: "4", value: "4", text: "Houston"),
                        DropDownModel<String>(key: "5", value: "5", text: "Phoenix"),
                        DropDownModel<String>(key: "6", value: "3", text: "Philadelphia"),
                        DropDownModel<String>(key: "7", value: "4", text: "San Antonio"),
                        DropDownModel<String>(key: "8", value: "5", text: "San Diego"),
                        DropDownModel<String>(key: "9", value: "3", text: "Dallas"),
                        DropDownModel<String>(key: "10", value: "4", text: "Austin"),
                        DropDownModel<String>(key: "11", value: "5", text: "Texas"),
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
