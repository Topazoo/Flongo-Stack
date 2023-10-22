
import 'package:app/schemas/base.dart';

class ConfigSchema extends BaseSchema {
  @override
  Map<String, dynamic> autoGenerateSchemaList(List<dynamic> data) {
    List<Map<String, dynamic>> children = [];

    for (var item in data) {
      children.add({
        "type": "text",
        "text": item['name'] + ':' + item['value'].toString(),
        "style": {
          "fontSize": 20,
        }
      });
    }

    return {
      "type": "column",
      "children": children,
      "mainAxisAlignment": "center"
    };
  }
}