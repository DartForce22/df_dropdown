import 'dart:async';

import 'package:flutter/material.dart';

import '/models/drop_down_model.dart';

/// Abstract base class to manage the state and behavior of a dropdown widget.
///
/// This class defines an interface for handling suggestions visibility, input validation,
/// and dropdown UI behavior. Concrete implementations should extend this class and provide
/// the necessary functionality.
abstract class BaseDropdownProvider<T> with ChangeNotifier {
  /// Creates a new [BaseDropdownProvider] instance.
  ///
  /// - [initData]: The initial list of data for the dropdown. Defaults to an empty list.
  /// - [validator]: An optional validation function to validate the selected dropdown item.
  BaseDropdownProvider({
    this.initData = const [],
    this.validator,
    required this.context,
  });

  final BuildContext context;
  OverlayEntry? _overlayEntry;

  Offset? _previousOffset;
  Timer? _timer;
  bool _suggestionClosedOnMove = false;

  // Global key to identify the child widget
  final GlobalKey dropdownKey = GlobalKey();

  // Function to show the overlay
  void _showOverlay(Widget selectorWidget, bool expanded) {
    if (_overlayEntry != null) return;

    _selectorWidget = selectorWidget;
    // Find the position of the child widget using the GlobalKey
    final RenderBox renderBox =
        dropdownKey.currentContext!.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;

    final int topOffset = expanded ? 4 : -6;

    // Create an OverlayEntry and position it based on the child's position
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        // Position the overlay under the child widget
        left: expanded ? offset.dx : null,
        right: !expanded
            ? MediaQuery.of(context).size.width - offset.dx - size.width
            : null,
        top: offset.dy + size.height + topOffset,
        child: SizedBox(
          width: expanded ? size.width : null,
          child: selectorWidget,
        ),
      ),
    );

    // Insert the OverlayEntry into the Overlay
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _selectorWidget = null;
  }

  Widget? _selectorWidget;

  /// Whether the suggestions list is expanded or collapsed.
  bool suggestionsExpanded = false;

  /// The initial data set for the dropdown.
  final List<DropDownModel<T>> initData;

  /// A controller to manage the search input text for filtering the dropdown.
  final TextEditingController searchTextController = TextEditingController();

  /// Stores any validation error that might occur.
  String? _validationError;

  /// FocusNode for managing the text field's focus state.
  FocusNode textFieldFocusNode = FocusNode();

  /// Validator function that checks if a dropdown selection is valid.
  final String? Function(DropDownModel<T>?)? validator;

  /// Public variable for tracking any validation error.
  String? validationError;

  /// Sets the validation error message and triggers a UI update.
  ///
  /// - [error]: The validation error message to set.
  set setValidationError(String? error) {
    _validationError = error;
    notifyListeners();
  }

  /// Toggles the state of the suggestions list between expanded and collapsed.
  ///
  /// Expands the dropdown if it's collapsed, and collapses it if it's already expanded.
  void toggleSuggestionsExpanded(
      {Widget? selectorWidget, bool expanded = true}) {
    suggestionsExpanded = !suggestionsExpanded;
    if (suggestionsExpanded) {
      expandSuggestions(
        selectorWidget: selectorWidget,
        expanded: expanded,
      );
    } else {
      closeSuggestions();
    }
  }

  /// Expands the suggestions list in the dropdown.
  void expandSuggestions({Widget? selectorWidget, bool expanded = true}) {
    suggestionsExpanded = true;
    if (selectorWidget != null) {
      _showOverlay(selectorWidget, expanded);
    }
    notifyListeners();
  }

  /// Collapses the suggestions list in the dropdown.
  void closeSuggestions() {
    suggestionsExpanded = false;
    if (_selectorWidget != null) {
      _removeOverlay();
    }
    notifyListeners();
  }

  /// Triggers an update when the input text is changed.
  ///
  /// - [text]: The new input text.
  void onInputChanged(String text) {
    notifyListeners();
  }

  /// Gets the height of the dropdown suggestions list.
  ///
  /// Currently set to a fixed height of 200 pixels.
  double get dropdownHeight {
    return 200;
  }

  /// Validates the input field for the dropdown based on its current state.
  ///
  /// Returns the current validation error if any, otherwise returns `null`.
  ///
  /// - [text]: The text to validate.
  String? onValidateField(text) {
    return validationError;
  }

  /// Returns the color to be used for the border of a form field, based on validation state.
  ///
  /// If there is no validation error, it returns a default shade of grey with reduced opacity.
  /// If there is a validation error, the border color changes to red to indicate the issue.
  ///
  /// - [borderColor]: Optional custom color for the normal border state.
  /// - [errorBorderColor]: Optional custom color for the error state.
  ///
  /// Returns:
  /// - `Color`: The color to be applied to the field's border.
  Color fieldBorderColor({
    Color? borderColor,
    Color? errorBorderColor,
  }) {
    Color color = borderColor ??
        (Colors.grey[950] ?? Colors.grey.shade900).withOpacity(0.12);

    if (_validationError != null) {
      color = errorBorderColor ?? Colors.red.shade500;
    }

    return color;
  }

  /// Monitors and updates the position of the dropdown selector widget if needed.
  ///
  /// This method checks the position of the dropdown using its current global offset.
  /// If the position has changed since the last check, the suggestions are either
  /// closed or reopened, depending on the direction of the movement and the expansion
  /// state of the suggestions.
  ///
  /// - If the dropdown has moved horizontally, it closes the suggestions immediately.
  /// - If the dropdown has moved vertically and the suggestions are expanded, it
  ///   temporarily closes them and then reopens them after a short delay.
  ///
  /// It also ensures that the method continues to check for future position changes
  /// by adding a post-frame callback.
  ///
  /// Parameters:
  /// - [selectorWidget]: The dropdown selector widget that needs position adjustments.
  ///
  void updateSelectorPositionIfNeeded({
    required Widget selectorWidget,
    bool expanded = true,
  }) {
    if ((this.suggestionsExpanded || _suggestionClosedOnMove) &&
        dropdownKey.currentContext != null) {
      final RenderBox renderBox =
          dropdownKey.currentContext!.findRenderObject() as RenderBox;
      final Offset currentOffset = renderBox.localToGlobal(Offset.zero);

      _previousOffset ??= currentOffset;

      if (_previousOffset != currentOffset) {
        _timer?.cancel();
        if (_previousOffset!.dx != currentOffset.dx) {
          closeSuggestions();
        } else {
          if (suggestionsExpanded) {
            closeSuggestions();
            _suggestionClosedOnMove = true;
          }
          if (_suggestionClosedOnMove) {
            _timer = Timer(const Duration(milliseconds: 100), () {
              _suggestionClosedOnMove = false;
              expandSuggestions(
                selectorWidget: selectorWidget,
                expanded: expanded,
              );
            });
          }
        }

        _previousOffset = currentOffset;
      }
    }

    // Continue to check for future changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      updateSelectorPositionIfNeeded(
        selectorWidget: selectorWidget,
        expanded: expanded,
      );
    });
  }
}
