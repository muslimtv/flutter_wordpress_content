import 'dart:ui';

import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'model/Paragraph.dart';

Paragraph parseHeadingHTML(String content,
    {bool isArabic = false,
      TextAlign textAlign = TextAlign.left,
      String arabicFontFamily = "",
      String fontFamily = ""}) {
  Element contentBodyElement = parse(content).body;

  _iterateThroughContentChildren(contentBodyElement.children);

  return Paragraph.heading(contentBodyElement.text,
      isArabic ? arabicFontFamily : fontFamily, textAlign);
}

Paragraph parseParagraphHTML(String content,
    {bool isArabic = false,
      TextAlign textAlign = TextAlign.left,
      String arabicFontFamily = "",
      String fontFamily = ""}) {
  Element contentBodyElement = parse(content).body;

  _iterateThroughContentChildren(contentBodyElement.children);

  return Paragraph.text(contentBodyElement.text,
      isArabic ? arabicFontFamily : fontFamily, textAlign);
}

void _iterateThroughContentChildren(List<Element> children) {
  if (children == null || children.length < 1) return;

  children.forEach((child) {
    /* superscript */
    if (child.localName == "sup") {
      child.text = CharacterScriptMap.instance().mapSuperscript(child.text);
    }

    /* subscript */
    else if (child.localName == "sub") {
      child.text = CharacterScriptMap.instance().mapSubscript(child.text);
    }

    /* strong */
    else if (child.localName == "strong") {}

    _iterateThroughContentChildren(child.children);
  });
}

class CharacterScriptMap {
  Map<String, CharacterScript> characterScriptMap =
  Map<String, CharacterScript>();

  String mapSuperscript(String s) {
    return s.runes.map((rune) {
      String c = new String.fromCharCode(rune);
      if (characterScriptMap.containsKey(c)) {
        return characterScriptMap[c].superscript;
      }
      return c;
    }).join("");
  }

  String mapSubscript(String s) {
    return s.runes.map((rune) {
      String c = new String.fromCharCode(rune);
      if (characterScriptMap.containsKey(c)) {
        return characterScriptMap[c].subscript;
      }
      return c;
    }).join("");
  }

  CharacterScriptMap(this.characterScriptMap);

  factory CharacterScriptMap.instance() {
    Map<String, CharacterScript> characterScriptMap =
    Map<String, CharacterScript>();

    characterScriptMap.putIfAbsent(
        "0", () => CharacterScript('\u2070', '\u2080'));
    characterScriptMap.putIfAbsent(
        "1", () => CharacterScript('\u00B9', '\u2081'));
    characterScriptMap.putIfAbsent(
        "2", () => CharacterScript('\u00B2', '\u2082'));
    characterScriptMap.putIfAbsent(
        "3", () => CharacterScript('\u00B3', '\u2083'));
    characterScriptMap.putIfAbsent(
        "4", () => CharacterScript('\u2074', '\u2084'));
    characterScriptMap.putIfAbsent(
        "5", () => CharacterScript('\u2075', '\u2085'));
    characterScriptMap.putIfAbsent(
        "6", () => CharacterScript('\u2076', '\u2086'));
    characterScriptMap.putIfAbsent(
        "7", () => CharacterScript('\u2077', '\u2087'));
    characterScriptMap.putIfAbsent(
        "8", () => CharacterScript('\u2078', '\u2088'));
    characterScriptMap.putIfAbsent(
        "9", () => CharacterScript('\u2079', '\u2089'));
    characterScriptMap.putIfAbsent(
        "a", () => CharacterScript('\u1d43', '\u2090'));
    characterScriptMap.putIfAbsent("b", () => CharacterScript('\u1d47', 'b'));
    characterScriptMap.putIfAbsent("c", () => CharacterScript('\u1d9c', 'c'));
    characterScriptMap.putIfAbsent("d", () => CharacterScript('\u1d48', 'd'));
    characterScriptMap.putIfAbsent(
        "e", () => CharacterScript('\u1d49', '\u2091'));
    characterScriptMap.putIfAbsent("f", () => CharacterScript('\u1da0', 'f'));
    characterScriptMap.putIfAbsent("g", () => CharacterScript('\u1d4d', 'g'));
    characterScriptMap.putIfAbsent(
        "h", () => CharacterScript('\u02b0', '\u2095'));
    characterScriptMap.putIfAbsent(
        "i", () => CharacterScript('\u2071', '\u1d62'));
    characterScriptMap.putIfAbsent(
        "j", () => CharacterScript('\u02b2', '\u2c7c'));
    characterScriptMap.putIfAbsent(
        "k", () => CharacterScript('\u1d4f', '\u2096'));
    characterScriptMap.putIfAbsent(
        "l", () => CharacterScript('\u02e1', '\u2097'));
    characterScriptMap.putIfAbsent(
        "m", () => CharacterScript('\u1d50', '\u2098'));
    characterScriptMap.putIfAbsent(
        "n", () => CharacterScript('\u207f', '\u2099'));
    characterScriptMap.putIfAbsent(
        "o", () => CharacterScript('\u1d52', '\u2092'));
    characterScriptMap.putIfAbsent(
        "p", () => CharacterScript('\u1d56', '\u209a'));
    characterScriptMap.putIfAbsent("q", () => CharacterScript('q', 'q'));
    characterScriptMap.putIfAbsent(
        "r", () => CharacterScript('\u02b3', '\u1d63'));
    characterScriptMap.putIfAbsent(
        "s", () => CharacterScript('\u02e2', '\u209b'));
    characterScriptMap.putIfAbsent(
        "t", () => CharacterScript('\u1d57', '\u209c'));
    characterScriptMap.putIfAbsent(
        "u", () => CharacterScript('\u1d58', '\u1d64'));
    characterScriptMap.putIfAbsent(
        "v", () => CharacterScript('\u1d5b', '\u1d65'));
    characterScriptMap.putIfAbsent("w", () => CharacterScript('\u02b7', 'w'));
    characterScriptMap.putIfAbsent(
        "x", () => CharacterScript('\u02e3', '\u2093'));
    characterScriptMap.putIfAbsent("y", () => CharacterScript('\u02b8', 'y'));
    characterScriptMap.putIfAbsent("z", () => CharacterScript('z', 'z'));
    characterScriptMap.putIfAbsent("A", () => CharacterScript('\u1d2c', 'A'));
    characterScriptMap.putIfAbsent("B", () => CharacterScript('\u1d2e', 'B'));
    characterScriptMap.putIfAbsent("C", () => CharacterScript('C', 'C'));
    characterScriptMap.putIfAbsent("D", () => CharacterScript('\u1d30', 'D'));
    characterScriptMap.putIfAbsent("E", () => CharacterScript('\u1d31', 'E'));
    characterScriptMap.putIfAbsent("F", () => CharacterScript('F', 'F'));
    characterScriptMap.putIfAbsent("G", () => CharacterScript('\u1d33', 'G'));
    characterScriptMap.putIfAbsent("H", () => CharacterScript('\u1d34', 'H'));
    characterScriptMap.putIfAbsent("I", () => CharacterScript('\u1d35', 'I'));
    characterScriptMap.putIfAbsent("J", () => CharacterScript('\u1d36', 'J'));
    characterScriptMap.putIfAbsent("K", () => CharacterScript('\u1d37', 'K'));
    characterScriptMap.putIfAbsent("L", () => CharacterScript('\u1d38', 'L'));
    characterScriptMap.putIfAbsent("M", () => CharacterScript('\u1d39', 'M'));
    characterScriptMap.putIfAbsent("N", () => CharacterScript('\u1d3a', 'N'));
    characterScriptMap.putIfAbsent("O", () => CharacterScript('\u1d3c', 'O'));
    characterScriptMap.putIfAbsent("P", () => CharacterScript('\u1d3e', 'P'));
    characterScriptMap.putIfAbsent("Q", () => CharacterScript('Q', 'Q'));
    characterScriptMap.putIfAbsent("R", () => CharacterScript('\u1d3f', 'R'));
    characterScriptMap.putIfAbsent("S", () => CharacterScript('S', 'S'));
    characterScriptMap.putIfAbsent("T", () => CharacterScript('\u1d40', 'T'));
    characterScriptMap.putIfAbsent("U", () => CharacterScript('\u1d41', 'U'));
    characterScriptMap.putIfAbsent("V", () => CharacterScript('\u2c7d', 'V'));
    characterScriptMap.putIfAbsent("W", () => CharacterScript('\u1d42', 'W'));
    characterScriptMap.putIfAbsent("X", () => CharacterScript('X', 'X'));
    characterScriptMap.putIfAbsent("Y", () => CharacterScript('Y', 'Y'));
    characterScriptMap.putIfAbsent("Z", () => CharacterScript('Z', 'Z'));

    return CharacterScriptMap(characterScriptMap);
  }
}

class CharacterScript {
  final String superscript;
  final String subscript;

  const CharacterScript(this.superscript, this.subscript);
}
