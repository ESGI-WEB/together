import 'package:flutter/material.dart';
import 'package:front/app_theme.dart';
import 'package:front/go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: goRouter,
      title: '2gether',
      theme: AppTheme.theme,
      debugShowCheckedModeBanner: false,
    );
  }
}
