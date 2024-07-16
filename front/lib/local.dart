import 'package:flutter/material.dart';

class LocaleLanguage extends InheritedWidget {
  final String locale;

  const LocaleLanguage({
    super.key,
    required this.locale,
    required super.child,
  });

  static LocaleLanguage? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<LocaleLanguage>();
  }

  @override
  bool updateShouldNotify(LocaleLanguage oldWidget) {
    return locale != oldWidget.locale;
  }
}
