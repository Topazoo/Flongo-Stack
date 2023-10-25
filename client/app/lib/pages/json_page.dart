import 'package:app/pages/http_page.dart';
import 'package:app/schemas/json_to_widget_schema.dart';
import 'package:app/utilities/http_client.dart';
import 'package:flutter/material.dart';

class JSON_Page extends API_Page {
  final JSON_To_Widget_Schema schema = const JSON_To_Widget_Schema();

  const JSON_Page({super.key});

  @override
  JSON_PageState createState() => JSON_PageState();
}

class JSON_PageState extends API_PageState<JSON_Page> {
  void _handleDelete(int? index) {
    if (index != null) {
      if (data is! List) {
        throw IndexError.withLength(index, 0, message: "Can't remove a non list item by index");
      }
      setState(() {
        data.removeAt(index);
      });
    } else {
      if (data is List) {
        throw IndexError.withLength(0, data.length, message: "Must pass index of item to remove!");
      }
      setState(() {
        data = null;
      });
    }
  }

  Future<void> deleteItem(String apiURL, BuildContext context, Map<String, dynamic> item, int? index) async {
    await HTTPClient(apiURL).delete(
      queryParams: {
        '_id': item['_id'].toString(),
      },
      onSuccess: (response) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Deleted Successfully')));
        _handleDelete(index);
      },
      onError: (response) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to Delete')));
      },
    );
  }

  void _handleUpdate(int? index, dynamic newData) {
    if (index != null) {
      if (data is! List) {
        throw IndexError.withLength(index, 0, message: "Can't update a non list item by index");
      }
      setState(() {
        data[index] = newData;
      });
    } else {
      if (data is List) {
        throw IndexError.withLength(0, data.length, message: "Must pass index of item to remove!");
      }
      setState(() {
        data = newData;
      });
    }
  }
  

  Future<void> updateItem(String apiURL, BuildContext context, Map<String, dynamic> item, int? index) async {
    final Map<String, dynamic> newVal = Map.from(item);
    newVal['value'] = "UPDATED"; // Get this value from a modal using `item` along with any other fields

    await HTTPClient(apiURL).patch(
      body: newVal,
      onSuccess: (response) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Updated Successfully')));
        _handleUpdate(index, newVal);
      },
      onError: (error) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to Update')));
      },
    );
  }

  @override
  Widget getPageWidget(BuildContext context) => 
    widget.schema.widgetFromJSON(context, data, widget.apiURL, deleteItem, updateItem);
}

