## [1.0.25] - October 22, 2021

* Updated to Android v2 Embedding API
* Using null-safety

## [1.0.24] - April 1, 2020

* Added categoryId and parentCategoryId to model/SimpleArticle.dart

## [1.0.23] - 7 March, 2020

* added ability to change default text alignment for paragraph text

## [1.0.22] - 2 March, 2020

* Fixed an issue where multiple <strong> tags were not being parsed

## [1.0.21] - 22 February, 2020

* Updated Hearthis.at base url to app.hearthis.at for embeds

## [1.0.20] - 8 February, 2020

* Added ability to change text alignment and colour for WP Quotes independent of paragraph style

## [1.0.19] - 4 February, 2020

* Added support for WP List (<!-- wp:list -->)

## [1.0.18] - 4 February, 2020

* Added support for WP Quotes (<!-- wp:quote -->)

## [1.0.17] - 2 January, 2020

* Fixed an issue causing heading to be right aligned in ltr alignment

## [1.0.16] - 10 December, 2019

* Upgraded cached_network_image to 2.0.0-rc

## [1.0.15] - 10 December, 2019

* Added HearthisAtWidget for embedding audios hosted by your [hearthis.at](https://hearthis.at) account

## [1.0.14] - 27 November, 2019

* Changed SoundCloudEmbedWidget to also include original embed code for SoundCloud widget

## [1.0.13] - 6 October, 2019

* Override == operator in `SimpleArticle` so that it can work in `contains(object)` in Maps and Lists

## [1.0.12] - 6 October, 2019

* Added better exception handling for `SimpleArticle`'s to and from json methods

## [1.0.11] - 5 October, 2019

* Added `FeatureImage` class replacing `imageUrl` field in `SimpleArticle`
* Added the ability to change text colour for Heading, Paragraph and Image Caption

## [1.0.10] - 2 October, 2019

* added parser for <a> tags with url_launcher to open links in browser

## [1.0.9] - 2 October, 2019

* Implemented Superscript <sup>, Subscript <sub> and <strong> tag parser

## [1.0.8] - 2 October, 2019

* Fixed an issue with image captions where super/sub scripts weren't being parsed

## [1.0.7] - 2 October, 2019

* Fixed an issue with TextSpan rendering

## [1.0.6] - 2 October, 2019

* Updated wp_parser to use TextSpan with RichText instead of Unicode for superscript and subscript

## [1.0.5] - 2 October, 2019

* Added JWPlayerWidget for embedding media hosted by your JW Player Account

## [1.0.4] - 2 October, 2019

* Fixed an issue with paragraph spacing

## [1.0.3] - 2 October, 2019

* Updated package description

## [1.0.2] - 2 October, 2019

* Changed embed helper widgets to simple classes

## [1.0.1] - 2 October, 2019

* Changed embed helper widgets to StatelessWidgets
* Added example implementation in documentation

## [1.0.0] - 1 October, 2019

* Added content parser for Heading, Paragraph, YouTube, SoundCloud & Issuu embeds.
