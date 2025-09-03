import 'package:df_dropdown/df_dropdown.dart';

class DropDownNestedModel<T>{
  String? title;
  List<DropDownNestedModel>? children;
  List<DropDownModel>? values;
}