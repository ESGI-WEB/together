import 'dart:math';

import 'package:flutter/material.dart';

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

  static bool isDistinct(Color color, List<Color> existingColors, {double threshold = 100.0}) {
    for (Color existingColor in existingColors) {
      if (getColorDistance(color, existingColor) < threshold) {
        return false;
      }
    }
    return true;
  }

  static double getColorDistance(Color color1, Color color2) {
    final int redDifference = color1.red - color2.red;
    final int greenDifference = color1.green - color2.green;
    final int blueDifference = color1.blue - color2.blue;
    return sqrt(
      redDifference * redDifference +
          greenDifference * greenDifference +
          blueDifference * blueDifference,
    );
  }
}