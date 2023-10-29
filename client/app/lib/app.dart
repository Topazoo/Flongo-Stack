import 'package:app/pages/config/page.dart';
import 'package:app/pages/home/page.dart';
import 'package:app/pages/login/page.dart';
import 'package:app/pages/splash/page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'styles/theme.dart';

class App extends StatelessWidget {
  static final env = dotenv.env;

  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String appName = env['APP_NAME'] ?? 'App Name';
    LoginPage loginPage = const LoginPage(homeWidget: HomePage());

    return MaterialApp(
      title: appName,
      theme: ThemeData(
        primarySwatch: AppTheme.primarySwatch,
      ),
      routes: {
        '/_splash': (context) => SplashScreen(appName: appName, baseWidget: loginPage),
        
        '/': (context) => loginPage,
        '/home': (context) => const HomePage(),
        '/config': (context) => const ConfigPage()
      },
      initialRoute: '/_splash',
    );
  }
}