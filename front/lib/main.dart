import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';

import 'app.dart';

Future main() async {
  const bool kReleaseMode = bool.fromEnvironment('dart.vm.product');

  if (kReleaseMode) {
    await dotenv.load(fileName: ".env.prod");
  } else {
    await dotenv.load(fileName: ".env");
  }

  runApp(const App());
}



