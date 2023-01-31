import 'package:flutter/material.dart';

double paintWidthWithTextStyle(TextStyle style, String t) {
  final TextPainter textPainter = TextPainter(
      text: TextSpan(text: t, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr)
    ..layout(minWidth: 0, maxWidth: double.infinity);
  return textPainter.size.width;
}
