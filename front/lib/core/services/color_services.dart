import 'package:flutter/material.dart';
import 'dart:math';

class ColorServices {
  static Color getContrastingTextColor(Color backgroundColor) {
    // Calcul de la luminosité relative
    num r = backgroundColor.red / 255.0;
    num g = backgroundColor.green / 255.0;
    num b = backgroundColor.blue / 255.0;

    r = (r <= 0.03928) ? r / 12.92 : pow((r + 0.055) / 1.055, 2.4);
    g = (g <= 0.03928) ? g / 12.92 : pow((g + 0.055) / 1.055, 2.4);
    b = (b <= 0.03928) ? b / 12.92 : pow((b + 0.055) / 1.055, 2.4);

    double luminance = 0.2126 * r + 0.7152 * g + 0.0722 * b;

    // Si la luminosité relative est inférieure à 0.5, le texte doit être blanc, sinon noir
    return (luminance > 0.5) ? Colors.black : Colors.white;
  }

  static Color hexToColor(String hex) {
    hex = hex.replaceFirst('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex';
    }
    int colorInt = int.parse(hex, radix: 16);
    return Color(colorInt);
  }
}