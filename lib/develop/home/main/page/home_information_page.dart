import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nero_app/develop/home/information/model/information.dart';
import 'package:nero_app/develop/home/information/page/information_detail_page.dart';
import 'package:nero_app/develop/home/information/page/information_list_page.dart';

class HomeInformationPage extends StatelessWidget {
  final Future<List<Information>> latestInformationFuture;

  const HomeInformationPage({
    Key? key,
    required this.latestInformationFuture,
  }) : super(key: key);

  String _shortenTitle(String title) {
    if (title.length > 25) {
      return '${title.substring(0, 25)}...';
    } else {
      return title;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                '개발자 공지사항 모음',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => InformationListPage()),
                  );
                },
                child: Text(
                  '더보기',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Color(0xffD0EE17),
                  ),
                ),
              ),
            ),
          ],
        ),
        FutureBuilder<List<Information>>(
          future: latestInformationFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Failed to load informations'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No news available'));
            } else {
              return ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: NeverScrollableScrollPhysics(),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final information = snapshot.data![index];
                  return GestureDetector(
                    onTap: () {
                      Get.to(() => InformationDetailPage(), arguments: information);
                    },
                    child: Container(
                      padding:
                      EdgeInsets.symmetric(vertical: 7.0, horizontal: 32.0),
                      child: Text(
                        _shortenTitle(information.title),
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
      ],
    );
  }
}
