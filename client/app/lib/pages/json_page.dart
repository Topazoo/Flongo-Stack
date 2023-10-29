import 'package:app/pages/api_page.dart';
import 'package:app/widgets/json_widget.dart';
import 'package:flutter/material.dart';

abstract class JSON_Page<W extends JSONWidget> extends API_Page {
  
  const JSON_Page({super.key});

  @override
  JSON_PageState<W> createState() => JSON_PageState<W>();
}

class JSON_PageState<W extends JSONWidget> extends API_PageState<JSON_Page<W>> {

  @override
  Widget getPageWidget(BuildContext context) => JSONWidget(data: data, apiURL: widget.apiURL);
}

