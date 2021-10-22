import 'dart:convert';

import 'package:flutter_wordpress_content/model/FeatureImage.dart';

class SimpleArticle {
  final int id;
  final String title;
  final String link;
  final String publishedDate;
  final String publishedSince;
  final String teaserText;
  final FeatureImage featureImage;
  final int parentCategoryId;
  final String parentCategory;
  final int categoryId;
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
    this.id = 0,
    this.title = "",
    this.link = "",
    this.publishedDate = "",
    this.publishedSince = "",
    this.teaserText = "",
    this.featureImage = const FeatureImage(),
    this.parentCategoryId = 0,
    this.parentCategory = "",
    this.categoryId = 0,
    this.category = "",
    this.issueTitle = "",
    this.issueTeaserText = "",
    this.issueNumber = "",
    this.volumeNumber = "",
    this.paragraphRawContent = "",
    this.issuePublishedDate = "",
    this.isPDFArticle = false,
    this.pdfURL = "",
    this.authors = const [],
  });

  factory SimpleArticle.newInstance(
      int id,
      String title,
      String link,
      String publishedDate,
      String publishedSince,
      String teaserText,
      FeatureImage featureImage,
      int parentCategoryId,
      String parentCategory,
      int categoryId,
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
        featureImage: featureImage,
        parentCategoryId: parentCategoryId,
        parentCategory: parentCategory,
        categoryId: categoryId,
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

  factory SimpleArticle.pdfArticle(String content, String? link) {
    return SimpleArticle(paragraphRawContent: content, link: link ?? "");
  }

  factory SimpleArticle.fromJson(Map<String, dynamic> json) {
    if (json == null) return new SimpleArticle();

    List<String> authors = [];
    try {
      authors = json["authors"].map((a) => a).toList().cast<String>();
    } catch (exception) {/* ignore */}

    FeatureImage featureImage = FeatureImage();
    try {
      featureImage = FeatureImage.fromJson(json["featureImage"]);
    } catch (exception) {/* ignore */}

    return SimpleArticle(
      id: json["id"],
      title: json["title"],
      link: json["link"],
      publishedDate: json["publishedDate"],
      publishedSince: json["publishedSince"],
      teaserText: json["teaserText"],
      featureImage: featureImage,
      parentCategoryId: json["parentCategoryId"],
      parentCategory: json["parentCategory"],
      categoryId: json["categoryId"],
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
    Map<String, dynamic> featureImageJson = Map<String, dynamic>();
    try {
      featureImageJson = featureImage.toJson();
    } catch (exception) {/* ignore */}

    return {
      'id': id,
      'title': title,
      'link': link,
      'publishedDate': publishedDate,
      'publishedSince': publishedSince,
      'teaserText': teaserText,
      'featureImage': featureImageJson,
      'parentCategoryId': parentCategoryId,
      'parentCategory': parentCategory,
      'categoryId': categoryId,
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
    if (articles == null) return [];
    return articles.map((a) => a.toJson()).toList();
  }

  static String toJsonStringFromList(List<SimpleArticle> articles) {
    return json.encode(toJsonFromList(articles));
  }

  String toJsonString() {
    return json.encode(toJson());
  }

  @override
  int get hashCode => id;

  @override
  bool operator ==(other) {
    return id == (other as SimpleArticle).id;
  }
}
