## 1.0.0

- Created first version

## 1.0.1

- Updated code documentation
- Removed unused code
- Added customizable arrow icon

## 1.0.2

- Updated documentation

## 1.0.3

- Added the "Overlay" selector appearance
- When the `dropdownType` is set to `DropdownType.overlay` the options will be added on the top of the existing visible widgets

## 1.0.4

- Added a new dropdown variant `DfDropdownWrapper`
- Added selected icons, and selected color parameters to the `SimpleSelectorDecoration`

## 1.0.5

- Added more customization parameters
- Fixed form validations

## 1.0.6

- Fixed reported errors
- Added information if there are no available options for the Searchable dropdown
- Optimized overall package usage

## 1.0.7

- Added `closeDropdownOnSelection` parameter to the `SearchableSingleSelectDropdownProvider`

## 1.0.8

- Fixed issues with closing suggestions for the `DfSearchableDropdown` widget
- Added the `closeDropdownOnOutsideTap` parameter, and default value is set to `true`

## 1.0.9

- Fixed reported issues with the Searchable dropdown

## 1.1.0

- Fixed dropdown overflows
- Fixed initial data bug
- Fixed validation border color

## 1.1.1

- Added close on tap outside flag for the DfSearchableMultiSelectDropdown widget

## 1.1.2

- Added footer to the Searchable Dropdown
- Added prefix widget to the suggestions
## 1.1.3

- Added footer tap event, event will have the _key_ value of the const [footerTapEvent]

## 1.1.4

- Fixed footer widget height

## 1.1.5
- Bug fixes

## 1.1.6
- Bug fixes

## 1.2.0
- Added async init data parameter, when data is loading the CircularProgressIndicator will be displayed if not provided in decoration
- This version may have issues

## 1.2.1
- Added async init data parameter, when data is loading the CircularProgressIndicator will be displayed if not provided in decoration
- This version may have issues

## 1.2.2
- Refactored base dropdown class, added a unified abstract class for all common parameters
- This version may have issues

## 1.2.3
- Fixed reported issues with searchable dropdown UI
- This version may have issues

## 1.2.4
- Fixed reported issues when scrolling parent content

## 1.2.5
- Added option to disable selecting a suggestion

## 1.2.6
- Fixed searchable dropdown auto-suggestions expanding bug

## 1.2.7
- Fixed reported clear text styling issue
- Introduced nested dropdown options to Searchable Single Select dropdown variation

## 1.2.8
- Introduced the expandableSelectorBottomMargin parameter in order to "separate" the dropdown content from the widgets below when the dropdown is expanded (https://github.com/DartForce22/df_dropdown/issues/9)
- Added the "subtext" parameter to the DropdownModel, in order to be able to display the additional text for the element in the dropdowns (https://github.com/DartForce22/df_dropdown/issues/10)

## 1.2.9 - Ćofa
- Added content padding for the dropdown content
- Added display formatter property to the dropdown model

## 1.2.10
- Changed default package color
- Extracted provider reference from the selector widget

## 1.3.0
- Added property for bg color of the selected item

## 1.3.1
- Fixed problem with missing values after selection in DfSearchableDropdown

