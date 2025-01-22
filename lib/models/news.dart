class News {
  final String id;
  final String title;
  final String content;
  final String category; // Anime atau E-sport
  final String imageUrl;
  final DateTime date;

  News({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.imageUrl,
    required this.date,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      category: json['category'],
      imageUrl: json['imageUrl'],
      date: DateTime.parse(json['date']),
    );
  }
}
