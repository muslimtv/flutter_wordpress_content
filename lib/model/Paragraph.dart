import 'package:flutter/material.dart';
import 'package:flutter_wordpress_content/wp_parser.dart';

import 'SimpleArticle.dart';

class Paragraph {
  final String type;
  final String rawContent;
  final List<TextSpan> textSpans;
  final String imageUri;
  final String jwMediaId;
  final String youtubeVideoId;
  final String soundcloudTrackId;
  final String soudcloudEmbedCode;
  final String hearthisAtTrackId;
  final String fontFamily;
  final TextAlign textAlign;
  final SimpleArticle pdf;

  const Paragraph(
      {this.type,
      this.rawContent,
      this.textSpans,
      this.imageUri,
      this.jwMediaId,
      this.youtubeVideoId,
      this.soundcloudTrackId,
      this.soudcloudEmbedCode,
      this.hearthisAtTrackId,
      this.fontFamily,
      this.textAlign,
      this.pdf});

  factory Paragraph.heading(String rawContent, List<TextSpan> textSpans,
      String fontFamily, TextAlign textAlign) {
    return Paragraph(
        type: "heading",
        rawContent: rawContent,
        textSpans: textSpans,
        imageUri: "",
        jwMediaId: "",
        youtubeVideoId: "",
        soundcloudTrackId: "",
        soudcloudEmbedCode: "",
        hearthisAtTrackId: "",
        fontFamily: fontFamily,
        textAlign: textAlign);
  }

  factory Paragraph.text(String rawContent, List<TextSpan> textSpans,
      String fontFamily, TextAlign textAlign) {
    return Paragraph(
        type: "text",
        rawContent: rawContent,
        textSpans: textSpans,
        imageUri: "",
        jwMediaId: "",
        youtubeVideoId: "",
        soundcloudTrackId: "",
        soudcloudEmbedCode: "",
        hearthisAtTrackId: "",
        fontFamily: fontFamily,
        textAlign: textAlign);
  }

  factory Paragraph.image(
      String imageUri, String caption, List<TextSpan> captionSpans) {
    return Paragraph(
      type: "image",
      rawContent: caption,
      textSpans: captionSpans,
      imageUri: imageUri,
      jwMediaId: "",
      youtubeVideoId: "",
      soundcloudTrackId: "",
      soudcloudEmbedCode: "",
      hearthisAtTrackId: "",
    );
  }

  factory Paragraph.jwplayer(String url) {
    return Paragraph(
      type: "youtube",
      rawContent: "",
      textSpans: List<TextSpan>(),
      imageUri: "",
      jwMediaId: url,
      youtubeVideoId: "",
      soundcloudTrackId: "",
      soudcloudEmbedCode: "",
      hearthisAtTrackId: "",
    );
  }

  factory Paragraph.youtubeEmbed(String videoId) {
    return Paragraph(
      type: "youtube",
      rawContent: "",
      textSpans: List<TextSpan>(),
      imageUri: "",
      jwMediaId: "",
      youtubeVideoId: videoId,
      soundcloudTrackId: "",
      soudcloudEmbedCode: "",
      hearthisAtTrackId: "",
    );
  }

  factory Paragraph.soundcloudEmbed(String trackId, String embedCode) {
    return Paragraph(
      type: "soundcloud",
      rawContent: "",
      textSpans: List<TextSpan>(),
      imageUri: "",
      jwMediaId: "",
      youtubeVideoId: "",
      soundcloudTrackId: trackId,
      soudcloudEmbedCode: embedCode,
      hearthisAtTrackId: "",
    );
  }

  factory Paragraph.hearthisAtEmbed(String trackId) {
    return Paragraph(
      type: "hearthis.at",
      rawContent: "",
      textSpans: List<TextSpan>(),
      imageUri: "",
      jwMediaId: "",
      youtubeVideoId: "",
      soundcloudTrackId: "",
      soudcloudEmbedCode: "",
      hearthisAtTrackId: trackId,
    );
  }

  factory Paragraph.issuu(SimpleArticle pdfArticle) {
    return Paragraph(
        type: "issuu",
        rawContent: "",
        textSpans: List<TextSpan>(),
        imageUri: "",
        youtubeVideoId: "",
        soundcloudTrackId: "",
        soudcloudEmbedCode: "",
        hearthisAtTrackId: "",
        pdf: pdfArticle);
  }

  factory Paragraph.fromJson(Map<String, dynamic> json) {
    if (json == null) return new Paragraph();

    TextAlign textAlign = TextAlign.right;
    try {
      String textAlignString = json['textAlign'];
      textAlign = textAlignString == 'left'
          ? TextAlign.left
          : textAlignString == 'center' ? TextAlign.center : TextAlign.right;
    } catch (exception) {/* ignore */}

    String type = json["type"];

    String rawContent = json["rawContent"];

    String fontFamily = json["fontFamily"];

    List<TextSpan> textSpans = List<TextSpan>();
    try {
      if (type == "heading") {
        textSpans = parseHeadingHTML(rawContent,
                textAlign: textAlign, fontFamily: fontFamily)
            .textSpans;
      } else if (type == "text") {
        textSpans = parseParagraphHTML(rawContent,
                textAlign: textAlign, fontFamily: fontFamily)
            .textSpans;
      } else if (type == "image") {
        textSpans = parseFigureCaptionHTML(rawContent);
      }
    } catch (exception) {/* ignore */}

    return Paragraph(
        type: json["type"],
        rawContent: rawContent,
        textSpans: textSpans,
        imageUri: json["imageUri"],
        youtubeVideoId: json["youtubeVideoId"],
        soundcloudTrackId: json["soundcloudTrackId"],
        soudcloudEmbedCode: json["soudcloudEmbedCode"],
        hearthisAtTrackId: json["hearthisAtTrackId"],
        fontFamily: fontFamily,
        textAlign: textAlign);
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'rawContent': rawContent,
      'imageUri': imageUri,
      'youtubeVideoId': youtubeVideoId,
      'soundcloudTrackId': soundcloudTrackId,
      'soudcloudEmbedCode': soudcloudEmbedCode,
      'hearthisAtTrackId': hearthisAtTrackId,
      'fontFamily': fontFamily,
      'textAlign': textAlign == TextAlign.left
          ? 'left'
          : textAlign == TextAlign.center ? 'center' : 'right',
    };
  }

  static List<dynamic> toJsonFromList(List<Paragraph> paragraphs) {
    return paragraphs.map((p) => p.toJson()).toList();
  }
}
