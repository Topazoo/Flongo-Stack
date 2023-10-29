import 'package:app/widgets/json_widget.dart';
import 'package:flutter/material.dart';

class ConfigJSONWidget extends JSONWidget {
  const ConfigJSONWidget({Key? key, required data, required apiURL}) : super(
    key: key, 
    data: data, 
    apiURL: apiURL
  );

  @override
  _ConfigJSONWidgetState createState() => _ConfigJSONWidgetState();
}

class _ConfigJSONWidgetState extends JSONWidgetState {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            onChanged: filterData,
            decoration: const InputDecoration(
              labelText: 'Search',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
              var item = data[index];
              return ListTile(
                leading: const Icon(Icons.info),
                title: Text(item['name'] ?? ''),
                subtitle: Text('${item['value']}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => updateItem(widget.apiURL, item, index),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => deleteItem(widget.apiURL, context, item, index),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
