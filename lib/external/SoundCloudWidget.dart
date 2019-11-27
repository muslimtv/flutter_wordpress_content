import 'package:flutter/cupertino.dart';
import 'package:html_unescape/html_unescape.dart';

class SoundCloudWidget {
  static String getIdFromUrl(String url, [bool trimWhitespaces = true]) {
    if (url == null || url.length == 0) return null;

    if (trimWhitespaces) url = url.trim();

    url = url.replaceAll("%3A", ":");
    url = new HtmlUnescape().convert(url);
    url = url.replaceAll("<!", "");
    url = url.replaceAll("\"", "");
    url = url.replaceAll("\n", "");

    for (var exp in _regexps) {
      Match match = exp.firstMatch(url);
      if (match != null && match.groupCount >= 1) return match.group(1);
    }

    return null;
  }

  static List<RegExp> _regexps = [
    new RegExp(
        r"https:\/\/(?:api\.)?soundcloud\.com\/tracks\?([_\-a-zA-Z0-9]{9,20}).*$"),
    new RegExp(
        r"https:\/\/(?:api\.)?soundcloud(?:-nocookie)?\.com\/tracks\/([_\-a-zA-Z0-9]{9,20}).*$"),
  ];

  Widget buildWithTrackId(
      BuildContext context, String trackId, String embedCode) {
    return Container(
      child: Text("SoundCloudWidget not implemented"),
    );
  }
}
