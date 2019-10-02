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
### Supported Types
At this moment, this plugin supports the following types of content.

#### Heading `<!-- wp:heading -->`
Standard WP heading.

#### Paragraph `<!-- wp:paragraph -->`
Standard WP paragraph.

#### YouTube Embed `<!-- wp:core-embed/youtube -->`
Standard YouTube embed.

#### Issue PDF Embed `<!-- wp:core-embed/issuu -->`
Standard Issuu embed.

#### SoundCloud Embed `<!-- wp:html -->`
When embedding SoundCloud, please make sure you use the embed code provided by
SoundCloud and not the standard way of embedding in WordPress. This is necessary
because the embed code contains track ID which is used to fetch more information
about the track through SC API.