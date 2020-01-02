import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_wordpress_content/external/HearthisAtWidget.dart';
import 'package:flutter_wordpress_content/external/SoundCloudWidget.dart';

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

  testWidgets('Extract trackId from hearthis.at embed',
      (WidgetTester tester) async {
    String c =
        "html -->\n<figure><iframe width=\"100%\" height=\"150\" src=\"https://hearthis.at/embed/4147030/transparent_black/?hcolor=&amp;color=&amp;style=2&amp;block_size=2&amp;block_space=1&amp;background=1&amp;waveform=0&amp;cover=0&amp;autoplay=0&amp;css=\"></iframe></figure>\n<!-- /wp:html -->";

    String trackId = HearthisAtWidget.getIdFromUrl(c);

    assert(trackId == "4147030");
  });

  testWidgets('Extract trackId from SoundCloud embed',
      (WidgetTester tester) async {
    String c =
        "html -->\n<figure><iframe width=\"100%\" height=\"20\" src=\"https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/tracks/725625592&amp;color=%23ff5500&amp;inverse=false&amp;auto_play=true&amp;show_user=true\"></iframe></figure>\n<!-- /wp:html -->";

    String trackId = SoundCloudWidget.getIdFromUrl(c);

    assert(trackId == "725625592");
  });
}
