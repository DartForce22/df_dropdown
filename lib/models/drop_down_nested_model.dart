import 'package:df_dropdown/df_dropdown.dart';

class DropDownNestedModel<T> {
  DropDownNestedModel({
    this.title,
    this.children,
    this.values,
  });

  final String? title;
  final List<DropDownNestedModel<T>>? children;
  final List<DropDownModel<T>>? values;
}
