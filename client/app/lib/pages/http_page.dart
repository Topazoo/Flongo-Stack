import 'package:app/pages/base_page.dart';
import 'package:app/utilities/http_client.dart';
import 'dart:convert';

import 'package:flutter/material.dart';

class HTTP_Page extends BasePage {
  final String apiURL = '/';
  final String dataPath = 'data';
  final bool fetchOnLoad = false;

  const HTTP_Page({Key? key}): super(key: key);

  @override
  HTTP_PageState createState() => HTTP_PageState();
}

class HTTP_PageState<T extends HTTP_Page> extends BasePageState<T> {
  late HTTPClient client;
  dynamic data;

  @override
  void initState() {
    super.initState();
    client = HTTPClient(widget.apiURL);
    
    if (widget.fetchOnLoad) {
      isLoading = true;
      _fetchData();
    } else {
      isLoading = false;
    }
  }

  Future<void> _fetchData() async {
    await client.get(
        onSuccess: (response) {
          dynamic responseData;
          if (response.body != null) {
            responseData = json.decode(response.body);
            if (widget.dataPath.isNotEmpty) {
              responseData = responseData[widget.dataPath];
            }
          }
          setState(() {
            data = responseData;
            isLoading = false;
          });
        },
        onError: (response) {
          setState(() {
            data = 'Failed to fetch data: ${response.body}';
            isLoading = false;
          });
        });
  }

  @override
  Widget getPageWidget(BuildContext context) => Text(data != null ? data.toString() : 'No data found');
}
