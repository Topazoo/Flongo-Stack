
import 'package:flongo_client/pages/json_page.dart';
import 'package:flongo_client/widgets/navbar/app_navbar.dart';
import 'package:flutter/material.dart';

import '../../navbar.dart';
import 'json_widget.dart';

class UserPage extends JSON_Page {
  @override
  final String apiURL = '/user';
  @override
  final String dataPath = '';
  @override
  final bool fetchOnLoad = true;
  @override
  final bool authenticationRequired = true;
  @override
  final AppNavBar navbar = NavBar();

  UserPage({super.key});

  @override
  _UserPagePageState createState() => _UserPagePageState();
}

class _UserPagePageState extends JSON_PageState {
  @override
  Widget getPageWidget(BuildContext context) => UserJSONWidget(
    data: data, 
    apiURL: widget.apiURL,
  );
}
