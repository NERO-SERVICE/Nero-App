import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nero_app/develop/common/components/custom_loading_indicator.dart';
import 'package:nero_app/develop/home/community/controllers/community_controller.dart';
import 'package:nero_app/develop/home/community/pages/community_detail_page.dart';
import 'package:nero_app/develop/home/community/pages/community_write_page.dart';
import 'package:nero_app/develop/home/community/widgets/post_item.dart';

class CommunityMainPage extends StatelessWidget {
  final CommunityController _controller = Get.put(CommunityController());

  final ScrollController _scrollController = ScrollController();

  CommunityMainPage({Key? key}) : super(key: key) {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 300 &&
          !_controller.isLoadingPosts.value &&
          _controller.hasMorePosts.value) {
        _controller.fetchPosts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('커뮤니티'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: PostSearchDelegate(_controller));
            },
          ),
        ],
      ),
      body: Obx(() {
        if (_controller.isLoadingPosts.value && _controller.posts.isEmpty) {
          return Center(child: CustomLoadingIndicator());
        }

        if (_controller.posts.isEmpty) {
          return Center(child: Text('게시물이 없습니다.', style: TextStyle(color: Colors.white),));
        }

        return RefreshIndicator(
          onRefresh: () => _controller.fetchPosts(refresh: true),
          child: ListView.builder(
            controller: _scrollController,
            itemCount: _controller.posts.length + 1,
            itemBuilder: (context, index) {
              if (index < _controller.posts.length) {
                final post = _controller.posts[index];
                return PostItem(
                  post: post,
                  onTap: () {
                    Get.to(() => CommunityDetailPage(postId: post.postId));
                  },
                  onLike: () {
                    _controller.toggleLikePost(post.postId);
                  },
                  onComment: () {
                    Get.to(() => CommunityDetailPage(postId: post.postId));
                  },
                );
              } else {
                // 하단 로딩 표시
                return Obx(() {
                  if (_controller.hasMorePosts.value) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(child: CustomLoadingIndicator()),
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                });
              }
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => CommunityWritePage());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class PostSearchDelegate extends SearchDelegate {
  final CommunityController controller;

  PostSearchDelegate(this.controller);

  @override
  String get searchFieldLabel => '검색어를 입력하세요';

  @override
  TextStyle? get searchFieldStyle => TextStyle(color: Colors.white);

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      primaryColor: Colors.black,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.black,
      ),
      textTheme: TextTheme(
        titleLarge: TextStyle(color: Colors.white, fontSize: 18), // headline6 대신 titleLarge 사용
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(color: Colors.grey),
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: Icon(Icons.clear, color: Colors.white),
          onPressed: () {
            query = '';
            controller.setSearchQuery('');
          },
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back, color: Colors.white),
      onPressed: () {
        close(context, null); // 검색창 닫기
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    controller.setSearchQuery(query);
    return Obx(() {
      if (controller.isLoadingPosts.value && controller.posts.isEmpty) {
        return Center(child: CustomLoadingIndicator());
      }

      if (controller.posts.isEmpty) {
        return Center(child: Text('검색 결과가 없습니다.'));
      }

      return ListView.builder(
        itemCount: controller.posts.length,
        itemBuilder: (context, index) {
          final post = controller.posts[index];
          return PostItem(
            post: post,
            onTap: () {
              Get.to(() => CommunityDetailPage(postId: post.postId));
            },
            onLike: () {
              controller.toggleLikePost(post.postId);
            },
            onComment: () {
              Get.to(() => CommunityDetailPage(postId: post.postId));
            },
          );
        },
      );
    });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(); // 실시간 검색 제안 기능을 원할 경우 구현
  }
}
