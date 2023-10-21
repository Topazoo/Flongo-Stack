import 'package:flutter/material.dart';
import 'package:app/utilities/http_client.dart';

class HTTP_Page extends StatefulWidget {
  final String url;

  const HTTP_Page({Key? key, required this.url}) : super(key: key);

  @override
  _HTTP_PageState createState() => _HTTP_PageState();
}

class _HTTP_PageState extends State<HTTP_Page> {
  late HTTPClient client;
  String? data;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    client = HTTPClient(widget.url);
    _fetchData();
  }

  Future<void> _fetchData() async {
    await client.get(
      onSuccess: (response) {
        setState(() {
          data = response.body;
          isLoading = false;
        });
      },
      onError: (response) {
        setState(() {
          data = 'Failed to fetch data';
          isLoading = false;
        });
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('HTTP Client Demo')),
      body: Center(
        child: isLoading
          ? CircularProgressIndicator()
          : Text(data ?? 'No data found'),
      ),
    );
  }
}
