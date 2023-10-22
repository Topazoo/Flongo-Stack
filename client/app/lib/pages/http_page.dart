import 'package:app/pages/base_page.dart';
import 'package:app/schemas/base.dart';
import 'package:app/utilities/http_client.dart';
import 'dart:convert';
import 'package:json_dynamic_widget/json_dynamic_widget.dart';

class HTTP_Page extends BasePage {
  final String apiURL;
  final String dataPath;
  final bool fetchOnLoad;
  BaseSchema? schema;

  HTTP_Page({
    Key? key, 
    required this.apiURL,
    this.dataPath = 'data',
    bool authenticationRequired = false, 
    this.fetchOnLoad = false,
    this.schema,
    }) : super(
      key: key, 
      authenticationRequired: authenticationRequired
    ) {
      schema ??= BaseSchema();
    }


  @override
  HTTP_PageState createState() => HTTP_PageState();
}

class HTTP_PageState extends BasePageState<HTTP_Page> {
  late HTTPClient client;
  dynamic data;
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
  Widget buildContent(BuildContext context) {
    Widget dynamicWidget = const CircularProgressIndicator();

    if (isLoading) {
      return dynamicWidget;
    }

    // if (widget.schema != null && data != null) {
    //   if (data is List) {
    //     dynamicWidget = JsonWidgetData.fromDynamic(widget.schema?.autoGenerateSchemaList(data as List<dynamic>)).build(
    //         context: context,
    //     );
    //     print(widget.schema?.autoGenerateSchemaList(data as List<dynamic>));
    //   }
    //   if (data is Map) {
    //     dynamicWidget = JsonWidgetData.fromDynamic(widget.schema?.autoGenerateSchemaMap(data as Map<String, dynamic>)).build(
    //         context: context,
    //     );
    //   }
    //} else {
      dynamicWidget = Text(data != null ? data.toString() : 'No data found');
    //}

    return dynamicWidget;
  }
}
