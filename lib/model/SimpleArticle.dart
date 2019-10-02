import 'dart:convert';

class SimpleArticle {
  final int id;
  final String title;
  final String link;
  final String publishedDate;
  final String publishedSince;
  final String teaserText;
  final String imageURL;
  final String parentCategory;
  final String category;
  final String issueTitle;
  final String issueTeaserText;
  final String issueNumber;
  final String volumeNumber;
  final String paragraphRawContent;
  final String issuePublishedDate;
  final bool isPDFArticle;
  final String pdfURL;
  final List<String> authors;

  const SimpleArticle({
    this.id,
    this.title,
    this.link,
    this.publishedDate,
    this.publishedSince,
    this.teaserText,
    this.imageURL,
    this.parentCategory,
    this.category,
    this.issueTitle,
    this.issueTeaserText,
    this.issueNumber,
    this.volumeNumber,
    this.paragraphRawContent,
    this.issuePublishedDate,
    this.isPDFArticle,
    this.pdfURL,
    this.authors,
  });

  factory SimpleArticle.newInstance(
      int id,
      String title,
      String link,
      String publishedDate,
      String publishedSince,
      String teaserText,
      String imageURL,
      String parentCategory,
      String category,
      String issueTitle,
      String issueTeaserText,
      String issueNumber,
      String volumeNumber,
      String paragraphRawContent,
      String issuePublishedDate,
      bool isPDFArticle,
      String pdfURL,
      List<String> authors) {
    return SimpleArticle(
        id: id,
        title: title,
        link: link,
        publishedDate: publishedDate,
        publishedSince: publishedSince,
        teaserText: teaserText,
        imageURL: imageURL,
        parentCategory: parentCategory,
        category: category,
        issueTitle: issueTitle,
        issueTeaserText: issueTeaserText,
        issueNumber: issueNumber,
        volumeNumber: volumeNumber,
        paragraphRawContent: paragraphRawContent,
        issuePublishedDate: issuePublishedDate,
        isPDFArticle: isPDFArticle,
        pdfURL: pdfURL,
        authors: authors);
  }

  factory SimpleArticle.pdfArticle(String content, String link) {
    return SimpleArticle(paragraphRawContent: content, link: link);
  }

  factory SimpleArticle.fromJson(Map<String, dynamic> json) {
    if (json == null) return new SimpleArticle();

    List<String> authors = List<String>();
    try {
      authors = json["authors"].map((a) => a).toList().cast<String>();
    } catch (exception) {/* ignore */}

    return SimpleArticle(
      id: json["id"],
      title: json["title"],
      link: json["link"],
      publishedDate: json["publishedDate"],
      publishedSince: json["publishedSince"],
      teaserText: json["teaserText"],
      imageURL: json["imageURL"],
      category: json["category"],
      issueTitle: json["issueTitle"],
      issueTeaserText: json["issueTeaserText"],
      issueNumber: json["issueNumber"],
      volumeNumber: json["volumeNumber"],
      paragraphRawContent: json["paragraphRawContent"],
      issuePublishedDate: json["issuePublishedDate"],
      isPDFArticle: json["isPDFArticle"],
      pdfURL: json["pdfURL"],
      authors: authors,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'link': link,
      'publishedDate': publishedDate,
      'publishedSince': publishedSince,
      'teaserText': teaserText,
      'imageURL': imageURL,
      'parentCategory': parentCategory,
      'category': category,
      'issueTitle': issueTitle,
      'issueTeaserText': issueTeaserText,
      'issueNumber': issueNumber,
      'volumeNumber': volumeNumber,
      'paragraphRawContent': paragraphRawContent,
      'issuePublishedDate': issuePublishedDate,
      'isPDFArticle': isPDFArticle,
      'pdfURL': pdfURL,
      'authors': authors,
    };
  }

  static List<dynamic> toJsonFromList(List<SimpleArticle> articles) {
    if (articles == null) return List<dynamic>();
    return articles.map((a) => a.toJson()).toList();
  }

  static String toJsonStringFromList(List<SimpleArticle> articles) {
    return json.encode(toJsonFromList(articles));
  }

  String toJsonString() {
    return json.encode(toJson());
  }
}
