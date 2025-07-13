import 'package:flutter/material.dart';

class ForumScreen extends StatefulWidget {
  const ForumScreen({super.key});

  @override
  State<ForumScreen> createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  final List<ForumPostItem> _posts = [
    ForumPostItem(
      id: '1',
      title: '¿Cómo manejar la ansiedad en el trabajo?',
      content: 'Últimamente he estado sintiendo mucha ansiedad cuando llego al trabajo. ¿Alguien tiene consejos?',
      authorName: 'Ana M.',
      authorAvatar: 'https://i.pravatar.cc/150?u=ana',
      category: ForumCategoryType.support,
      likesCount: 15,
      commentsCount: 8,
      timeAgo: '2h',
      isLiked: false,
      isPinned: false,
    ),
    ForumPostItem(
      id: '2',
      title: 'Mi experiencia con terapia cognitivo-conductual',
      content: 'Quería compartir mi experiencia positiva con la TCC. Ha sido muy útil para mi proceso de sanación.',
      authorName: 'Carlos R.',
      authorAvatar: 'https://i.pravatar.cc/150?u=carlos',
      category: ForumCategoryType.experiences,
      likesCount: 32,
      commentsCount: 15,
      timeAgo: '5h',
      isLiked: true,
      isPinned: true,
    ),
    ForumPostItem(
      id: '3',
      title: 'Recursos para mindfulness y meditación',
      content: 'He recopilado algunos recursos útiles para quienes quieren comenzar con mindfulness.',
      authorName: 'Dr. Laura P.',
      authorAvatar: 'https://i.pravatar.cc/150?u=laura',
      category: ForumCategoryType.resources,
      likesCount: 47,
      commentsCount: 22,
      timeAgo: '1d',
      isLiked: false,
      isPinned: false,
    ),
  ];

  ForumCategoryType _selectedCategory = ForumCategoryType.all;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: const Text(
          'Foro',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black87),
            onPressed: () {
              // TODO: Implementar búsqueda
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.black87),
            onPressed: () {
              _showFilterOptions();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Categorías
          _buildCategoryFilter(),
          
          // Lista de posts
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                // TODO: Implementar refresh
              },
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _posts.length,
                itemBuilder: (context, index) {
                  final post = _posts[index];
                  return _buildPostItem(post);
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Implementar crear post
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreatePostScreen(),
            ),
          );
        },
        backgroundColor: const Color(0xFF4CAF50),
        icon: const Icon(Icons.edit, color: Colors.white),
        label: const Text(
          'Nuevo Post',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildCategoryChip('Todos', ForumCategoryType.all),
          const SizedBox(width: 8),
          _buildCategoryChip('Apoyo', ForumCategoryType.support),
          const SizedBox(width: 8),
          _buildCategoryChip('Experiencias', ForumCategoryType.experiences),
          const SizedBox(width: 8),
          _buildCategoryChip('Preguntas', ForumCategoryType.questions),
          const SizedBox(width: 8),
          _buildCategoryChip('Recursos', ForumCategoryType.resources),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, ForumCategoryType category) {
    final isSelected = _selectedCategory == category;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedCategory = category;
        });
      },
      selectedColor: const Color(0xFF4CAF50).withOpacity(0.2),
      checkmarkColor: const Color(0xFF4CAF50),
      labelStyle: TextStyle(
        color: isSelected ? const Color(0xFF4CAF50) : Colors.grey[600],
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }

  Widget _buildPostItem(ForumPostItem post) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PostDetailScreen(post: post),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con autor y categoría
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(post.authorAvatar),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.authorName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          post.timeAgo,
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildCategoryBadge(post.category),
                  if (post.isPinned) ...[
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.push_pin,
                      size: 16,
                      color: Color(0xFF4CAF50),
                    ),
                  ],
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Título del post
              Text(
                post.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
              
              const SizedBox(height: 8),
              
              // Contenido del post
              Text(
                post.content,
                style: TextStyle(
                  color: Colors.grey[700],
                  height: 1.4,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              
              const SizedBox(height: 16),
              
              // Acciones (likes, comentarios, etc.)
              Row(
                children: [
                  _buildActionButton(
                    icon: post.isLiked ? Icons.favorite : Icons.favorite_border,
                    label: post.likesCount.toString(),
                    color: post.isLiked ? Colors.red : Colors.grey[600]!,
                    onTap: () {
                      // TODO: Implementar like
                      setState(() {
                        post.isLiked = !post.isLiked;
                        if (post.isLiked) {
                          post.likesCount++;
                        } else {
                          post.likesCount--;
                        }
                      });
                    },
                  ),
                  const SizedBox(width: 16),
                  _buildActionButton(
                    icon: Icons.comment_outlined,
                    label: post.commentsCount.toString(),
                    color: Colors.grey[600]!,
                    onTap: () {
                      // Navegar a post detail
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PostDetailScreen(post: post),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 16),
                  _buildActionButton(
                    icon: Icons.share_outlined,
                    label: 'Compartir',
                    color: Colors.grey[600]!,
                    onTap: () {
                      // TODO: Implementar compartir
                    },
                  ),
                  const Spacer(),
                  PopupMenuButton(
                    icon: Icon(Icons.more_vert, color: Colors.grey[600]),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'save',
                        child: Text('Guardar'),
                      ),
                      const PopupMenuItem(
                        value: 'report',
                        child: Text('Reportar'),
                      ),
                    ],
                    onSelected: (value) {
                      // TODO: Implementar acciones
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryBadge(ForumCategoryType category) {
    final colors = {
      ForumCategoryType.support: Colors.blue,
      ForumCategoryType.experiences: Colors.green,
      ForumCategoryType.questions: Colors.orange,
      ForumCategoryType.resources: Colors.purple,
    };
    
    final labels = {
      ForumCategoryType.support: 'Apoyo',
      ForumCategoryType.experiences: 'Experiencia',
      ForumCategoryType.questions: 'Pregunta',
      ForumCategoryType.resources: 'Recurso',
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: (colors[category] ?? Colors.grey).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        labels[category] ?? '',
        style: TextStyle(
          color: colors[category] ?? Colors.grey,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Filtrar por',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.trending_up),
              title: const Text('Más populares'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implementar filtro
              },
            ),
            ListTile(
              leading: const Icon(Icons.schedule),
              title: const Text('Más recientes'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implementar filtro
              },
            ),
            ListTile(
              leading: const Icon(Icons.comment),
              title: const Text('Más comentados'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implementar filtro
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Pantalla para crear nuevo post
class CreatePostScreen extends StatelessWidget {
  const CreatePostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuevo Post'),
        actions: [
          TextButton(
            onPressed: () {
              // TODO: Implementar publicar
              Navigator.pop(context);
            },
            child: const Text(
              'Publicar',
              style: TextStyle(
                color: Color(0xFF4CAF50),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Título del post...',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: TextField(
                maxLines: null,
                expands: true,
                decoration: InputDecoration(
                  hintText: 'Escribe tu post aquí...',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Pantalla de detalle del post
class PostDetailScreen extends StatelessWidget {
  final ForumPostItem post;

  const PostDetailScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              post.content,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 32),
            const Text(
              'Comentarios (Por implementar)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Modelos para los datos mock
class ForumPostItem {
  final String id;
  final String title;
  final String content;
  final String authorName;
  final String authorAvatar;
  final ForumCategoryType category;
  int likesCount;
  final int commentsCount;
  final String timeAgo;
  bool isLiked;
  final bool isPinned;

  ForumPostItem({
    required this.id,
    required this.title,
    required this.content,
    required this.authorName,
    required this.authorAvatar,
    required this.category,
    required this.likesCount,
    required this.commentsCount,
    required this.timeAgo,
    required this.isLiked,
    required this.isPinned,
  });
}

enum ForumCategoryType {
  all,
  support,
  experiences,
  questions,
  resources,
}
