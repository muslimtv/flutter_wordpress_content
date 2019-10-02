library flutter_wordpress;

import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'external/SoundCloudWidget.dart';
import 'external/YouTubeWidget.dart';
import 'external/IssuuWidget.dart';
import 'model/Paragraph.dart';
import 'model/SimpleArticle.dart';

import 'wp_parser.dart';

class WPContent extends StatelessWidget {
  // raw WordPress content (not rendered). This content should be
  // in <!-- wp: --> tags such as for paragraph <!-- wp:paragraph -->
  // or for image <!-- wp:image -->
  final String rawWPContent;

  // default font family for text
  final String fontFamily;

  // default font size for text
  final double fontSize;

  // if a paragraph contains arabic then provide an identifier
  // to detect arabic for example
  // <!-- wp:paragraph {"align":"center","className":"tk-adobe-arabic"}
  // here we can set the paragraphArabicIdentifier to 'tk-adobe-arabic'
  // as this will be set on paragraphs containing arabic text. Please note
  // that if this identifier appears in normal text anywhere in the paragraph,
  // it might cause the paragraph to be considered as arabic text as well.
  final String paragraphArabicIdentifier;

  // font family for displaying arabic text
  final String arabicFontFamily;

  // provide a widget to display YouTube embedded videos
  final YouTubeWidget youtubeEmbedWidget;

  // provide a widget to display SoundCloud embedded audios
  final SoundCloudWidget soundcloudEmbedWidget;

  // provide a widget to display Issuu embedded PDFs
  final IssuuWidget issuuEmbedWidget;

  const WPContent(this.rawWPContent,
      {this.fontFamily = '',
      this.fontSize = 19.0,
      this.paragraphArabicIdentifier = 'tk-adobe-arabic',
      this.arabicFontFamily = '',
      this.youtubeEmbedWidget,
      this.soundcloudEmbedWidget,
      this.issuuEmbedWidget});

  @override
  Widget build(BuildContext context) {
    return _buildParagraphs(context, rawWPContent);
  }

  Widget _buildParagraphs(BuildContext context, String rawContent) {
    List<Paragraph> paragraphs = _processParagraphs(rawContent);

    if (paragraphs == null || paragraphs.length < 1) {
      return Container();
    }

    return Container(
      padding: EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: paragraphs
            .map((paragraph) => _buildParagraph(context, paragraph))
            .toList(),
      ),
    );
  }

  Widget _buildParagraph(BuildContext context, Paragraph paragraph) {
    Alignment alignment = Alignment.centerRight;
    if (paragraph.textAlign == TextAlign.left) {
      alignment = Alignment.centerLeft;
    } else if (paragraph.textAlign == TextAlign.center) {
      alignment = Alignment.center;
    }

    /* paragraph - heading */
    if (paragraph.type == "heading") {
      return Container(
        padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        alignment: alignment,
        child: Text(
          paragraph.teaserText,
          textDirection: TextDirection.rtl,
          textAlign: paragraph.textAlign,
          style: TextStyle(
              color: Colors.black,
              fontFamily: paragraph.fontFamily,
              fontSize: fontSize + 5.0),
        ),
      );
    }

    /* paragraph - text */
    else if (paragraph.type == "text") {
      return Container(
        padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        alignment: alignment,
        child: Text(
          paragraph.teaserText,
          textDirection: TextDirection.rtl,
          textAlign: paragraph.textAlign,
          style: TextStyle(
              color: Colors.black87,
              fontFamily: paragraph.fontFamily,
              fontSize: fontSize),
        ),
      );
    }

    /* paragraph - image */
    else if (paragraph.type == "image") {
      return Container(
        padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Thumbnail(
              paragraph.imageUri,
              Colors.transparent,
              5.0,
            ),
            Container(
              height: 7.0,
            ),
            Text(
              paragraph.imageCaption,
              style: Theme.of(context).textTheme.caption.copyWith(
                    color: Colors.black87,
                    fontFamily: fontFamily,
                  ),
            )
          ],
        ),
      );
    }

    /* paragraph - youtube embed (https://youtube.com) */
    else if (paragraph.type == "youtube" && youtubeEmbedWidget != null) {
      return youtubeEmbedWidget.buildWithVideoId(
          context, paragraph.youtubeVideoId);
    }

    /* paragraph - soundcloud embed (https://soundcloud.com) */
    else if (paragraph.type == "soundcloud" && soundcloudEmbedWidget != null) {
      return soundcloudEmbedWidget.buildWithTrackId(
          context, paragraph.soundcloudTrackId);
    }

    /* paragraph - issuu embed (http://issuu.com) */
    else if (paragraph.type == "issuu" && issuuEmbedWidget != null) {
      return issuuEmbedWidget.buildWithPDF(context, paragraph.pdf);
    }

    /* paragraph - unexpected (silently ignore) */
    else {
      return Container();
    }
  }

  List<Paragraph> _processParagraphs(String rawContent) {
    List<Paragraph> processedParagraphs = List<Paragraph>();
    try {
      List<String> contentParts = rawContent.split("<!-- wp:");

      contentParts.forEach((c) {
        if (c.startsWith("image")) {
          String caption = "";

          if (c.contains("<figcaption>")) {
            caption = c.substring(
                c.indexOf("<figcaption>") + 12, c.indexOf("</figcaption>"));
          }

          processedParagraphs.add(Paragraph.image(
              RegExp(r'src\s*=\s*"(.+?)"').firstMatch(c).group(1), caption));
        } else if (c.startsWith("core-embed/issuu")) {
          processedParagraphs
              .add(Paragraph.issuu(SimpleArticle.pdfArticle(c, null)));
        } else if (c.startsWith("core-embed/youtube")) {
          processedParagraphs
              .add(Paragraph.youtubeEmbed(YouTubeWidget.getIdFromUrl(c)));
        } else if (c.startsWith("html")) {
          /* soundcloud - embed */
          var soundcloudTrackId = SoundCloudWidget.getIdFromUrl(c);
          if (soundcloudTrackId != null) {
            processedParagraphs
                .add(Paragraph.soundcloudEmbed(soundcloudTrackId));
          }
        } else if (c.startsWith("heading")) {
          String headingContent = c
              .substring(
                  c.indexOf("-->") + 3, c.lastIndexOf("<!-- /wp:heading -->"))
              .replaceAll('\n', '')
              .replaceAll('\r', '');

          bool isArabic = headingContent.contains(paragraphArabicIdentifier);

          TextAlign textAlign = TextAlign.justify;

          if (c.contains('"align":"center"')) {
            textAlign = TextAlign.center;
          } else if (c.contains('"align":"left"')) {
            textAlign = TextAlign.left;
          }

          Paragraph processedHeading = parseHeadingHTML(headingContent,
              isArabic: isArabic,
              textAlign: textAlign,
              fontFamily: fontFamily,
              arabicFontFamily: arabicFontFamily);

          if (processedHeading.teaserText != null &&
              processedHeading.teaserText.isNotEmpty) {
            processedParagraphs.add(processedHeading);
          }
        } else if (c.startsWith("paragraph")) {
          String paragraphContent = c
              .substring(
                  c.indexOf("-->") + 3, c.lastIndexOf("<!-- /wp:paragraph -->"))
              .replaceAll('\n', '')
              .replaceAll('\r', '');

          bool isArabic = paragraphContent.contains(paragraphArabicIdentifier);

          TextAlign textAlign = TextAlign.justify;

          if (c.contains('"align":"center"')) {
            textAlign = TextAlign.center;
          } else if (c.contains('"align":"left"')) {
            textAlign = TextAlign.left;
          }

          Paragraph processedParagraph = parseParagraphHTML(paragraphContent,
              isArabic: isArabic,
              textAlign: textAlign,
              fontFamily: fontFamily,
              arabicFontFamily: arabicFontFamily);

          if (processedParagraph.teaserText != null &&
              processedParagraph.teaserText.isNotEmpty) {
            processedParagraphs.add(parseParagraphHTML(paragraphContent,
                isArabic: isArabic,
                textAlign: textAlign,
                fontFamily: fontFamily,
                arabicFontFamily: arabicFontFamily));
          }
        }
      });
    } catch (exception) {/* ignore */}
    return processedParagraphs;
  }
}

class Thumbnail extends StatelessWidget {
  final String imageURL;
  final Color color;
  final double radius;
  final double aspectRatio;

  const Thumbnail(this.imageURL, this.color, this.radius,
      {this.aspectRatio = 1.7});

  @override
  Widget build(BuildContext context) {
    if (imageURL == null || imageURL.isEmpty || !imageURL.startsWith("http")) {
      return AspectRatio(
        aspectRatio: aspectRatio,
        child: Container(
          color: color,
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(radius)),
      child: CachedNetworkImage(
        imageUrl: imageURL,
        fit: BoxFit.cover,
        placeholder: (context, url) {
          return AspectRatio(
            aspectRatio: aspectRatio,
            child: Container(
              color: color,
            ),
          );
        },
      ),
    );
  }
}
