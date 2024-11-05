// lib/develop/home/community/controllers/community_controller.dart

import 'dart:io';

import 'package:get/get.dart';
import 'package:nero_app/develop/common/components/custom_snackbar.dart';
import 'package:nero_app/develop/home/community/models/post.dart';
import 'package:nero_app/develop/home/community/models/comment.dart';
import 'package:nero_app/develop/home/community/repository/community_repository.dart';

class CommunityController extends GetxController {
  final CommunityRepository _communityRepository = Get.put(CommunityRepository());
  final RxList<File> selectedImages = <File>[].obs;
  final RxBool isPossibleSubmit = false.obs;

  // 게시물 내용 관리
  RxString content = ''.obs;

  // 게시물 목록
  var posts = <Post>[].obs;
  var isLoadingPosts = false.obs;
  var currentPostPage = 1.obs;
  var hasMorePosts = true.obs;
  var searchQuery = ''.obs;

  // 게시물 상세
  var currentPost = Post.empty().obs;
  var isLoadingPostDetail = false.obs;

  // 댓글 목록
  var comments = <Comment>[].obs;
  var isLoadingComments = false.obs;
  var currentCommentPage = 1.obs;
  var hasMoreComments = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPosts();
    // 게시물 내용이나 이미지가 변경될 때마다 제출 가능 여부를 검증
    everAll([content, selectedImages], (_) => _isValidSubmitPossible());
  }

  // 게시물 목록 가져오기
  Future<void> fetchPosts({bool refresh = false}) async {
    if (isLoadingPosts.value) return;

    if (refresh) {
      currentPostPage.value = 1;
      hasMorePosts.value = true;
      posts.clear();
    }

    if (!hasMorePosts.value) return;

    isLoadingPosts.value = true;

    try {
      final fetchedPosts = await _communityRepository.fetchPosts(
        page: currentPostPage.value,
        searchQuery: searchQuery.value.isNotEmpty ? searchQuery.value : null,
      );

      if (fetchedPosts.length < 10) {
        hasMorePosts.value = false;
      }

      posts.addAll(fetchedPosts);
      currentPostPage.value += 1;
    } catch (e) {
      print('게시물 가져오기 실패: $e');
      CustomSnackbar.show(
        context: Get.context!,
        message: '게시물 가져오기에 실패했습니다.',
        isSuccess: false,
      );
    } finally {
      isLoadingPosts.value = false;
    }
  }

  // 게시물 상세 가져오기
  Future<void> fetchPostDetail(int postId) async {
    isLoadingPostDetail.value = true;

    try {
      final post = await _communityRepository.fetchPostDetail(postId);
      currentPost.value = post;
      fetchComments(postId);
    } catch (e) {
      print('게시물 상세 가져오기 실패: $e');
      CustomSnackbar.show(
        context: Get.context!,
        message: '게시물 상세 정보를 가져오지 못했습니다.',
        isSuccess: false,
      );
    } finally {
      isLoadingPostDetail.value = false;
    }
  }

  // 게시물 작성
  Future<void> createPost({
    required String content,
    List<File>? images,
  }) async {
    try {
      await _communityRepository.createPost(
        content: content,
        images: images,
      );
      // 게시물 작성 후 이미지 목록 초기화
      selectedImages.clear();
      this.content.value = '';
      CustomSnackbar.show(
        context: Get.context!,
        message: '게시물이 생성되었습니다.',
        isSuccess: true,
      );
    } catch (e) {
      print('게시물 작성 실패: $e');
      CustomSnackbar.show(
        context: Get.context!,
        message: '게시물 작성에 실패했습니다.',
        isSuccess: false,
      );
    }
  }

  // 게시물 수정
  Future<void> updatePost({
    required int postId,
    String? content,
    List<File>? images,
  }) async {
    try {
      final updatedPost = await _communityRepository.updatePost(
        postId: postId,
        content: content,
        images: images,
      );
      int index = posts.indexWhere((post) => post.postId == postId);
      if (index != -1) {
        posts[index] = updatedPost;
      }
      currentPost.value = updatedPost;
      CustomSnackbar.show(
        context: Get.context!,
        message: '게시물이 수정되었습니다.',
        isSuccess: true,
      );
    } catch (e) {
      print('게시물 수정 실패: $e');
      CustomSnackbar.show(
        context: Get.context!,
        message: '게시물 수정에 실패했습니다.',
        isSuccess: false,
      );
    }
  }

  // 게시물 삭제
  Future<void> deletePost(int postId) async {
    try {
      await _communityRepository.deletePost(postId);
      posts.removeWhere((post) => post.postId == postId);
      CustomSnackbar.show(
        context: Get.context!,
        message: '게시물이 삭제되었습니다.',
        isSuccess: true,
      );
    } catch (e) {
      print('게시물 삭제 실패: $e');
      CustomSnackbar.show(
        context: Get.context!,
        message: '게시물 삭제에 실패했습니다.',
        isSuccess: false,
      );
    }
  }

  // 댓글 가져오기
  Future<void> fetchComments(int postId, {bool refresh = false}) async {
    if (isLoadingComments.value) return;

    if (refresh) {
      currentCommentPage.value = 1;
      hasMoreComments.value = true;
      comments.clear();
    }

    if (!hasMoreComments.value) return;

    isLoadingComments.value = true;

    try {
      final fetchedComments = await _communityRepository.fetchComments(
        postId,
        page: currentCommentPage.value,
      );

      if (fetchedComments.length < 10) {
        hasMoreComments.value = false;
      }

      comments.addAll(fetchedComments);
      currentCommentPage.value += 1;
    } catch (e) {
      print('댓글 가져오기 실패: $e');
      CustomSnackbar.show(
        context: Get.context!,
        message: '댓글 가져오기에 실패했습니다.',
        isSuccess: false,
      );
    } finally {
      isLoadingComments.value = false;
    }
  }

  // 댓글 작성
  Future<void> createComment({
    required int postId,
    required String content,
  }) async {
    try {
      final newComment = await _communityRepository.createComment(
        postId: postId,
        content: content,
      );
      comments.insert(0, newComment);
      // currentPost.update 수정
      currentPost.value = currentPost.value.copyWith(
        commentCount: currentPost.value.commentCount + 1,
      );
      CustomSnackbar.show(
        context: Get.context!,
        message: '댓글이 작성되었습니다.',
        isSuccess: true,
      );
    } catch (e) {
      print('댓글 작성 실패: $e');
      CustomSnackbar.show(
        context: Get.context!,
        message: '댓글 작성에 실패했습니다.',
        isSuccess: false,
      );
    }
  }

  // 댓글 수정
  Future<void> updateComment({
    required int commentId,
    String? content,
  }) async {
    try {
      final updatedComment = await _communityRepository.updateComment(
        commentId: commentId,
        content: content,
      );
      int index = comments.indexWhere((c) => c.commentId == commentId);
      if (index != -1) {
        comments[index] = updatedComment;
      }
      CustomSnackbar.show(
        context: Get.context!,
        message: '댓글이 수정되었습니다.',
        isSuccess: true,
      );
    } catch (e) {
      print('댓글 수정 실패: $e');
      CustomSnackbar.show(
        context: Get.context!,
        message: '댓글 수정에 실패했습니다.',
        isSuccess: false,
      );
    }
  }

  // 댓글 삭제
  Future<void> deleteComment(int commentId) async {
    try {
      await _communityRepository.deleteComment(commentId);
      comments.removeWhere((c) => c.commentId == commentId);
      // currentPost.update 수정
      currentPost.value = currentPost.value.copyWith(
        commentCount: currentPost.value.commentCount > 0
            ? currentPost.value.commentCount - 1
            : 0,
      );
      CustomSnackbar.show(
        context: Get.context!,
        message: '댓글이 삭제되었습니다.',
        isSuccess: true,
      );
    } catch (e) {
      print('댓글 삭제 실패: $e');
      CustomSnackbar.show(
        context: Get.context!,
        message: '댓글 삭제에 실패했습니다.',
        isSuccess: false,
      );
    }
  }

  // 게시물 좋아요 토글
  Future<void> toggleLikePost(int postId) async {
    try {
      await _communityRepository.toggleLikePost(postId);
      int index = posts.indexWhere((post) => post.postId == postId);
      if (index != -1) {
        Post post = posts[index];
        posts[index] = post.copyWith(
          likeCount: post.likeCount + (post.isLiked ? -1 : 1),
          isLiked: !post.isLiked,
        );
      }
      if (currentPost.value.postId == postId) {
        currentPost.value = currentPost.value.copyWith(
          likeCount: currentPost.value.likeCount + (currentPost.value.isLiked ? -1 : 1),
          isLiked: !currentPost.value.isLiked,
        );
      }
      CustomSnackbar.show(
        context: Get.context!,
        message: '좋아요가 토글되었습니다.',
        isSuccess: true,
      );
    } catch (e) {
      print('게시물 좋아요 토글 실패: $e');
      CustomSnackbar.show(
        context: Get.context!,
        message: '좋아요 토글에 실패했습니다.',
        isSuccess: false,
      );
    }
  }

  // 댓글 좋아요 토글
  Future<void> toggleLikeComment(int commentId) async {
    try {
      await _communityRepository.toggleLikeComment(commentId);
      int index = comments.indexWhere((c) => c.commentId == commentId);
      if (index != -1) {
        Comment comment = comments[index];
        comments[index] = comment.copyWith(
          likeCount: comment.likeCount + (comment.isLiked ? -1 : 1),
          isLiked: !comment.isLiked,
        );
      }
      CustomSnackbar.show(
        context: Get.context!,
        message: '좋아요가 토글되었습니다.',
        isSuccess: true,
      );
    } catch (e) {
      print('댓글 좋아요 토글 실패: $e');
      CustomSnackbar.show(
        context: Get.context!,
        message: '좋아요 토글에 실패했습니다.',
        isSuccess: false,
      );
    }
  }

  // 검색 쿼리 설정
  void setSearchQuery(String query) {
    searchQuery.value = query;
    fetchPosts(refresh: true);
  }

  // 게시물 내용 업데이트
  void updateContent(String value) {
    content.value = value;
  }

  // 이미지 추가
  void addImages(List<File> images) {
    selectedImages.addAll(images);
  }

  // 이미지 제거
  void removeImage(File image) {
    selectedImages.remove(image);
  }

  // 게시 가능 여부 검증
  void _isValidSubmitPossible() {
    if (content.value.isNotEmpty && selectedImages.isNotEmpty) {
      isPossibleSubmit.value = true;
    } else {
      isPossibleSubmit.value = false;
    }
  }
}
