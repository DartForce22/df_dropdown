class DropDownModel<T> {
  final String id;
  final T value;
  final String text;
  DropDownModel({
    required this.id,
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
    return other is DropDownModel && id == other.id;
  }

  @override
  int get hashCode => Object.hash(id, id);
}
