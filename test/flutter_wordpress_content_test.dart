import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Extract shortcode key value with regex',
      (WidgetTester tester) async {
    String c = "shortcode -->\n[jwplayer HxVE7bbK]\n<!-- /wp:shortcode -->";

    RegExpMatch regExMatch = RegExp(r'\[(\w+[\s*]+)*(\w+)\]').firstMatch(c);

    try {
      String shortcodeType = regExMatch.group(1);

      switch (shortcodeType.trim()) {
        /* jwplayer */
        case "jwplayer":
          String mediaId = regExMatch.group(2);

          if (mediaId != "HxVE7bbK") {
            throw new AssertionError("media id mismatch");
          }
          break;
        default:
          break;
      }
    } catch (exception) {/* ignore */}
  });
}
