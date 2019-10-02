import 'package:flutter/cupertino.dart';
import 'package:flutter_wordpress_content/model/SimpleArticle.dart';

class IssuuWidget extends Widget {
  SimpleArticle _pdf;

  SimpleArticle get pdf => _pdf;

  set pdf(SimpleArticle value) {
    _pdf = value;
  }

  @override
  Element createElement() {
    return null;
  }
}
