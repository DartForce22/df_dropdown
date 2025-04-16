import 'package:flutter/material.dart';

/// A generic model class for representing items in a dropdown menu.
///
/// This class is designed to store an item with a [key], a [value], and a display [text].
/// It also provides methods for equality comparison and string representation.
class DropDownModel<T> {
  /// Constructor for creating a [DropDownModel] instance.
  ///
  /// - [key]: A required string key to uniquely identify the item.
  /// - [value]: A required value of generic type [T].
  /// - [text]: A required string text to be displayed in the dropdown.
  DropDownModel({
    required this.key,
    this.value,
    required this.text,
    this.prefixWidget,
    this.disabled = false,
    this.disabledText,
  });

  /// A unique identifier for the dropdown item.
  final String key;

  /// The associated value for the dropdown item. The type of value is generic [T].
  final T? value;

  /// The text that is displayed in the dropdown for this item.
  final String text;

  /// A widget that will be displayed before the text in the dropdown
  final Widget? prefixWidget;

  /// A boolean indicating whether the dropdown item is disabled.
  final bool disabled;

  /// A string that will be displayed when the dropdown item is disabled.
  final String? disabledText;

  /// Returns the [text] representation of the item.
  ///
  /// This is used when the object is printed or displayed.
  @override
  String toString() {
    return "Key:$key\n Display text: $text\n Value:$value\n";
  }

  /// Compares two [DropDownModel] objects based on their [key].
  ///
  /// This allows dropdown items to be compared for equality based on their unique key.
  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is DropDownModel && key == other.key;
  }

  /// Returns a hash code based on the [key].
  ///
  /// This ensures that [DropDownModel] objects can be used effectively in collections such as sets or maps.
  @override
  int get hashCode => Object.hash(key, key);
}
