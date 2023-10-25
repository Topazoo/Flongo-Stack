import 'package:app/pages/config/schema.dart';
import 'package:app/pages/json_page.dart';
import 'package:app/schemas/json_to_widget_schema.dart';


class ConfigPage extends JSON_Page {
  @override
  final String apiURL = '/config';
  @override
  final bool fetchOnLoad = true;
  @override
  final bool authenticationRequired = true;
  @override
  final JSON_To_Widget_Schema schema = const Config_JSON_To_Widget_Schema();

  const ConfigPage({super.key});

  @override
  JSON_PageState createState() => JSON_PageState();
}
