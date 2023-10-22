import 'package:app/pages/base_page.dart';
import 'package:app/utilities/http_client.dart';
import 'package:flutter/material.dart';

class HTTP_Page extends BasePage {
  final String apiURL;
  final bool fetchOnLoad;

  const HTTP_Page({Key? key, required this.apiURL, bool authenticationRequired = false, this.fetchOnLoad = false})
      : super(key: key, authenticationRequired: authenticationRequired);

  @override
  HTTP_PageState createState() => HTTP_PageState();
}

class HTTP_PageState extends BasePageState<HTTP_Page> {
  late HTTPClient client;
  String? data;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    client = HTTPClient(widget.apiURL);
    
    if (widget.fetchOnLoad) {
      _fetchData();
    }
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
            data = 'Failed to fetch data: ${response.body}';
            isLoading = false;
          });
        });
  }

  @override
  Widget buildContent(BuildContext context) {
    return isLoading
        ? const CircularProgressIndicator()
        : Text(data ?? 'No data found');
  }
}
