import 'package:flutter/material.dart';
import 'package:flutter_wordpress_content/external/HearthisAtWidget.dart';
import 'package:flutter_wordpress_content/external/IssuuWidget.dart';
import 'package:flutter_wordpress_content/external/JWPlayerWidget.dart';
import 'package:flutter_wordpress_content/external/SoundCloudWidget.dart';
import 'package:flutter_wordpress_content/external/YouTubeWidget.dart';
import 'package:flutter_wordpress_content/model/SimpleArticle.dart';
import 'package:flutter_wordpress_content/wp_content.dart';

void main() => runApp(WordPressContentExample());

class WordPressContentExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: WPContent(
            "raw_content",
            headingTextColor: Colors.black,
            paragraphTextColor: Colors.black,
            imageCaptionTextColor: Colors.black,
            textDirection: TextDirection.ltr,
            fontFamily: 'my_font_family',
            fontSize: 19.0,
            paragraphArabicIdentifier: 'tk-adobe-arabic',
            arabicFontFamily: 'my_arabic_font_family',
            youtubeEmbedWidget: YouTubeEmbedWidget(),
            soundcloudEmbedWidget:
                SoundCloudEmbedWidget("Audio Title", "Audio Subtitle"),
            hearthisAtWidget:
                HearthisAtEmbedWidget("Audio Title", "Audio Subtitle"),
            issuuEmbedWidget: IssueEmbedWidget(),
            jwPlayerWidget: JWPlayerEmbedWidget(),
          ),
        ),
      ),
    );
  }
}

class YouTubeEmbedWidget extends YouTubeWidget {
  @override
  Widget buildWithVideoId(BuildContext context, String videoId) {
    return Container(
      padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 20.0),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          child: Text(videoId),
        ),
      ),
    );
  }
}

class SoundCloudEmbedWidget extends SoundCloudWidget {
  final String title;
  final String subtitle;

  SoundCloudEmbedWidget(this.title, this.subtitle);

  @override
  Widget buildWithTrackId(
      BuildContext context, String trackId, String embedCode) {
    return Container(
      padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 30.0),
      child: Container(
        child: Column(
          children: <Widget>[Text(title), Text(subtitle), Text(trackId)],
        ),
      ),
    );
  }
}

class HearthisAtEmbedWidget extends HearthisAtWidget {
  final String title;
  final String subtitle;

  HearthisAtEmbedWidget(this.title, this.subtitle);

  @override
  Widget buildWithTrackId(BuildContext context, String trackId) {
    return Container(
      padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 30.0),
      child: Container(
        child: Column(
          children: <Widget>[Text(title), Text(subtitle), Text(trackId)],
        ),
      ),
    );
  }
}

class IssueEmbedWidget extends IssuuWidget {
  @override
  Widget buildWithPDF(BuildContext context, SimpleArticle pdf) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Center(
        child: RaisedButton(
            padding: EdgeInsets.all(10.0),
            color: Colors.green,
            child: Container(
              padding: EdgeInsets.only(top: 5.0),
              child: Text(
                "View PDF",
                style: Theme.of(context)
                    .textTheme
                    .body1
                    .copyWith(color: Colors.white),
              ),
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute<void>(
                builder: (context) {
                  return Container(
                    child: Text(pdf.paragraphRawContent),
                  );
                },
              ));
            }),
      ),
    );
  }
}

class JWPlayerEmbedWidget extends JWPlayerWidget {
  @override
  Widget buildWithMediaId(BuildContext context, String mediaId) {
    return Container(
      padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 20.0),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          child: Text(mediaId),
        ),
      ),
    );
  }
}
