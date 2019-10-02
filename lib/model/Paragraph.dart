import 'package:flutter/cupertino.dart';

import 'SimpleArticle.dart';

class Paragraph {
  final String type;
  final String teaserText;
  final String imageUri;
  final String imageCaption;
  final String jwMediaId;
  final String youtubeVideoId;
  final String soundcloudTrackId;
  final String fontFamily;
  final TextAlign textAlign;
  final SimpleArticle pdf;

  const Paragraph(
      {this.type,
      this.teaserText,
      this.imageUri,
      this.imageCaption,
      this.jwMediaId,
      this.youtubeVideoId,
      this.soundcloudTrackId,
      this.fontFamily,
      this.textAlign,
      this.pdf});

  factory Paragraph.heading(
      String teaserText, String fontFamily, TextAlign textAlign) {
    return Paragraph(
        type: "heading",
        teaserText: teaserText,
        imageUri: "",
        imageCaption: "",
        jwMediaId: "",
        youtubeVideoId: "",
        soundcloudTrackId: "",
        fontFamily: fontFamily,
        textAlign: textAlign);
  }

  factory Paragraph.text(
      String teaserText, String fontFamily, TextAlign textAlign) {
    return Paragraph(
        type: "text",
        teaserText: teaserText,
        imageUri: "",
        imageCaption: "",
        jwMediaId: "",
        youtubeVideoId: "",
        soundcloudTrackId: "",
        fontFamily: fontFamily,
        textAlign: textAlign);
  }

  factory Paragraph.image(String imageUri, String caption) {
    return Paragraph(
      type: "image",
      teaserText: "",
      imageUri: imageUri,
      imageCaption: caption,
      jwMediaId: "",
      youtubeVideoId: "",
      soundcloudTrackId: "",
    );
  }

  factory Paragraph.jwplayer(String url) {
    return Paragraph(
      type: "youtube",
      teaserText: "",
      imageUri: "",
      imageCaption: "",
      jwMediaId: url,
      youtubeVideoId: "",
      soundcloudTrackId: "",
    );
  }

  factory Paragraph.youtubeEmbed(String videoId) {
    return Paragraph(
      type: "youtube",
      teaserText: "",
      imageUri: "",
      imageCaption: "",
      jwMediaId: "",
      youtubeVideoId: videoId,
      soundcloudTrackId: "",
    );
  }

  factory Paragraph.soundcloudEmbed(String trackId) {
    return Paragraph(
      type: "soundcloud",
      teaserText: "",
      imageUri: "",
      imageCaption: "",
      jwMediaId: "",
      youtubeVideoId: "",
      soundcloudTrackId: trackId,
    );
  }

  factory Paragraph.issuu(SimpleArticle pdfArticle) {
    return Paragraph(
        type: "issuu",
        teaserText: "",
        imageUri: "",
        imageCaption: "",
        youtubeVideoId: "",
        soundcloudTrackId: "",
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

    return Paragraph(
        type: json["type"],
        teaserText: json["teaserText"],
        imageUri: json["imageUri"],
        imageCaption: json["imageCaption"],
        youtubeVideoId: json["youtubeVideoId"],
        soundcloudTrackId: json["soundcloudTrackId"],
        fontFamily: json["fontFamily"],
        textAlign: textAlign);
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'teaserText': teaserText,
      'imageUri': imageUri,
      'imageCaption': imageCaption,
      'youtubeVideoId': youtubeVideoId,
      'soundcloudTrackId': soundcloudTrackId,
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
