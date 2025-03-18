import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../presentation/resources/routes_manager.dart';
import '../presentation/resources/theme_manager.dart';
import 'app_prefs.dart';
import 'di.dart';

class MyApp extends StatefulWidget {
  MyApp._internal(); // private named constructor

  static final MyApp instance = MyApp._internal(); // single instance -- singleton

  factory MyApp() => instance; // factory for the class instance

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AppPreferences _appPreferences = instance<AppPreferences>();

  @override
  void didChangeDependencies() {
    _appPreferences.getLocal().then((local) => {context.setLocale(local)});

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      onGenerateRoute: RouteGenerator.getRoute,
      initialRoute: Routes.splashRoute,
      theme: getApplicationTheme(),
    );
  }
}
