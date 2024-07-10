import 'dart:convert';

List<ArtikelModel> artikelModelFromJson(String str) => List<ArtikelModel>.from(json.decode(str).map((x) => ArtikelModel.fromJson(x)));

String artikelModelToJson(List<ArtikelModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ArtikelModel {
  String author;
  String title;
  String description;
  String url;
  String urlToImage;
  String review;

  ArtikelModel({
    required this.author,
    required this.title,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.review,
  });

  factory ArtikelModel.fromJson(Map<String, dynamic> json) => ArtikelModel(
    author: json["author"],
    title: json["title"],
    description: json["description"],
    url: json["url"],
    urlToImage: json["urlToImage"],
    review: json["review"],
  );

  Map<String, dynamic> toJson() => {
    "author": author,
    "title": title,
    "description": description,
    "url": url,
    "urlToImage": urlToImage,
    "review": review,
  };
}
