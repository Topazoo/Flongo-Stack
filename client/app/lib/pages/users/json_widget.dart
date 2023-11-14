
import 'package:app/utils/scroll_behavior.dart';
import 'package:flongo_client/widgets/json_list_widget.dart';
import 'package:flutter/material.dart';

class UsersJSONWidget extends JSON_List_Widget {
  const UsersJSONWidget({Key? key, required data, required apiURL, onRefresh}) : super(
    key: key, 
    data: data, 
    apiURL: apiURL,
    onRefresh: onRefresh
  );

  @override
  _UsersJSONWidgetState createState() => _UsersJSONWidgetState();
}

class _UsersJSONWidgetState extends JSONWidgetState {
  final ScrollController controller = ScrollController();

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
        child: RefreshIndicator(
          onRefresh: () async {
            if (widget.onRefresh != null) {
              await widget.onRefresh!();
              setState(() {
                data = filter(widget.data, currentSearchTerm);
              });
            }
            return Future.value();
          },
          child: ScrollConfiguration(
            behavior: MouseScrollBehavior(),
            child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
              var item = data[index];
              return ListTile(
                leading: const Icon(Icons.info),
                title: Text(item['username'] ?? ''),
                subtitle: Text('${item['email_address']}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => updateItem(item, index),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => deleteItem(item, index),
                    ),
                  ],
                ),
              );
            },
          )),
        )),
      ],
    );
  }
}