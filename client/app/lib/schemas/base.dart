
class BaseSchema {
  autoGenerateSchemaMap(Map<String, dynamic> data) {
    List<Map<String, dynamic>> children = [];

    children.add({
      "type": "text",
      "text": data,
      "style": {
        "fontSize": 20,
      }
    });

    return {
      "type": "column",
      "children": children,
      "mainAxisAlignment": "center"
    };
  }

  Map<String, dynamic> autoGenerateSchemaList(List<dynamic> data) {
    List<Map<String, dynamic>> children = [];

    for (var item in data) {
      children.add({
        "type": "text",
        "text": item,
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