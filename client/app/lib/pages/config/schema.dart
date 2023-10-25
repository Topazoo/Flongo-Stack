import 'package:app/schemas/json_to_widget_schema.dart';
import 'package:app/utilities/http_client.dart';
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
                  icon: Icon(Icons.edit),
                  onPressed: () => updateItem!(apiURL, context, item, index),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => deleteItem!(apiURL, context, item, index),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _editConfig(int index, BuildContext context, Map<String, dynamic> config, String apiURL, Function? updateItem) async {
    // Here you can show a dialog or navigate to another screen to get input from the user
    // For this example, I'm simply updating the value to `newValue` for the sake of simplicity
    final updatedValue = 'newValue';

    dynamic newVal = {
      '_id': config['_id'],
      'value': updatedValue,
    };

    await HTTPClient(apiURL).patch(
      body: newVal,
      onSuccess: (response) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Updated Successfully')));
        updateItem!(index, newVal);
      },
      onError: (error) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to Update')));
      },
    );
  }

  Future<void> _deleteConfig(int index, BuildContext context, Map<String, dynamic> config, String apiURL, Function? deleteItem) async {
    await HTTPClient(apiURL).delete(
      queryParams: {
        '_id': config['_id'].toString(),
      },
      onSuccess: (response) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Deleted Successfully')));
        deleteItem!(index);
      },
      onError: (response) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to Delete')));
      },
    );
  }
}