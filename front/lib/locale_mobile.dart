import 'dart:io' show Platform;

String getCurrentLocale() {
  return Platform.localeName;
}