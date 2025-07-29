import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/forum_post.dart';

class ForumApiService {
  static Future<List<ForumPost>> fetchPosts() async {
    final response = await http.get(
      Uri.parse('https://api.psicodemy.com/s4/api/posts'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final posts = data['data']['posts'] as List;
      return posts.map((json) => ForumPost.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar los posts');
    }
  }
}
