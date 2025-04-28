import 'package:flutter/material.dart';
import '../models/news_article.dart';

class NewsTile extends StatelessWidget {
  final NewsArticle newsArticle;

  const NewsTile({Key? key, required this.newsArticle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(newsArticle.title),
      subtitle: Text(newsArticle.description),
      onTap: () {
        // Ouvrir l'URL de l'article
      },
    );
  }
}
