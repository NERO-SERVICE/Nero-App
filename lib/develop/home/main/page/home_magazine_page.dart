import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nero_app/develop/common/components/custom_loading_indicator.dart';
import 'package:nero_app/develop/home/magazine/model/magazine.dart';
import 'package:nero_app/develop/home/magazine/page/magazine_detail_page.dart';
import 'package:nero_app/develop/home/magazine/page/magazine_list_page.dart';

class HomeMagazinePage extends StatelessWidget {
  final Future<List<Magazine>> latestMagazinesFuture;
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  HomeMagazinePage({
    Key? key,
    required this.latestMagazinesFuture,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    analytics.logScreenView(
      screenName: 'HomeMagazinePage',
      screenClass: 'HomeMagazinePage',
    );
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                '매거진',
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
                    MaterialPageRoute(builder: (context) => MagazineListPage()),
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
        const SizedBox(height: 16),
        FutureBuilder<List<Magazine>>(
          future: latestMagazinesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CustomLoadingIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Failed to load magazines'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No magazines available'));
            } else {
              return ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: ScrollPhysics(),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final magazine = snapshot.data![index];
                  return GestureDetector(
                    onTap: () {
                      Get.to(() => MagazineDetailPage(), arguments: magazine);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 8,
                      ),
                      child: Container(
                        height: 120,  // 각 리스트 항목의 고정된 높이 설정
                        decoration: BoxDecoration(
                          color: Color(0xff3C3C3C),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (magazine.imageUrls.isNotEmpty)
                              Container(
                                width: 120,
                                height: 120,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    bottomLeft: Radius.circular(16),
                                  ),
                                  child: Image.network(
                                    magazine.imageUrls[0],
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(
                                        Icons.error,
                                        size: 40,
                                        color: Colors.grey[400],
                                      );
                                    },
                                  ),
                                ),
                              )
                            else
                              Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    bottomLeft: Radius.circular(16),
                                  ),
                                  color: Color(0xff1C1C1C),
                                ),
                                child: Center(
                                  child: SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: SvgPicture.asset(
                                      'assets/develop/nero-small-logo.svg',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(14.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      magazine.title,
                                      style: TextStyle(
                                        fontFamily: 'Pretendard',
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        color: Color(0xffFFFFFF),
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.visible,
                                      softWrap: true,
                                    ),
                                    Spacer(),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: Text(
                                        '에디터 ${magazine.nickname}',
                                        style: TextStyle(
                                          fontFamily: 'Pretendard',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                          color: Color(0xffD9D9D9),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
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
