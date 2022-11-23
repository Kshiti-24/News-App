import 'dart:convert';
const List<Map<String, String>> listOfCountry = [
  {'name': 'INDIA', 'code': 'in'},
  {'name': 'USA', 'code': 'us'},
  {'name': 'MEXICO', 'code': 'mx'},
  {'name': 'United Arab Emirates', 'code': 'ae'},
  {'name': 'New Zealand', 'code': 'nz'},
  {'name': 'Israel', 'code': 'il'},
  {'name': 'Indonesia', 'code': 'id'},
];

const List<Map<String, String?>> listOfCategory = [
  {'name': 'science', 'code': 'science'},
  {'name': 'business', 'code': 'business'},
  {'name': 'technology', 'code': 'technology'},
  {'name': 'sports', 'code': 'sports'},
  {'name': 'health', 'code': 'health'},
  {'name': 'general', 'code': 'general'},
  {'name': 'entertainment', 'code': 'entertainment'},
  {'name': 'ALL', 'code': null},
];
const List<Map<String, String>> listOfNewsChannel = [
  {'name': 'BBC News', 'code': 'bbc-news'},
  {'name': 'The Times of India', 'code': 'the-times-of-india'},
  {'code': 'politico', 'name': 'politico'},
  {'code': 'the-washington-post', 'name': 'The Washington Post'},
  {'code': 'reuters', 'name': 'reuters'},
  {'code': 'cnn', 'name': 'cnn'},
  {'code': 'nbc-news', 'name': 'nbc news'},
  {'code': 'the-hill', 'name': 'The Hill'},
  {'code': 'fox-news', 'name': 'Fox News'},
  {'code': 'fox-news', 'name': 'Fox News'},
];
// To parse this JSON data, do
//
//     final newsModel = newsModelFromJson(jsonString);


NewsModel newsModelFromJson(String str) => NewsModel.fromJson(json.decode(str));

String newsModelToJson(NewsModel data) => json.encode(data.toJson());

class NewsModel {
  NewsModel({
    required this.status,
    required this.totalResults,
    required this.articles,
  });

  String status;
  int totalResults;
  List<Article> articles;

  factory NewsModel.fromJson(Map<String, dynamic> json) => NewsModel(
    status: json["status"],
    totalResults: json["totalResults"],
    articles: List<Article>.from(
        json["articles"].map((x) => Article.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "totalResults": totalResults,
    "articles": List<dynamic>.from(articles.map((x) => x.toJson())),
  };
}

class Article {
  Article({
    required this.source,
    required this.title,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
    required this.content,
  });

  Source? source;
  String title;
  String? description;
  String url;
  String? urlToImage;
  DateTime publishedAt;
  String? content;

  factory Article.fromJson(Map<String, dynamic> json) => Article(
    source: Source.fromJson(json["source"]),
    title: json["title"],
    description: json["description"],
    url: json["url"],
    urlToImage: json["urlToImage"],
    publishedAt: DateTime.parse(json["publishedAt"]),
    content: json["content"],
  );

  Map<String, dynamic> toJson() => {
    "source": source!.toJson(),
    "title": title,
    "description": description,
    "url": url,
    "urlToImage": urlToImage,
    "publishedAt": publishedAt.toIso8601String(),
    "content": content,
  };
}

class Source {
  Source({
    required this.id,
    required this.name,
  });

  String? id;
  String? name;

  factory Source.fromJson(Map<String, dynamic> json) => Source(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
