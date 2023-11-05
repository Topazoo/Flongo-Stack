
import 'package:flongo_client/pages/json_page.dart';
import 'package:flongo_client/widgets/navbar/app_navbar.dart';
import 'package:flutter/material.dart';

import '../../navbar.dart';
import 'json_widget.dart';

class UsersPage extends JSON_Page {
  @override
  final String apiURL = '/users';
  @override
  final bool fetchOnLoad = true;
  @override
  final bool authenticationRequired = true;
  @override
  final AppNavBar navbar = NavBar();

  UsersPage({super.key});

  @override
  _UsersPagePageState createState() => _UsersPagePageState();
}

class _UsersPagePageState extends JSON_PageState {
  @override
  Widget getPageWidget(BuildContext context) => UsersJSONWidget(
    data: data, 
    apiURL: widget.apiURL,
    onRefresh: fetchData
  );
}
