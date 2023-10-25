import 'package:flutter/material.dart';

class JSON_To_Widget_Schema {
  const JSON_To_Widget_Schema();

  Widget widgetFromJSON(
    BuildContext context, 
    dynamic json, 
    String apiURL,
    Function? deleteItem,
    Function? updateItem
  ) =>
    Text(json != null ? json.toString() : 'No data found');
}
