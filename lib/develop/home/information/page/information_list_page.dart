import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nero_app/develop/common/components/custom_detail_app_bar.dart';
import 'package:nero_app/develop/home/information/controller/information_controller.dart';

import 'information_detail_page.dart';

class InformationListPage extends StatelessWidget {
  final InformationController _informationController =
      Get.put(InformationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomDetailAppBar(title: '전체 공지사항'),
      body: Obx(
        () {
          if (_informationController.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }

          if (_informationController.informations.isEmpty) {
            return Center(child: Text('No informations available'));
          }

          return ListView.builder(
            itemCount: _informationController.informations.length,
            itemBuilder: (context, index) {
              final information = _informationController.informations[index];
              return GestureDetector(
                onTap: () {
                  Get.to(() => InformationDetailPage(), arguments: information);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 8,
                  ),
                  child: Container(
                    height: 120, // 각 리스트 항목의 고정된 높이 설정
                    decoration: BoxDecoration(
                      color: Color(0xff3C3C3C),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 썸네일 이미지
                        if (information.imageUrls.isNotEmpty)
                          Container(
                            width: 120,
                            height: 120,
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16),
                                bottomLeft: Radius.circular(16),
                              ),
                              child: Image.network(
                                information.imageUrls[0],
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

                        // 제목 및 작성자 정보
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 제목
                                Text(
                                  information.title,
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
                                    '에디터 ${information.nickname}',
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
        },
      ),
    );
  }
}
