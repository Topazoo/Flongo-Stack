import 'package:app/pages/http_page.dart';
import 'package:json_dynamic_widget/json_dynamic_widget.dart';

class JSON_Page extends HTTP_Page {
  final JsonWidgetRegistry registry;

  JSON_Page({
    Key? key, 
    required String apiURL,
    String dataPath = 'data',
    bool authenticationRequired = false, 
    bool fetchOnLoad = false,
    JsonWidgetRegistry? registry,
    }) : 
    registry = registry ?? JsonWidgetRegistry.instance,
    super(
      key: key,
      apiURL: apiURL,
      dataPath: dataPath,
      authenticationRequired: authenticationRequired,
      fetchOnLoad: fetchOnLoad
    );

  @override
  JSON_PageState createState() => JSON_PageState();
}

class JSON_PageState extends HTTP_PageState {

}
