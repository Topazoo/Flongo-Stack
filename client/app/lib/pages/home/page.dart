import 'package:app/pages/base_page.dart';
import 'package:app/utilities/http_client.dart';
import 'package:flutter/material.dart';

class HomePage extends BasePage {

  const HomePage({Key? key, bool authenticationRequired = false})
    : super(key: key, authenticationRequired: authenticationRequired);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends BasePageState {

  @override
  Widget buildContent(BuildContext context) {
    return Text('Welcome Home: ${HTTPClient.getIdentity()}');
  }
}
