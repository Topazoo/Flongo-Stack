import 'package:app/pages/api_page.dart';
import 'package:app/widgets/json_widget.dart';
import 'package:app/utilities/http_client.dart';
import 'package:flutter/material.dart';

abstract class JSON_Page<W extends JSONWidget> extends API_Page {
  
  const JSON_Page({super.key});

  @override
  JSON_PageState<W> createState() => JSON_PageState<W>();
}

class JSON_PageState<W extends JSONWidget> extends API_PageState<JSON_Page<W>> {

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
  Widget getPageWidget(BuildContext context) => JSONWidget(
    data: data,
    apiURL: widget.apiURL,
    deleteItem: deleteItem,
    updateItem: updateItem,
  );
}

