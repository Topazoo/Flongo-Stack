import 'package:app/utilities/http_client.dart';
import 'package:flutter/material.dart';

class JSONWidget extends StatefulWidget {
  final dynamic data;
  final String apiURL;

  const JSONWidget({
    Key? key,
    required this.data,
    required this.apiURL
  }) : super(key: key);

  @override
  JSONWidgetState createState() => JSONWidgetState();
}

class JSONWidgetState extends State<JSONWidget> {
  // Can be a Map (JSON) or List (list of JSON)
  late dynamic data;

  @override
  void initState() {
    super.initState();
    data = widget.data;
  }

  void filterData(String query) {
    if (data is List) {
      if (query.isEmpty) {
        data = widget.data;
      } else {
        data = filter(data, query);
      }
      setState(() {}); // This is crucial to update the UI with filtered results.
    }
  }

  List filter(List data, String query) {
    // Override this for easy searching by JSON field
    return data.where((item) {
      return item['name']?.toLowerCase().contains(query.toLowerCase()) ?? false;
    }).toList();
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

  Future<bool> _updateData(String apiURL, Map<String, dynamic> updatedItem, int? index) async {
    bool success = false;
    await HTTPClient(apiURL).patch(
      body: updatedItem,
      onSuccess: (response) {
        _handleUpdate(index, updatedItem);
        success = true;
      },
      onError: (error) {
        success = false;
      },
    );
    return success;
  }

  Future<void> updateItem(String apiURL, Map<String, dynamic> item, int? index, {String idKey='_id'}) async {
    final controllers = <String, TextEditingController>{};

     Map<String, dynamic> updatedItem = Map<String, dynamic>.from(item);
     String? _id = updatedItem.remove(idKey);

    // Initialize controllers with item values
    updatedItem.forEach((key, value) {
      controllers[key] = TextEditingController(text: value.toString());
    });

    bool? isUpdated = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Update Item'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: updatedItem.keys.map((key) {
              return TextField(
                controller: controllers[key],
                decoration: InputDecoration(labelText: key),
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(dialogContext).pop(null); // Return 'false' to indicate that update was cancelled.
            },
          ),
          TextButton(
            child: const Text('Update'),
            onPressed: () async {
              final finalItem = {...updatedItem};
              if (_id != null) {
                finalItem[idKey] = _id;
              }

              controllers.forEach((key, controller) {
                finalItem[key] = convertToRawType(controller.text);
              });

              bool success = await _updateData(apiURL, finalItem, index);
              Navigator.of(dialogContext).pop(success); // Return the success status of the update.
            },
          ),
        ],
      ),
    );

    if (isUpdated != null && isUpdated) {
      final messenger = ScaffoldMessenger.of(context);
      messenger.showSnackBar(const SnackBar(content: Text('Updated Successfully')));
    } else if (isUpdated != null && !isUpdated) {
      final messenger = ScaffoldMessenger.of(context);
      messenger.showSnackBar(const SnackBar(content: Text('Failed to Update')));
    }
  }

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

  dynamic convertToRawType(String value) {
    if (value.toLowerCase() == 'true') {
      return true;
    } else if (value.toLowerCase() == 'false') {
      return false;
    } else if (int.tryParse(value) != null) {
      return int.parse(value);
    } else {
      return value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(data != null ? data.toString() : 'No data found');
  }
}