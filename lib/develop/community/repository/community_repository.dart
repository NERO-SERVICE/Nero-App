import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:nero_app/develop/community/models/comment.dart';
import 'package:nero_app/develop/community/models/post.dart';
import 'package:nero_app/develop/community/models/report_request.dart';
import 'package:nero_app/develop/dio_service.dart';

class CommunityRepository {
  final DioService _dioService = Get.find<DioService>();

  // 게시물 목록 가져오기 (페이징 및 검색 지원)
  Future<List<Post>> fetchPosts({int page = 1, String? searchQuery}) async {
    try {
      final response = await _dioService.get(
        '/community/posts/',
        params: {
          'page': page,
          if (searchQuery != null && searchQuery.isNotEmpty) 'search': searchQuery,
        },
      );

      print("응답 데이터: ${response.data}"); // 응답 구조 확인용 로그

      List<Post> posts = (response.data['results'] as List)
          .map((json) => Post.fromJson(json))
          .toList();
      return posts;
    } catch (e) {
      print('게시물 목록 가져오기 실패: $e');
      throw e;
    }
  }

  // 게시물 상세 정보 가져오기
  Future<Post> fetchPostDetail(int postId) async {
    try {
      final response = await _dioService.get('/community/posts/$postId/');
      return Post.fromJson(response.data);
    } catch (e) {
      print('게시물 상세 정보 가져오기 실패: $e');
      throw e;
    }
  }

  // 게시물 생성
  Future<Post> createPost({
    required String content,
    List<File>? images,
    String? type,
  }) async {
    try {
      dio.FormData formData = dio.FormData.fromMap({
        'content': content,
        if (images != null && images.isNotEmpty)
          'images': [
            for (var file in images)
              await dio.MultipartFile.fromFile(
                file.path,
                filename: file.path.split('/').last,
              ),
          ],
        if (type != null) 'type': type,
      });

      final response = await _dioService.postFormData(
        '/community/posts/create/',
        formData: formData,
      );

      if (response.statusCode == 201) {
        return Post.fromJson(response.data);
      } else {
        throw Exception('Failed to create post');
      }
    } catch (e) {
      print('게시물 생성 실패: $e');
      throw e;
    }
  }

  // 게시물 수정
  Future<Post> updatePost({
    required int postId,
    String? content,
    List<File>? images,
  }) async {
    try {
      dio.FormData formData = dio.FormData.fromMap({
        if (content != null) 'content': content,
        if (images != null && images.isNotEmpty)
          'images': [
            for (var file in images)
              await dio.MultipartFile.fromFile(
                file.path,
                filename: file.path.split('/').last,
              ),
          ],
      });

      final response = await _dioService.putFormData(
        '/community/posts/$postId/',
        formData: formData,
      );

      if (response.statusCode == 200) {
        return Post.fromJson(response.data);
      } else {
        throw Exception('Failed to update post');
      }
    } catch (e) {
      print('게시물 수정 실패: $e');
      throw e;
    }
  }

  // 게시물 삭제
  Future<void> deletePost(int postId) async {
    try {
      await _dioService.delete('/community/posts/$postId/');
    } catch (e) {
      print('게시물 삭제 실패: $e');
      throw e;
    }
  }

  // 댓글 목록 가져오기
  Future<List<Comment>> fetchComments(int postId, {int page = 1}) async {
    try {
      final response = await _dioService.get(
        '/community/posts/$postId/comments/',
        params: {
          'page': page,
        },
      );

      List<Comment> comments = (response.data['results'] as List)
          .map((json) => Comment.fromJson(json))
          .toList();
      return comments;
    } catch (e) {
      print('댓글 목록 가져오기 실패: $e');
      throw e;
    }
  }

  // 댓글 작성
  Future<Comment> createComment({
    required int postId,
    required String content,
  }) async {
    try {
      final response = await _dioService.post(
        '/community/posts/$postId/comments/create/',
        data: {
          'content': content,
        },
      );

      return Comment.fromJson(response.data);
    } catch (e) {
      print('댓글 작성 실패: $e');
      throw e;
    }
  }

  // 댓글 수정
  Future<Comment> updateComment({
    required int commentId,
    String? content,
  }) async {
    try {
      final response = await _dioService.patch(
        '/community/comments/$commentId/',
        data: {
          if (content != null) 'content': content,
        },
      );

      return Comment.fromJson(response.data);
    } catch (e) {
      print('댓글 수정 실패: $e');
      throw e;
    }
  }

  // 댓글 삭제
  Future<void> deleteComment(int commentId) async {
    try {
      await _dioService.delete('/community/comments/$commentId/');
    } catch (e) {
      print('댓글 삭제 실패: $e');
      throw e;
    }
  }

  // 게시물 좋아요 토글
  Future<void> toggleLikePost(int postId) async {
    try {
      await _dioService.post('/community/posts/$postId/like/');
    } catch (e) {
      print('게시물 좋아요 토글 실패: $e');
      throw e;
    }
  }

  // 댓글 좋아요 토글
  Future<void> toggleLikeComment(int commentId) async {
    try {
      await _dioService.post('/community/comments/$commentId/like/');
    } catch (e) {
      print('댓글 좋아요 토글 실패: $e');
      throw e;
    }
  }

  // 게시물 신고
  Future<void> reportPost(ReportRequest report) async {
    try {
      await _dioService.post(
        '/community/reports/create/',
        data: report.toJson(),
      );
    } catch (e) {
      print('게시물 신고 실패: $e');
      throw e;
    }
  }

  // 댓글 신고
  Future<void> reportComment(ReportRequest report) async {
    try {
      await _dioService.post(
        '/community/comments/reports/create/',
        data: report.toJson(),
      );
    } catch (e) {
      print('댓글 신고 실패: $e');
      throw e;
    }
  }

  // 좋아요 한 게시물 목록
  Future<List<Post>> fetchLikedPosts({int page = 1}) async {
    try {
      final response = await _dioService.get(
        '/community/posts/liked/',
        params: {
          'page': page,
        },
      );

      List<Post> posts = (response.data['results'] as List)
          .map((json) => Post.fromJson(json))
          .toList();
      return posts;
    } catch (e) {
      print('좋아요한 게시물 가져오기 실패: $e');
      throw e;
    }
  }

  // 내가 작성한 게시물
  Future<List<Post>> fetchMyPosts({int page = 1}) async {
    try {
      final response = await _dioService.get(
        '/community/posts/mine/',
        params: {
          'page': page,
        },
      );

      List<Post> posts = (response.data['results'] as List)
          .map((json) => Post.fromJson(json))
          .toList();
      return posts;
    } catch (e) {
      print('내가 작성한 게시물 가져오기 실패: $e');
      throw e;
    }
  }

  // 인기 게시물 목록
  Future<List<Post>> fetchPopularPosts({int page = 1}) async {
    try {
      final response = await _dioService.get(
        '/community/posts/popular/',
        params: {
          'page': page,
        },
      );

      List<Post> posts = (response.data['results'] as List)
          .map((json) => Post.fromJson(json))
          .toList();
      return posts;
    } catch (e) {
      print('인기 게시물 가져오기 실패: $e');
      throw e;
    }
  }

  Future<List<Post>> fetchRecentPosts() async {
    try {
      final response = await _dioService.get('/community/posts/recent/');
      List<Post> posts = (response.data as List)
          .map((json) => Post.fromJson(json))
          .toList();
      return posts;
    } catch (e) {
      print('최근 게시물 가져오기 실패: $e');
      throw e;
    }
  }
}
