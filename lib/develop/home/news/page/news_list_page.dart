import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nero_app/develop/common/components/custom_detail_app_bar.dart';
import 'package:nero_app/develop/home/news/model/news.dart';
import 'package:nero_app/develop/home/news/page/news_web_view_page.dart';
import 'package:nero_app/develop/home/news/repository/news_repository.dart';

class NewsListPage extends StatefulWidget {
  @override
  _NewsListPageState createState() => _NewsListPageState();
}

class _NewsListPageState extends State<NewsListPage> {
  final NewsRepository _newsRepository = NewsRepository();
  final ScrollController _scrollController = ScrollController();
  List<News> _newsList = [];
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
    await _fetchNewsPage(_currentPage);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent &&
        !_isLoading &&
        _hasMore) {
      _fetchNewsPage(_currentPage + 1);
    }
  }

  Future<void> _fetchNewsPage(int page) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      List<News> newsPage = await _newsRepository.getNewsPage(page);
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
    if (title.length > 25) {
      return '${title.substring(0, 25)}...';
    } else {
      return title;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomDetailAppBar(title: '뉴스 모음'),
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
                        builder: (context) => NewsWebViewPage(
                          url: news.link,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 32.0),
                    padding: EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Color(0xff3C3C3C),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 100,
                          height: 60,
                          child: SvgPicture.asset(
                            'assets/develop/nero-small-logo.svg',
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _shortenTitle(news.title),
                            textAlign: TextAlign.start,
                            softWrap: true,
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w500,
                              fontSize: 17,
                              color: Color(0xffD9D9D9),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        SvgPicture.asset(
                          'assets/develop/arrow-right.svg',
                          width: 24,
                          height: 24,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(width: 5),
                      ],
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
