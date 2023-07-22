class Article {
  final int userID;
  final int articleID;
  final String title;
  final String body;

  Article({
    required this.userID,
    required this.articleID,
    required this.title,
    required this.body
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      userID: json['userId'] ?? 0,
      articleID: json['id'] ?? 0,
      title: json['title'] ?? '',
      body: json['body'] ?? '',
    );
  }
}