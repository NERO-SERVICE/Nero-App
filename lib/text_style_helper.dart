import 'package:flutter/material.dart';

class TextStyleHelper {
  static TextStyle getTextStyle(TextStyle baseStyle, Color color) {
    return baseStyle.merge(TextStyle(color: color));
  }
}