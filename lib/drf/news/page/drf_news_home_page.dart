import 'package:flutter/material.dart';
import 'package:nero_app/drf/news/model/drf_news.dart';
import 'package:nero_app/drf/news/repository/drf_news_repository.dart';
import 'package:nero_app/drf/news/page/drf_webview_page.dart';

class DrfNewsHomePage extends StatefulWidget {
  @override
  _DrfNewsHomePageState createState() => _DrfNewsHomePageState();
}

class _DrfNewsHomePageState extends State<DrfNewsHomePage> {
  final DrfNewsRepository _newsRepository = DrfNewsRepository();
  late Future<List<DrfNews>> _latestNewsFuture;

  @override
  void initState() {
    super.initState();
    _latestNewsFuture = _newsRepository.getLatestNews(); // 최신 뉴스 불러오기
  }

  String _shortenTitle(String title) {
    if (title.length > 25) {
      return '${title.substring(0, 25)}...(더보기)';
    } else {
      return title;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<DrfNews>>(
        future: _latestNewsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load news'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No news available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final news = snapshot.data![index];
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
                        fontSize: 15,
                        color: Color(0xffD9D9D9),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
