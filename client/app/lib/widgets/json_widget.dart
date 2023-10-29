import 'package:flutter/material.dart';

class JSONWidget extends StatefulWidget {
  final dynamic data;
  final String apiURL;
  final Function? deleteItem;
  final Function? updateItem;

  const JSONWidget({
    Key? key,
    required this.data,
    required this.apiURL,
    this.deleteItem,
    this.updateItem,
  }) : super(key: key);

  @override
  JSONWidgetState createState() => JSONWidgetState();
}

class JSONWidgetState extends State<JSONWidget> {
  late dynamic data;

  @override
  void initState() {
    super.initState();
    data = widget.data;
  }

  // TODO - ALLOW filter override
  // TODO - Probably move a lot of stuff here
  void filterData(String query) {
    if (query.isEmpty) {
      data = widget.data;
    } else {
      data = widget.data.where((item) {
        return item['name']?.toLowerCase().contains(query.toLowerCase()) ?? false;
      }).toList();
    }
    setState(() {}); // This is crucial to update the UI with filtered results.
  }

  @override
  Widget build(BuildContext context) {
    return Text(data != null ? data.toString() : 'No data found');
  }
}