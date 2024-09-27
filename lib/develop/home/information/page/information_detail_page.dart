import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nero_app/develop/common/components/custom_divider.dart';
import 'package:nero_app/develop/home/information/controller/information_controller.dart';

import '../model/information.dart';

class InformationDetailPage extends StatefulWidget {
  InformationDetailPage({super.key});

  @override
  _InformationDetailPageState createState() => _InformationDetailPageState();
}

class _InformationDetailPageState extends State<InformationDetailPage> {
  final InformationController controller = Get.find<InformationController>();
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late Information information;

  @override
  void initState() {
    super.initState();
    information = Get.arguments as Information;

    // 컨트롤러의 currentInformation을 전달받은 정보로 먼저 설정
    controller.currentInformation.value = information;

    // fetchInformation 호출하여 최신 정보 가져오기
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.currentInformation.value.infoId != information.infoId) {
        controller.fetchInformation(information.infoId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final information = controller.currentInformation.value;

        return Stack(
          children: [
            // 메인 콘텐츠
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (information.imageUrls.isNotEmpty)
                    Stack(
                      children: [
                        SizedBox(
                          height: 400,
                          width: double.infinity,
                          child: PageView.builder(
                            controller: _pageController,
                            onPageChanged: (int page) {
                              setState(() {
                                _currentPage = page;
                              });
                            },
                            itemCount: information.imageUrls.length,
                            itemBuilder: (context, index) {
                              return Image.network(
                                information.imageUrls[index],
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  }
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  (loadingProgress
                                                          .expectedTotalBytes ??
                                                      1)
                                              : null,
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.error);
                                },
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                        ),
                        Positioned(
                          bottom: 24,
                          left: 0,
                          right: 0,
                          child: _buildIndicator(information.imageUrls.length),
                        ),
                      ],
                    )
                  else
                    const Center(
                        child: Text('이미지가 없습니다.',
                            style: TextStyle(color: Colors.white))),
                  const SizedBox(height: 30),

                  InformationTitleWidget(title: information.title),
                  const SizedBox(height: 30),
                  const CustomDivider(),

                  const SizedBox(height: 30),
                  if (information.description != null)
                    InformationContentWidget(content: information.description!),
                  const SizedBox(height: 20),
                  InformationDateWidget(createdAt: information.createdAt),
                  const SizedBox(height: 20),
                  const CustomDivider(),

                  // 작성자 정보
                  const SizedBox(height: 30),
                  InformationWriterWidget(nickname: information.nickname),
                  const SizedBox(height: 40),
                ],
              ),
            ),
            // 투명 앱바
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AppBar(
                scrolledUnderElevation: 0,
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
                leading: IconButton(
                  icon: const Icon(Icons.chevron_left, color: Colors.white),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  // 인디케이터 빌드 함수
  Widget _buildIndicator(int length) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(length, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.fastOutSlowIn,
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          width: _currentPage == index ? 32 : 8.0,
          height: 8.0,
          decoration: BoxDecoration(
            color: _currentPage == index
                ? const Color(0xffD0EE17)
                : Colors.white.withOpacity(0.4),
            borderRadius: BorderRadius.circular(6),
          ),
        );
      }),
    );
  }
}

class InformationTitleWidget extends StatelessWidget {
  final String title;

  const InformationTitleWidget({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w600,
          fontSize: 18,
          color: Color(0xffFFFFFF),
        ),
      ),
    );
  }
}

class InformationContentWidget extends StatelessWidget {
  final String content;

  const InformationContentWidget({required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Text(
        content,
        style: const TextStyle(
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: Color(0xffFFFFFF),
        ),
      ),
    );
  }
}

class InformationWriterWidget extends StatelessWidget {
  final String nickname;

  const InformationWriterWidget({required this.nickname});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/develop/nero-small-logo.svg',
            width: 40,
            height: 40,
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                nickname,
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Color(0xffFFFFFF),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                '에디터',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w500,
                  fontSize: 10,
                  color: Color(0xff848B8B),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class InformationDateWidget extends StatelessWidget {
  final DateTime createdAt;

  const InformationDateWidget({
    required this.createdAt,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Align(
        alignment: Alignment.centerRight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              '작성일',
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w500,
                fontSize: 10,
                color: Color(0xff848B8B),
              ),
            ),
            Text(
              '${createdAt.toString().substring(0, 10)}',
              style: const TextStyle(
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w500,
                fontSize: 10,
                color: Color(0xff848B8B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
