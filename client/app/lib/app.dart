import 'package:app/pages/config/page.dart';
import 'package:app/pages/home/page.dart';
import 'package:app/pages/login/page.dart';
import 'package:app/pages/splash/page.dart';
import 'package:app/pages/user/page.dart';
import 'package:app/pages/users/page.dart';
import 'package:app/theme.dart';

import 'package:flongo_client/app.dart';
import 'package:flongo_client/app_router.dart';
import 'package:flutter/material.dart';

final FlongoApp flongoApp = FlongoApp(

  router: AppRouter(
    routeBuilders: {
      '/': (context, args) => LoginPage(),
      '/home': (context, args) => HomePage(),
      '/config': (context, args) => ConfigPage(),
      '/users': (context, args) => UsersPage(),
      '/user': (context, args) => UserPage(),
      '/_splash': (context, args) => const SplashScreen(),
    },
  ),

  initialRoute: '/_splash',
  
  appTheme: ThemeData(primarySwatch: AppTheme.primarySwatch),
);
