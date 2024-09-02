import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:nero_app/drf/news/model/drf_news.dart';
import 'package:nero_app/drf/news/repository/drf_news_repository.dart';
import 'package:nero_app/drf/news/page/drf_webview_page.dart';

class DrfNewsListPage extends StatefulWidget {
  @override
  _DrfNewsListPageState createState() => _DrfNewsListPageState();
}

class _DrfNewsListPageState extends State<DrfNewsListPage> {
  final DrfNewsRepository _newsRepository = DrfNewsRepository();
  final ScrollController _scrollController = ScrollController();
  List<DrfNews> _newsList = [];
  bool _isLoading = false;
  int _currentPage = 1;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _fetchInitialNews();
    _scrollController.addListener(_onScroll);
  }

  Future<void> _fetchInitialNews() async {
    // 초기 뉴스 로드
    await _fetchNewsPage(_currentPage);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent && !_isLoading && _hasMore) {
      _fetchNewsPage(_currentPage + 1);
    }
  }

  Future<void> _fetchNewsPage(int page) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      List<DrfNews> newsPage = await _newsRepository.getNewsPage(page);
      setState(() {
        if (newsPage.isEmpty) {
          _hasMore = false;
        } else {
          _currentPage = page;
          _newsList.addAll(newsPage);
        }
      });
    } catch (e) {
      // 에러 핸들링
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _shortenTitle(String title) {
    if (title.length > 20) {
      return '${title.substring(0, 20)}...(더보기)';
    } else {
      return title;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        scrolledUnderElevation: 0, // 앱바 scroll 색상 오류 해결
        leading: IconButton(
          icon: Icon(Icons.chevron_left, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),
      ),
      body: _newsList.isEmpty && _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        controller: _scrollController,
        itemCount: _newsList.length + (_hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _newsList.length) {
            return Center(child: CircularProgressIndicator());
          }
          final news = _newsList[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DrfWebviewPage(
                    url: news.link,
                  ),
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 7.0, horizontal: 32.0),
              child: Text(
                _shortenTitle(news.title),
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w500,
                  fontSize: 17,
                  color: Color(0xffD9D9D9),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }
}
