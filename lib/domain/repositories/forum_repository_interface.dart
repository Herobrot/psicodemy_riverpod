import '../entities/forum_entity.dart';

abstract class ForumRepository {
  // Post operations
  Future<List<ForumPostEntity>> getPosts({
    ForumCategory? category,
    int limit = 20,
    String? lastPostId,
  });
  Future<ForumPostEntity?> getPostById(String postId);
  Future<ForumPostEntity> createPost(ForumPostEntity post);
  Future<ForumPostEntity> updatePost(ForumPostEntity post);
  Future<void> deletePost(String postId);
  
  // Comment operations
  Future<List<ForumCommentEntity>> getComments(String postId);
  Future<ForumCommentEntity> createComment(ForumCommentEntity comment);
  Future<ForumCommentEntity> updateComment(ForumCommentEntity comment);
  Future<void> deleteComment(String commentId);
  
  // Interaction operations
  Future<void> likePost(String postId);
  Future<void> unlikePost(String postId);
  Future<void> likeComment(String commentId);
  Future<void> unlikeComment(String commentId);
  
  // View tracking
  Future<void> incrementPostViews(String postId);
  
  // Search and filter
  Future<List<ForumPostEntity>> searchPosts(String query);
  Future<List<ForumPostEntity>> getPostsByCategory(ForumCategory category);
  Future<List<ForumPostEntity>> getPostsByUser(String userId);
  Future<List<ForumPostEntity>> getTrendingPosts();
  Future<List<ForumPostEntity>> getFeaturedPosts();
  
  // Real-time updates
  Stream<List<ForumPostEntity>> watchPosts({ForumCategory? category});
  Stream<List<ForumCommentEntity>> watchComments(String postId);
  
  // Moderation
  Future<void> reportPost(String postId, String reason);
  Future<void> reportComment(String commentId, String reason);
} 