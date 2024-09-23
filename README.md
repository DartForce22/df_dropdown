#df_dropdown

`df_dropdown` is a Flutter package providing versatile and customizable dropdown components with different selection modes and search functionality.

# Features:

- Simple dropdown
- Searchable dropdown
- Single select with search
- Multi select with search

# Installation

Add the package to your `pubspec.yaml` file

```dart
dependencies:
  df_dropdown: latest_version
```

Then, run: `flutter pub get`

# Usage

### Note
- Setting `dropdownType` to `DropdownType.overlay` displays the dropdown options on top of the existing widgets, without repositioning them.
- By default, `dropdownType` is set to `DropdownType.expandable`, which expands the dropdown by shifting the widgets below it to make space for the options.

## 1. Simple Dropdown
  This provides a basic dropdown menu with customizable styles such as rounded borders, border color, and more.
  
  <img src="https://raw.githubusercontent.com/DartForce22/df_dropdown/refs/heads/main/assets/simple-dd.jpg" alt="drawing" width="200"/>

  ### Example
  ```dart
    DfSimpleDropdown<String>(
    decoration: DropdownDecoration(
      borderRadius: BorderRadius.circular(999),
      borderColor: Colors.blue,
    ),
    hintText: "Select an option...",
    labelText: "Simple Dropdown",
    selectedValue: DropDownModel<String>(key: "2", value: "2", text: "Los Angeles"),
    onOptionSelected: (value) {
      log("SELECTED VALUE ${value.value}");
    },
    initData: [
      DropDownModel<String>(key: "1", value: "1", text: "New York City"),
      DropDownModel<String>(key: "2", value: "2", text: "Los Angeles"),
    ],
  )
  ```
  
  ## 2. Simple Searchable Dropdown
  This dropdown includes a search option for filtering through a large set of options, helping users quickly find what they’re looking for.
  
  <img src="https://raw.githubusercontent.com/DartForce22/df_dropdown/refs/heads/main/assets/searchable-dd.jpg" alt="drawing" width="200"/>
  
  ### Example
  ```dart
    DfSearchableDropdown<String>(
      hintText: "Start typing..",
      labelText: "Searchable Dropdown",
      onOptionSelected: (value) {
        log("SELECTED VALUE ${value.value}");
      },
      onSearch: (context) async {
        return [DropDownModel<String>(key: "4", value: "4", text: "Houston")];
      },
      initData: [
        DropDownModel<String>(key: "1", value: "1", text: "New York City"),
        DropDownModel<String>(key: "2", value: "2", text: "Los Angeles"),
        DropDownModel<String>(key: "3", value: "3", text: "Chicago"),
      ],
    )
  ```
  ## 3. Searchable Single Select Dropdown
  A dropdown that allows users to search for and select only one option from the list, ideal for forms where only one selection is required.
  Similar to the `DfSearchableDropdown`, but with several UI differences.
  
  <img src="https://raw.githubusercontent.com/DartForce22/df_dropdown/refs/heads/main/assets/single-select-dd.jpg" alt="drawing" width="200"/>
  
  ### Example
  ```dart
    DfSearchableSingleSelectDropdown<int>(
      hintText: "Select...",
      labelText: "Single Select",
      selectorDecoration: const SingleSelectorDecoration(
        selectedItemIcon: Icon(Icons.circle),
      ),
      onOptionSelected: (value) {
        log("SELECTED VALUE ${value?.value}");
      },
      initData: [
        DropDownModel<String>(key: "1", value: 1, text: "New York City"),
        DropDownModel<String>(key: "2", value: 2, text: "Los Angeles"),
        DropDownModel<String>(key: "3", value: 3, text: "Chicago"),
      ],
    )
  ```
  ## 4. Searchable Multi Select Dropdown
  This allows users to search and select multiple options from the list, perfect for scenarios where more than one selection is necessary.
  
  <img src="https://raw.githubusercontent.com/DartForce22/df_dropdown/refs/heads/main/assets/multi-select-dd.jpg" alt="drawing" width="200"/>
  
  ### Example
  ```dart
    DfSearchableMultiSelectDropdown<String>(
      hintText: "Select options...",
      decoration: const DropdownDecoration(borderColor: Colors.amber),
      selectorDecoration: const MultiSelectorDecoration(
        showSelectedItems: false,
      ),
      onSearch: (context) async {
        return [DropDownModel<String>(key: "4", value: "4", text: "Houston")];
      },
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
      ],
    )
```
   

    

    


