class DropDownModel<T> {
  final String key;
  final T value;
  final String text;
  DropDownModel({
    required this.key,
    required this.value,
    required this.text,
  });

  @override
  String toString() {
    return text;
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is DropDownModel && key == other.key;
  }

  @override
  int get hashCode => Object.hash(key, key);
}
