library flutter_wordpress;

import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wordpress_content/external/HearthisAtWidget.dart';
import 'package:flutter_wordpress_content/external/JWPlayerWidget.dart';

import 'external/IssuuWidget.dart';
import 'external/SoundCloudWidget.dart';
import 'external/YouTubeWidget.dart';
import 'model/Paragraph.dart';
import 'model/SimpleArticle.dart';
import 'wp_parser.dart';

class WPContent extends StatelessWidget {
  // raw WordPress content (not rendered). This content should be
  // in <!-- wp: --> tags such as for paragraph <!-- wp:paragraph -->
  // or for image <!-- wp:image -->
  final String rawWPContent;

  // set text direction
  final TextDirection textDirection;

  // set colour for the heading text
  final Color headingTextColor;

  // set colour for the paragraph text
  final Color paragraphTextColor;

  // set colour for the image caption text
  final Color imageCaptionTextColor;

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

  // default text alignment for paragraph text if none specified in wp-paragraph
  // tag
  final TextAlign defaultParagraphTextAlign;

  // text alignment for WP Quote <!-- wp:quote -->
  final TextAlign quoteTextAlignment;

  // text colour for WP Quote <!-- wp:quote -->
  final Color quoteTextColour;

  // provide a widget to display YouTube embedded videos
  final YouTubeWidget youtubeEmbedWidget;

  // provide a widget to display SoundCloud embedded audios
  final SoundCloudWidget soundcloudEmbedWidget;

  // provide a widget to display Hearthis.at embedded audios
  final HearthisAtWidget hearthisAtWidget;

  // provide a widget to display Issuu embedded PDFs
  final IssuuWidget issuuEmbedWidget;

  // provide a widget to display JWPlayer video
  final JWPlayerWidget jwPlayerWidget;

  const WPContent(this.rawWPContent,
      {this.textDirection = TextDirection.ltr,
      this.headingTextColor = Colors.black,
      this.paragraphTextColor = Colors.black,
      this.imageCaptionTextColor = Colors.black,
      this.fontFamily = '',
      this.fontSize = 16.0,
      this.paragraphArabicIdentifier = "",
      this.arabicFontFamily = '',
      this.defaultParagraphTextAlign = TextAlign.justify,
      this.quoteTextAlignment = TextAlign.center,
      this.quoteTextColour = Colors.black,
      this.youtubeEmbedWidget = const YouTubeWidget(),
      this.soundcloudEmbedWidget = const SoundCloudWidget(),
      this.hearthisAtWidget = const HearthisAtWidget(),
      this.issuuEmbedWidget = const IssuuWidget(),
      this.jwPlayerWidget = const JWPlayerWidget()});

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
    Alignment alignment = Alignment.centerLeft;
    if (paragraph.textAlign == TextAlign.left) {
      alignment = Alignment.centerLeft;
    } else if (paragraph.textAlign == TextAlign.center) {
      alignment = Alignment.center;
    } else if (paragraph.textAlign == TextAlign.right) {
      alignment = Alignment.centerRight;
    }

    /* paragraph - heading */
    if (paragraph.type == "heading") {
      return Container(
        padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 19.0),
        alignment: alignment,
        child: RichText(
          text: TextSpan(
            children: paragraph.textSpans,
            style: DefaultTextStyle.of(context).style.copyWith(
                color: headingTextColor,
                fontFamily: paragraph.fontFamily,
                fontSize: fontSize + 5.0),
          ),
          textDirection: textDirection,
          textAlign: paragraph.textAlign,
        ),
      );
    }

    /* paragraph - text */
    else if (paragraph.type == "text") {
      return Container(
        padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 13.0),
        alignment: alignment,
        child: RichText(
          text: TextSpan(
            children: paragraph.textSpans,
            style: DefaultTextStyle.of(context).style.copyWith(
                color: paragraphTextColor,
                fontFamily: paragraph.fontFamily,
                fontSize: fontSize),
          ),
          textDirection: textDirection,
          textAlign: paragraph.textAlign,
        ),
      );
    }

    /* paragraph - quote */
    else if (paragraph.type == "quote") {
      return Container(
        padding: EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 13.0),
        alignment: alignment,
        child: RichText(
          text: TextSpan(
            children: paragraph.textSpans,
            style: DefaultTextStyle.of(context).style.copyWith(
                color: quoteTextColour,
                fontFamily: paragraph.fontFamily,
                fontSize: fontSize,
                fontWeight: FontWeight.bold),
          ),
          textDirection: textDirection,
          textAlign: paragraph.textAlign,
        ),
      );
    }

    /* paragraph - image */
    else if (paragraph.type == "image") {
      return Container(
        padding: EdgeInsets.fromLTRB(3.0, 10.0, 3.0, 20.0),
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
            /* image caption */
            RichText(
              text: TextSpan(
                children: paragraph.textSpans,
                style: DefaultTextStyle.of(context).style.copyWith(
                    color: imageCaptionTextColor,
                    fontFamily: fontFamily,
                    fontSize: 0.7 * fontSize),
              ),
            )
          ],
        ),
      );
    }

    /* paragraph - jwplayer embed (https://jwplayer.com) */
    else if (paragraph.type == "jwplayer" && jwPlayerWidget != null) {
      return jwPlayerWidget.buildWithMediaId(context, paragraph.jwMediaId);
    }

    /* paragraph - youtube embed (https://youtube.com) */
    else if (paragraph.type == "youtube" && youtubeEmbedWidget != null) {
      return youtubeEmbedWidget.buildWithVideoId(
          context, paragraph.youtubeVideoId);
    }

    /* paragraph - soundcloud embed (https://soundcloud.com) */
    else if (paragraph.type == "soundcloud" && soundcloudEmbedWidget != null) {
      return soundcloudEmbedWidget.buildWithTrackId(
          context, paragraph.soundcloudTrackId, paragraph.soudcloudEmbedCode);
    }

    /* paragraph - hearthis.at embed (https://hearthis.at) */
    else if (paragraph.type == "hearthis.at" && hearthisAtWidget != null) {
      return hearthisAtWidget.buildWithTrackId(
          context, paragraph.hearthisAtTrackId);
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
    List<Paragraph> processedParagraphs = [];
    try {
      List<String> contentParts = rawContent.split("<!-- wp:");

      contentParts.forEach((c) {
        if (c.startsWith("image")) {
          String caption = "";

          if (c.contains("<figcaption>")) {
            caption = c.substring(
                c.indexOf("<figcaption>") + 12, c.indexOf("</figcaption>"));
          }

          RegExpMatch? fm = RegExp(r'src\s*=\s*"(.+?)"').firstMatch(c);
          processedParagraphs.add(Paragraph.image(
              fm != null ? fm.group(1) : "",
              caption,
              parseFigureCaptionHTML(caption, baseFontSize: 0.7 * fontSize)));
        } else if (c.startsWith("core-embed/issuu")) {
          processedParagraphs
              .add(Paragraph.issuu(SimpleArticle.pdfArticle(c, null)));
        } else if (c.startsWith("shortcode")) {
          RegExpMatch? regExMatch =
              RegExp(r'\[(\w+[\s*]+)*(\w+)\]').firstMatch(c);

          try {
            if (regExMatch != null) {
              switch (regExMatch.group(1)!.trim()) {
                case "jwplayer":
                  processedParagraphs
                      .add(Paragraph.jwplayer(regExMatch.group(2)));
                  break;
                default:
                  break;
              }
            }
          } catch (exception) {/* ignore */}
        } else if (c.startsWith("core-embed/youtube")) {
          processedParagraphs
              .add(Paragraph.youtubeEmbed(YouTubeWidget.getIdFromUrl(c)));
        } else if (c.startsWith("html")) {
          /* soundcloud - embed */
          if (c.contains("soundcloud.com")) {
            var soundcloudTrackId = SoundCloudWidget.getIdFromUrl(c);
            var soundcloudEmbedCode = c.substring(
                c.indexOf("-->") + 3, c.lastIndexOf("<!-- /wp:html -->"));
            if (soundcloudTrackId != null) {
              processedParagraphs.add(Paragraph.soundcloudEmbed(
                  soundcloudTrackId, soundcloudEmbedCode));
            }
          }

          /* hearthis.at - embed */
          else if (c.contains("hearthis.at")) {
            var hearthisAtTrackId = HearthisAtWidget.getIdFromUrl(c);
            if (hearthisAtTrackId != null) {
              processedParagraphs
                  .add(Paragraph.hearthisAtEmbed(hearthisAtTrackId));
            }
          }
        } else if (c.startsWith("heading")) {
          String headingContent = c
              .substring(
                  c.indexOf("-->") + 3, c.lastIndexOf("<!-- /wp:heading -->"))
              .replaceAll('\n', ' ')
              .replaceAll('\r', ' ');

          bool isArabic = paragraphArabicIdentifier != null &&
              headingContent.contains(paragraphArabicIdentifier);

          TextAlign textAlign = TextAlign.justify;

          if (c.contains('"align":"center"')) {
            textAlign = TextAlign.center;
          } else if (c.contains('"align":"left"')) {
            textAlign = TextAlign.left;
          } else if (c.contains('"align":"right"')) {
            textAlign = TextAlign.right;
          }

          processedParagraphs.add(parseHeadingHTML(headingContent,
              isArabic: isArabic,
              textAlign: textAlign,
              fontFamily: fontFamily,
              arabicFontFamily: arabicFontFamily,
              baseFontSize: fontSize));
        } else if (c.startsWith("paragraph")) {
          String paragraphContent = c
              .substring(
                  c.indexOf("-->") + 3, c.lastIndexOf("<!-- /wp:paragraph -->"))
              .replaceAll('\n', ' ')
              .replaceAll('\r', ' ');

          bool isArabic = paragraphArabicIdentifier != null &&
              paragraphContent.contains(paragraphArabicIdentifier);

          TextAlign textAlign = defaultParagraphTextAlign;

          if (c.contains('"align":"center"')) {
            textAlign = TextAlign.center;
          } else if (c.contains('"align":"left"')) {
            textAlign = TextAlign.left;
          } else if (c.contains('"align":"right"')) {
            textAlign = TextAlign.right;
          }

          processedParagraphs.add(parseParagraphHTML(paragraphContent,
              isArabic: isArabic,
              textAlign: textAlign,
              fontFamily: fontFamily,
              arabicFontFamily: arabicFontFamily,
              baseFontSize: fontSize));
        } else if (c.startsWith("quote")) {
          String paragraphContent = c
              .substring(
                  c.indexOf("-->") + 3, c.lastIndexOf("<!-- /wp:quote -->"))
              .replaceAll('\n', ' ')
              .replaceAll('\r', ' ');

          bool isArabic = paragraphArabicIdentifier != null &&
              paragraphContent.contains(paragraphArabicIdentifier);

          processedParagraphs.add(parseQuoteHTML(paragraphContent,
              isArabic: isArabic,
              textAlign: quoteTextAlignment,
              fontFamily: fontFamily,
              arabicFontFamily: arabicFontFamily,
              baseFontSize: fontSize));
        } else if (c.startsWith("list")) {
          String listContent = c
              .substring(
                  c.indexOf("-->") + 3, c.lastIndexOf("<!-- /wp:list -->"))
              .replaceAll('\n', ' ')
              .replaceAll('\r', ' ')
              .replaceAll("<ol>", "")
              .replaceAll("</ol>", "")
              .replaceAll("</li>", "");

          List<String> listItems = listContent.split("<li>");

          TextAlign textAlign = TextAlign.justify;

          if (c.contains('"align":"center"')) {
            textAlign = TextAlign.center;
          } else if (c.contains('"align":"left"')) {
            textAlign = TextAlign.left;
          } else if (c.contains('"align":"right"')) {
            textAlign = TextAlign.right;
          }

          bool isArabic = paragraphArabicIdentifier != null &&
              listContent.contains(paragraphArabicIdentifier);

          listItems.forEach((li) {
            processedParagraphs.add(parseListHTML(li,
                isArabic: isArabic,
                textAlign: textAlign,
                fontFamily: fontFamily,
                arabicFontFamily: arabicFontFamily,
                baseFontSize: fontSize));
          });
        }
      });
    } catch (exception) {
      print(exception);
    }
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
