class NewsArticle {
  final String title;
  final String description;
  final String url;

  NewsArticle({required this.title, required this.description, required this.url});

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'],
      description: json['description'],
      url: json['url'],
    );
  }
}
