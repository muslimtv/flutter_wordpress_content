import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart';
import 'model/Paragraph.dart';

Paragraph parseHeadingHTML(String content,
    {bool isArabic = false,
    TextAlign textAlign = TextAlign.left,
    String arabicFontFamily = "",
    String fontFamily = "",
    double baseFontSize = 19.0}) {
  dom.Element contentBodyElement = parse(content).body;

  return Paragraph.heading(
      content,
      _iterateThroughContentChildren(contentBodyElement.children, baseFontSize),
      isArabic ? arabicFontFamily : fontFamily,
      textAlign);
}

Paragraph parseParagraphHTML(String content,
    {bool isArabic = false,
    TextAlign textAlign = TextAlign.left,
    String arabicFontFamily = "",
    String fontFamily = "",
    double baseFontSize = 19.0}) {
  dom.Element contentBodyElement = parse(content).body;

  return Paragraph.text(
      content,
      _iterateThroughContentChildren(contentBodyElement.children, baseFontSize),
      isArabic ? arabicFontFamily : fontFamily,
      textAlign);
}

List<TextSpan> _iterateThroughContentChildren(
    List<dom.Element> children, double baseFontSize) {
  List<TextSpan> textSpans = List<TextSpan>();

  if (children == null || children.length < 1) return textSpans;

  children.forEach((child) {
    /* superscript */
    if (child.localName == "sup") {
      textSpans.add(TextSpan(
          text: "(${child.text})",
          style: TextStyle(fontSize: 0.5 * baseFontSize)));
    }

    /* subscript */
    else if (child.localName == "sub") {
      textSpans.add(TextSpan(
          text: "(${child.text})",
          style: TextStyle(fontSize: 0.5 * baseFontSize)));
    }

    /* strong */
    else if (child.localName == "strong") {
      textSpans.add(TextSpan(
          text: child.text, style: TextStyle(fontWeight: FontWeight.bold)));
    }

    /* standard text */
    else {
      textSpans.add(TextSpan(text: child.text));
    }

    _iterateThroughContentChildren(child.children, baseFontSize);
  });

  return textSpans;
}
