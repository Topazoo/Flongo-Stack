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

  PageRoute buildRoute(String url, Map args, Widget page){
    // Apply animation if passed
    if (args.containsKey('_animation')) {
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        settings: RouteSettings(name: url),
        transitionsBuilder: args['_animation'],
        transitionDuration: Duration(milliseconds: args['_animation_duration'] ?? 1200),
      );
    }

    return MaterialPageRoute(
      builder: (context) => page,
      settings: RouteSettings(name: url)
    );
  }

  @override
  Widget build(BuildContext context) {
    String appName = env['APP_NAME'] ?? 'App Name';

    return MaterialApp(
      title: appName,
      theme: ThemeData(
        primarySwatch: AppTheme.primarySwatch,
      ),
      onGenerateRoute: (RouteSettings settings) {
        Map routeArgs = (settings.arguments is Map) ? settings.arguments as Map : {};

        switch (settings.name) {
          case '/_splash': 
            return buildRoute('/_splash', routeArgs, SplashScreen(appName: appName));
          case '/': 
            return buildRoute('/', routeArgs, const LoginPage());
          case '/home': 
            return buildRoute('/home', routeArgs, const HomePage());
          case '/config':
            return buildRoute('/config', routeArgs, const ConfigPage());

          default:
            return null;
        }
      },
      initialRoute: '/_splash'
    );
  }
}