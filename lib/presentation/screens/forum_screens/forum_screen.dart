import 'package:flutter/material.dart';
import '../../../data/models/forum_post.dart';
import '../../../data/datasources/forum_api_service.dart';

String? formatForumImageUrl(String? originalUrl) {
  if (originalUrl == null) return null;
  final idx = originalUrl.indexOf('/prueba');
  if (idx == -1) return originalUrl;
  final path = originalUrl.substring(idx + '/prueba'.length); // omite '/prueba'
  return 'https://pub-5d5ebeeeb5f14f0ca828d1fc5e53e0a2.r2.dev$path';
}

class ForumScreen extends StatelessWidget {
  const ForumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: const Text('Foro', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Blogs para el bien estudiantil',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'En este apartado podrás encontrar entradas interesantes',
              style: TextStyle(fontSize: 15, color: Colors.black54),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: FutureBuilder<List<ForumPost>>(
              future: ForumApiService.fetchPosts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No hay posts disponibles.'));
                }
                final posts = snapshot.data!;
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    return BlogCard(
                      post: post,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ForumPostDetailScreen(post: post),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class BlogCard extends StatelessWidget {
  final ForumPost post;
  final VoidCallback onTap;
  const BlogCard({required this.post, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (post.imageUrl != null)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  formatForumImageUrl(post.imageUrl!)!,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    children: post.tags.map((tag) => Chip(
                      label: Text(tag),
                      backgroundColor: Colors.blue.withOpacity(0.1),
                      labelStyle: const TextStyle(color: Colors.blue),
                      padding: EdgeInsets.zero,
                    )).toList(),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    post.title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    post.body,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 14, color: Colors.grey[500]),
                      const SizedBox(width: 4),
                      Text(
                        '${post.createdAt.day}/${post.createdAt.month}/${post.createdAt.year}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                      const SizedBox(width: 16),
                      Icon(Icons.person, size: 14, color: Colors.grey[500]),
                      const SizedBox(width: 4),
                      Text(post.authorName, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ForumPostDetailScreen extends StatelessWidget {
  final ForumPost post;
  const ForumPostDetailScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del Post'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (post.imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  formatForumImageUrl(post.imageUrl!)!,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            if (post.imageUrl != null) const SizedBox(height: 16),
            Text(
              post.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: post.tags.map((tag) => Chip(
                label: Text(tag),
                backgroundColor: Colors.blue.withOpacity(0.1),
                labelStyle: const TextStyle(color: Colors.blue),
              )).toList(),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey[500]),
                const SizedBox(width: 4),
                Text(
                  '${post.createdAt.day}/${post.createdAt.month}/${post.createdAt.year}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
                const SizedBox(width: 16),
                Icon(Icons.person, size: 16, color: Colors.grey[500]),
                const SizedBox(width: 4),
                Text(post.authorName, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              post.body,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
