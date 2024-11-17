import 'dart:io';
import 'package:get/get.dart';
import 'package:nero_app/develop/common/components/custom_snackbar.dart';
import 'package:nero_app/develop/community/models/comment.dart';
import 'package:nero_app/develop/community/models/post.dart';
import 'package:nero_app/develop/community/models/report_request.dart';
import 'package:nero_app/develop/community/repository/community_repository.dart';

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

  // 검색
  var searchQuery = ''.obs;
  // 현재 스크롤 위치 저장
  var scrollOffsetMain = 0.0.obs; // CommunityMainPage 스크롤 오프셋
  var scrollOffsetSearch = 0.0.obs; // CommunitySearchPage 스크롤 오프셋

  // 게시물 정보 및 댓글 목록 관리
  Rx<Post> currentPost = Post.empty().obs;
  RxList<Comment> comments = <Comment>[].obs;

  // 로딩 상태
  var isLoadingPostDetail = false.obs;
  var isLoadingComments = false.obs;

  // 댓글 목록
  var currentCommentPage = 1.obs;
  var hasMoreComments = true.obs;

  // 좋아요한 게시물 목록
  var likedPosts = <Post>[].obs;
  var isLoadingLikedPosts = false.obs;
  var currentLikedPostPage = 1.obs;
  var hasMoreLikedPosts = true.obs;

  // 내가 작성한 게시물 목록
  var myPosts = <Post>[].obs;
  var isLoadingMyPosts = false.obs;
  var currentMyPostPage = 1.obs;
  var hasMoreMyPosts = true.obs;

  // 인기 게시물 목록
  var popularPosts = <Post>[].obs;
  var isLoadingPopularPosts = false.obs;
  var currentPopularPostPage = 1.obs;
  var hasMorePopularPosts = true.obs;

  // 최근 게시물 목록
  var recentPosts = <Post>[].obs;
  var isLoadingRecentPosts = false.obs;

  // 게시물 타입
  RxString selectedType = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllPosts(refresh: true); // 초기 게시물 로드
  }

  final Map<String, String> typeMapping = {
    '인증': 'certification',
    '습관': 'habit',
    '일기': 'diary',
    '고민': 'worry',
    '정보': 'information',
  };

  Map<String, String> get reverseTypeMapping => {
    for (var entry in typeMapping.entries) entry.value: entry.key,
  };

  String translateTypeToKorean(String? type) {
    if (type == null || type.isEmpty) return '';
    return reverseTypeMapping[type] ?? type;
  }

  // type 업데이트 함수
  void updateSelectedType(String type) {
    selectedType.value = type;
  }

  Future<void> fetchAllPosts({bool refresh = false}) async {
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
      );

      if (fetchedPosts.isNotEmpty) {
        posts.addAll(fetchedPosts);
        currentPostPage.value += 1;
      }

      hasMorePosts.value = fetchedPosts.length == 10;
    } catch (e) {
      print('게시물 가져오기 실패: $e');
    } finally {
      isLoadingPosts.value = false;
    }
  }

  Future<void> fetchFilteredPosts({bool refresh = false}) async {
    if (isLoadingPosts.value || searchQuery.isEmpty) return;

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
        searchQuery: searchQuery.value,
      );

      if (fetchedPosts.isNotEmpty) {
        posts.addAll(fetchedPosts);
        currentPostPage.value += 1;
      }

      hasMorePosts.value = fetchedPosts.length == 10;
    } catch (e) {
      print('검색된 게시물 가져오기 실패: $e');
    } finally {
      isLoadingPosts.value = false;
    }
  }

  // 검색 쿼리 설정
  void setSearchQuery(String query) {
    searchQuery.value = query;
    fetchFilteredPosts(refresh: true); // 검색 쿼리 변경 시 필터링된 게시물 새로고침
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

  Future<void> createPost({
    required String content,
    List<File>? images,
  }) async {
    try {
      final typeKey = selectedType.value.isNotEmpty
          ? typeMapping[selectedType.value]
          : null; // 매핑된 type 값
      final newPost = await _communityRepository.createPost(
        content: content,
        images: images,
        type: typeKey, // 서버로 매핑된 값 전달
      );
      fetchAllPosts(refresh: true);
      selectedImages.clear();
      this.content.value = '';
      selectedType.value = '';
      CustomSnackbar.show(
        context: Get.context!,
        message: '게시물이 생성되었습니다.',
        isSuccess: true,
      );
    } catch (e) {
      print('게시물 작성 실패: $e');
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
      update();
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

  // 게시물,댓글 신고
  Future<void> reportContent({
    required String reportType,
    int? postId,
    int? commentId,
    String? description,
  }) async {
    final reportRequest = ReportRequest(
      reportType: reportType,
      postId: postId,
      commentId: commentId,
      description: description,
    );

    try {
      if (postId != null) {
        await _communityRepository.reportPost(reportRequest);
      } else if (commentId != null) {
        await _communityRepository.reportComment(reportRequest);
      }
      CustomSnackbar.show(
        context: Get.context!,
        message: '신고가 접수되었습니다.',
        isSuccess: true,
      );
    } catch (e) {
      print('신고 처리 실패: $e');
      CustomSnackbar.show(
        context: Get.context!,
        message: '신고 처리에 실패했습니다.',
        isSuccess: false,
      );
    }
  }

  // 좋아요한 게시물 가져오기
  Future<void> fetchLikedPosts({bool refresh = false}) async {
    if (isLoadingLikedPosts.value) return;

    if (refresh) {
      currentLikedPostPage.value = 1;
      hasMoreLikedPosts.value = true;
      likedPosts.clear();
    }

    if (!hasMoreLikedPosts.value) return;

    isLoadingLikedPosts.value = true;

    try {
      final fetchedPosts = await _communityRepository.fetchLikedPosts(
        page: currentLikedPostPage.value,
      );

      if (fetchedPosts.isNotEmpty) {
        likedPosts.addAll(fetchedPosts);
        currentLikedPostPage.value += 1;
      }

      hasMoreLikedPosts.value = fetchedPosts.length == 10;
    } catch (e) {
      print('좋아요한 게시물 가져오기 실패: $e');
    } finally {
      isLoadingLikedPosts.value = false;
    }
  }

  // 내가 작성한 게시물 가져오기
  Future<void> fetchMyPosts({bool refresh = false}) async {
    if (isLoadingMyPosts.value) return;

    if (refresh) {
      currentMyPostPage.value = 1;
      hasMoreMyPosts.value = true;
      myPosts.clear();
    }

    if (!hasMoreMyPosts.value) return;

    isLoadingMyPosts.value = true;

    try {
      final fetchedPosts = await _communityRepository.fetchMyPosts(
        page: currentMyPostPage.value,
      );

      if (fetchedPosts.isNotEmpty) {
        myPosts.addAll(fetchedPosts);
        currentMyPostPage.value += 1;
      }

      hasMoreMyPosts.value = fetchedPosts.length == 10;
    } catch (e) {
      print('내가 작성한 게시물 가져오기 실패: $e');
    } finally {
      isLoadingMyPosts.value = false;
    }
  }

  // 인기 게시물 가져오기
  Future<void> fetchPopularPosts({bool refresh = false}) async {
    if (isLoadingPopularPosts.value) return;

    if (refresh) {
      currentPopularPostPage.value = 1;
      hasMorePopularPosts.value = true;
      popularPosts.clear();
    }

    if (!hasMorePopularPosts.value) return;

    isLoadingPopularPosts.value = true;

    try {
      final fetchedPosts = await _communityRepository.fetchPopularPosts(
        page: currentPopularPostPage.value,
      );

      if (fetchedPosts.isNotEmpty) {
        popularPosts.addAll(fetchedPosts);
        currentPopularPostPage.value += 1;
      }

      hasMorePopularPosts.value = fetchedPosts.length == 10;
    } catch (e) {
      print('인기 게시물 가져오기 실패: $e');
    } finally {
      isLoadingPopularPosts.value = false;
    }
  }

  // 최근 게시물 가져오기
  Future<void> fetchRecentPosts() async {
    if (isLoadingRecentPosts.value) return;

    isLoadingRecentPosts.value = true;

    try {
      final fetchedPosts = await _communityRepository.fetchRecentPosts();
      recentPosts.assignAll(fetchedPosts);
    } catch (e) {
      print('최근 게시물 가져오기 실패: $e');
    } finally {
      isLoadingRecentPosts.value = false;
    }
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

  // 검색 상태 초기화
  void clearSearch() {
    searchQuery.value = '';
    posts.clear();
    hasMorePosts.value = true;
    currentPostPage.value = 1;
    update();
  }
}
