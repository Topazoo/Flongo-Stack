import 'package:app/app_router.dart';
import 'package:app/pages/config/page.dart';
import 'package:app/pages/home/page.dart';
import 'package:app/pages/login/page.dart';
import 'package:app/pages/splash/page.dart';
import 'package:app/styles/theme.dart';

import 'app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final FlongoApp app = FlongoApp(
  router: AppRouter(
    routeBuilders: {
      '/_splash': (context, args) => const SplashScreen(),
      '/': (context, args) => const LoginPage(),
      '/home': (context, args) => const HomePage(),
      '/config': (context, args) => const ConfigPage(),
    },
  ),
  initialRoute: '/_splash',
  appTheme: ThemeData(primarySwatch: AppTheme.primarySwatch),
);


void main() async {
  await dotenv.load();
  runApp(app);
}