import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nero_app/develop/common/components/custom_loading_indicator.dart';
import 'package:nero_app/develop/home/information/controller/information_controller.dart';
import 'package:nero_app/develop/home/information/page/information_detail_page.dart';
import 'package:nero_app/develop/home/information/page/information_list_page.dart';

class HomeInformationPage extends StatelessWidget {
  final InformationController _informationController = Get.find<InformationController>();
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  HomeInformationPage({
    Key? key,
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
    analytics.logScreenView(
      screenName: 'HomeInformationPage',
      screenClass: 'HomeInformationPage',
    );

    _informationController.fetchInformations();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                '공지사항',
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
                    MaterialPageRoute(
                        builder: (context) => InformationListPage()),
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
        Obx(() {
          if (_informationController.isLoading.value) {
            return Center(child: CustomLoadingIndicator());
          } else if (_informationController.informations.isEmpty) {
            return Center(child: Text('No news available'));
          } else {
            return ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _informationController.informations.length,
              itemBuilder: (context, index) {
                final information = _informationController.informations[index];
                return GestureDetector(
                  onTap: () {
                    Get.to(() => InformationDetailPage(),
                        arguments: information);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        vertical: 7.0, horizontal: 32.0),
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
