import 'package:app/schemas/json_to_widget_schema.dart';
import 'package:flutter/material.dart';

class Config_JSON_To_Widget_Schema extends JSON_To_Widget_Schema {
  const Config_JSON_To_Widget_Schema();

  @override
  Widget widgetFromJSON(BuildContext context, dynamic json, String apiURL, Function? deleteItem, Function? updateItem) {
    if (json is! List) {
      throw ArgumentError('Expected a List but got ${json.runtimeType}');
    }

    List<Map<String, dynamic>> dataList = List<Map<String, dynamic>>.from(json);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView.builder(
        itemCount: dataList.length,
        itemBuilder: (BuildContext context, int index) {
          var item = dataList[index];
          return ListTile(
            leading: const Icon(Icons.info),
            title: Text(item['name'] ?? ''),
            subtitle: Text('${item['value']}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => updateItem!(apiURL, context, item, index),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => deleteItem!(apiURL, context, item, index),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}