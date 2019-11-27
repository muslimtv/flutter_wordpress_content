# flutter_wordpress_content

A Flutter helper widget to parse WordPress content in raw form.

## Getting Started

In order for this plugin to work, you must provide the raw content which is saved
in the database (not the rendered content returned by the API). For example see below 
comparison:

###### Raw Content
```$xslt
<!-- wp:paragraph -->Some text to be shown<!-- /wp:paragraph -->
<!-- wp:image --><figure><img src="https://example.com/image.png" /></figure><!-- /wp:image -->
```
###### Rendered Content
```$xslt
<p>Some text to be shown</p>
<img src="https://example.com/image.png" />
```
---
### Using WPContent Class
For detail on providing YouTube, SoundCloud or Issue widgets, see __Supported Types__ section below.
```dart
Widget buildMyContent(BuildContext context) {
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
            issuuEmbedWidget: IssueEmbedWidget(),
            jwPlayerWidget: JWPlayerEmbedWidget(),
          ),
        ),
      ),
    );
  }
```
### Supported Types
At this moment, this plugin supports the following types of content.

#### Heading `<!-- wp:heading -->`
Standard WP heading.

#### Paragraph `<!-- wp:paragraph -->`
Standard WP paragraph.

#### YouTube Embed `<!-- wp:core-embed/youtube -->`
For embedding YouTube, create your own widget for displaying YouTube video and inherit
from the provided `YouTubeWidget`. This widget will give you access to the `videoId`. Use
this ID in your widget to render YouTube player.
```dart
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
```

#### Issue PDF Embed `<!-- wp:core-embed/issuu -->`
For embedding Issuu pdfs, create your own widget for displaying PDF and inherit
from the provided `IssuuWidget`. This widget will give you access to an instance of `SimpleArticle`.
```dart
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

```
The instance of `SimpleArticle` will give you access to raw content where you can extract
the PDF url. See below for an example. Use this URL to then display PDF in your widget.
```dart
String rawContent = mySimpleArticle.paragraphRawContent;

String extractedURL =
  RegExp(r'(?:"url":")(.*?)(?:")').firstMatch(rawContent).group(1);
```

#### SoundCloud Embed `<!-- wp:html -->`
When embedding SoundCloud, please make sure you use the embed code provided by
SoundCloud and not the standard way of embedding in WordPress. This is necessary
because the embed code contains track ID which is used to fetch more information
about the track through SC API.

Inheriting from the provided `SoundCloudWidget` will give you access to `trackId` field.
Use this ID to fetch the stream URL and metadata and play the audio. For an example of
how to do that, please see the [flutter_playout](https://pub.dev/packages/flutter_playout) plugin.
```dart
class SoundCloudEmbedWidget extends SoundCloudWidget {
  final String title;
  final String subtitle;

  SoundCloudEmbedWidget(this.title, this.subtitle);

  @override
  Widget buildWithTrackId(BuildContext context, String trackId, String embedCode) {
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
```

#### JWPlayer Embed
For embedding JWPlayer hosted media, create your own widget for displaying video and inherit
from the provided `JWPlayerWidget`. This widget will give you access to the `mediaId`. Use
this ID in your widget to render the player.
```dart
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
```