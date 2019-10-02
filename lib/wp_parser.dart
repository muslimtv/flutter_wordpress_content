import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'model/Paragraph.dart';

// Supported parsers for the content
final List<Function> _contentParsers = [
  _parseSuperscript,
  _parseSubscript,
  _parseStrongTags
];

// Parse heading text
Paragraph parseHeadingHTML(String content,
    {bool isArabic = false,
    TextAlign textAlign = TextAlign.left,
    String arabicFontFamily = "",
    String fontFamily = "",
    double baseFontSize = 16.0}) {
  var data = [TextSpan(text: content)];
  _contentParsers.forEach((p) => data = p(data, baseFontSize));
  return Paragraph.heading(content, _decodeHTML(data),
      isArabic ? arabicFontFamily : fontFamily, textAlign);
}

// Parse paragraph text
Paragraph parseParagraphHTML(String content,
    {bool isArabic = false,
    TextAlign textAlign = TextAlign.left,
    String arabicFontFamily = "",
    String fontFamily = "",
    double baseFontSize = 16.0}) {
  var data = [TextSpan(text: content)];
  _contentParsers.forEach((p) => data = p(data, baseFontSize));
  return Paragraph.text(content, _decodeHTML(data),
      isArabic ? arabicFontFamily : fontFamily, textAlign);
}

// Parse image caption text
List<TextSpan> parseFigureCaptionHTML(String content,
    {double baseFontSize = 12.0}) {
  try {
    var data = [TextSpan(text: content)];
    _contentParsers.forEach((p) => data = p(data, baseFontSize));
    return _decodeHTML(data);
  } catch (exception) {
    print(exception);
    return List<TextSpan>();
  }
}

// Parse superscript tags <sup></sup>
List<TextSpan> _parseSuperscript(List<TextSpan> content, double baseFontSize) {
  final String tag = "<sup>";
  final String endTag = "</sup>";
  final int tagLength = 5;
  final int endTagLength = 6;

  List<TextSpan> spans = List<TextSpan>();

  if (content == null || content.isEmpty) return spans;

  content.forEach((contentSpan) {
    /* contains superscript */
    if (contentSpan.text.contains(tag)) {
      int tagStartIndex = contentSpan.text.indexOf(tag) + tagLength;
      int tagEndIndex = contentSpan.text.indexOf(endTag);

      /* add content before tag */
      if (tagStartIndex > 0) {
        spans.add(TextSpan(
            text: parse(contentSpan.text.substring(0, tagStartIndex - 5))
                .body
                .text));
      }

      String tagContent =
          contentSpan.text.substring(tagStartIndex, tagEndIndex);

      spans.add(TextSpan(
          text: parse(tagContent).body.text + " ",
          style: TextStyle(fontSize: 0.7 * baseFontSize)));

      /* remaining content */
      if (tagEndIndex < contentSpan.text.length - 1) {
        spans.addAll(_parseSuperscript([
          TextSpan(text: contentSpan.text.substring(tagEndIndex + endTagLength))
        ], baseFontSize));
      }
    } else {
      spans.add(contentSpan);
    }
  });

  return spans;
}

// Parse subscripts tags <sub></sub>
List<TextSpan> _parseSubscript(List<TextSpan> content, double baseFontSize) {
  final String tag = "<sub>";
  final String endTag = "</sub>";
  final int tagLength = 5;
  final int endTagLength = 6;

  List<TextSpan> spans = List<TextSpan>();

  if (content == null || content.isEmpty) return spans;

  content.forEach((contentSpan) {
    /* contains superscript */
    if (contentSpan.text.contains(tag)) {
      int tagStartIndex = contentSpan.text.indexOf(tag) + tagLength;
      int tagEndIndex = contentSpan.text.indexOf(endTag);

      /* add content before tag */
      if (tagStartIndex > 0) {
        spans.add(TextSpan(
            text: parse(contentSpan.text.substring(0, tagStartIndex - 5))
                .body
                .text));
      }

      String tagContent =
          contentSpan.text.substring(tagStartIndex, tagEndIndex);

      spans.add(TextSpan(
          text: parse(tagContent).body.text + " ",
          style: TextStyle(fontSize: 0.7 * baseFontSize)));

      /* remaining content */
      if (tagEndIndex < contentSpan.text.length - 1) {
        print(contentSpan.text.substring(tagEndIndex));
        spans.addAll(_parseSuperscript([
          TextSpan(text: contentSpan.text.substring(tagEndIndex + endTagLength))
        ], baseFontSize));
      }
    } else {
      spans.add(contentSpan);
    }
  });

  return spans;
}

// Parse strong tags <strong></strong>
List<TextSpan> _parseStrongTags(List<TextSpan> content, double baseFontSize) {
  final String tag = "<strong>";
  final String endTag = "</strong>";
  final int tagLength = 8;
  final int endTagLength = 9;

  List<TextSpan> spans = List<TextSpan>();

  if (content == null || content.isEmpty) return spans;

  content.forEach((contentSpan) {
    /* contains superscript */
    if (contentSpan.text.contains(tag)) {
      int tagStartIndex = contentSpan.text.indexOf(tag) + tagLength;
      int tagEndIndex = contentSpan.text.indexOf(endTag);

      /* add content before tag */
      if (tagStartIndex > 0) {
        spans.add(TextSpan(
            text: parse(contentSpan.text.substring(0, tagStartIndex - 5))
                .body
                .text));
      }

      String tagContent =
          contentSpan.text.substring(tagStartIndex, tagEndIndex);

      spans.add(TextSpan(
          text: parse(tagContent).body.text + " ",
          style: TextStyle(fontWeight: FontWeight.bold)));

      /* remaining content */
      if (tagEndIndex < contentSpan.text.length - 1) {
        print(contentSpan.text.substring(tagEndIndex));
        spans.addAll(_parseSuperscript([
          TextSpan(text: contentSpan.text.substring(tagEndIndex + endTagLength))
        ], baseFontSize));
      }
    } else {
      spans.add(contentSpan);
    }
  });

  return spans;
}

// HTML decode text for each TextSpan
List<TextSpan> _decodeHTML(List<TextSpan> content) {
  return content
      .map((c) => TextSpan(text: parse(c.text).body.text, style: c.style))
      .toList();
}
