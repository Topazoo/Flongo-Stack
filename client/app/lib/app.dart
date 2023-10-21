import 'package:app/pages/http_page.dart';
import 'package:flutter/material.dart';

import 'styles/theme.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // TODO - Configuration Manager from env
      title: 'App Name',
      theme: ThemeData(
        primarySwatch: AppTheme.primarySwatch,
      ),
      home: const HTTP_Page(url: 'config'),
    );
  }
}