import 'dart:html' as html;

String getCurrentLocale() {
  return html.window.navigator.language;
}
