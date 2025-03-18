import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:mvvm_architecture/presentation/resources/language_manager.dart';

import 'app/app.dart';
import 'app/di.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await initAppModule();
  runApp(EasyLocalization(
    supportedLocales: [ENGLISH_LOCAL, ARABIC_LOCAL],
    path: ASSETS_PATH_LOCALISATIONS,
    child: Phoenix(child: MyApp()),
  ));
}
