import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app.dart';
import 'local.dart';
import 'locale_web.dart' if (dart.library.io) 'locale_mobile.dart';

Future main() async {
  const bool kReleaseMode = bool.fromEnvironment('dart.vm.product');

  if (kReleaseMode) {
    await dotenv.load(fileName: ".env.prod");
  } else {
    await dotenv.load(fileName: ".env");
  }

  await initializeDateFormatting(getCurrentLocale());

  runApp(LocaleLanguage(
    locale: getCurrentLocale(),
    child: const App(),
  ));
}
