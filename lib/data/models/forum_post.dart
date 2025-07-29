class ForumPost {
  final String id;
  final String title;
  final String body;
  final String authorName;
  final String? authorAvatar;
  final List<String> tags;
  final String? imageUrl;
  final DateTime createdAt;

  ForumPost({
    required this.id,
    required this.title,
    required this.body,
    required this.authorName,
    this.authorAvatar,
    required this.tags,
    this.imageUrl,
    required this.createdAt,
  });

  factory ForumPost.fromJson(Map<String, dynamic> json) {
    return ForumPost(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      authorName: (json['authors'] as List).isNotEmpty
          ? json['authors'][0]['name']
          : 'Desconocido',
      authorAvatar: (json['authors'] as List).isNotEmpty
          ? json['authors'][0]['avatar']
          : null,
      tags: (json['tags'] as List)
          .map((tag) => tag['value'] as String)
          .toList(),
      imageUrl: (json['images'] as List).isNotEmpty
          ? json['images'][0]['url']
          : null,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
