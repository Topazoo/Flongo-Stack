import 'package:app/pages/http_page.dart';
import 'package:app/schemas/json_to_widget_schema.dart';
import 'package:flutter/material.dart';

class JSON_Page extends API_Page {
  final JSON_To_Widget_Schema schema = const JSON_To_Widget_Schema();

  const JSON_Page({super.key});

  @override
  JSON_PageState createState() => JSON_PageState();
}

class JSON_PageState extends API_PageState<JSON_Page> {
  @override
  Widget getPageWidget(BuildContext context) => widget.schema.widgetFromJSON(context, data);
}
