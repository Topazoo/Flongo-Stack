import 'package:app/schemas/json_to_widget_schema.dart';
import 'package:flutter/material.dart';

class Config_JSON_To_Widget_Schema extends JSON_To_Widget_Schema {
  const Config_JSON_To_Widget_Schema();

  @override
  Widget widgetFromJSON(BuildContext context, dynamic json) {
    if (json is! List) {
      throw ArgumentError('Expected a List but got ${json.runtimeType}');
    }

    List<Map<String, dynamic>> dataList = List<Map<String, dynamic>>.from(json);

    return ListView.builder(
      itemCount: dataList.length,
      itemBuilder: (BuildContext context, int index) {
        var item = dataList[index];
        return ListTile(
          leading: Icon(Icons.info),
          title: Text(item['name'] ?? ''),
          subtitle: Text('${item['value']}'),
        );
      },
    );
  }
}
