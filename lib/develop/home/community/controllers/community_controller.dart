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

  // 게시물 정보 및 댓글 목록 관리
  Rx<Post> currentPost = Post.empty().obs;
  RxList<Comment> comments = <Comment>[].obs;

  // 로딩 상태
  var isLoadingPostDetail = false.obs;
  var isLoadingComments = false.obs;


  // 댓글 목록
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
      update();  // UI 업데이트
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

  // 게시물 상세 정보 가져오기
  Future<void> fetchPostDetail(int postId) async {
    isLoadingPostDetail.value = true;
    try {
      final post = await _communityRepository.fetchPostDetail(postId);
      currentPost.value = post;
      fetchComments(postId); // 댓글도 동시에 가져오기
    } catch (e) {
      print('게시물 상세 가져오기 실패: $e');
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
      final newPost = await _communityRepository.createPost(
        content: content,
        images: images,
      );
      fetchPosts(refresh: true);
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
      update();  // UI 업데이트
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
      update();  // UI 업데이트
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

  // 댓글 목록 가져오기
  Future<void> fetchComments(int postId) async {
    isLoadingComments.value = true;
    try {
      final fetchedComments = await _communityRepository.fetchComments(postId);
      comments.assignAll(fetchedComments); // 리스트 갱신
    } catch (e) {
      print('댓글 가져오기 실패: $e');
    } finally {
      isLoadingComments.value = false;
    }
  }

  // 댓글 작성
  Future<void> createComment(int postId, String content) async {
    try {
      final newComment = await _communityRepository.createComment(postId: postId, content: content);
      comments.insert(0, newComment); // 새로운 댓글 추가
      currentPost.update((post) {
        if (post != null) post.commentCount += 1;
      });
      update();
    } catch (e) {
      print('댓글 작성 실패: $e');
    }
  }

  // 댓글 수정
  Future<void> updateComment(int commentId, String content) async {
    try {
      final updatedComment = await _communityRepository.updateComment(commentId: commentId, content: content);
      int index = comments.indexWhere((c) => c.commentId == commentId);
      if (index != -1) {
        comments[index] = updatedComment; // 해당 댓글 수정
      }
      update();
    } catch (e) {
      print('댓글 수정 실패: $e');
    }
  }

  // 댓글 삭제
  Future<void> deleteComment(int commentId) async {
    try {
      await _communityRepository.deleteComment(commentId);
      comments.removeWhere((c) => c.commentId == commentId); // 해당 댓글 삭제
      currentPost.update((post) {
        if (post != null && post.commentCount > 0) post.commentCount -= 1;
      });
      update();
    } catch (e) {
      print('댓글 삭제 실패: $e');
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
      update();  // UI 업데이트
    } catch (e) {
      print('게시물 좋아요 토글 실패: $e');
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
      update();  // UI 업데이트
    } catch (e) {
      print('댓글 좋아요 토글 실패: $e');
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
