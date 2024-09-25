import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nero_app/develop/home/main/page/home_main_content_page.dart';
import 'package:nero_app/develop/mail/controller/mail_controller.dart';
import 'package:nero_app/develop/settings/page/setting_page.dart';

class HomeMainPage extends StatefulWidget {
  const HomeMainPage({super.key});

  @override
  State<HomeMainPage> createState() => _HomeMainPageState();
}

class _HomeMainPageState extends State<HomeMainPage> {
  final TextEditingController _suggestionController = TextEditingController();
  final MailController _mailController = Get.put(MailController());

  void _showMailToDeveloperDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            backgroundColor: Color(0xffD8D8D8).withOpacity(0.3),
            contentPadding: EdgeInsets.zero,
            content: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 40, left: 16, right: 16, bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "To.개발자",
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "네로를 이용하시며 불편하셨던 점이나,\n건의하고 싶은 모든 것을 편하게 적어주세요!",
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: Color(0xffD9D9D9),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                      TextField(
                        controller: _suggestionController,
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xffFFFFFF),
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xff3C3C3C),
                          hintText: '제안을 입력해주세요 (최대 200자)',
                          hintStyle: TextStyle(
                            fontSize: 14,
                            color: Color(0xff959595),
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w500,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                                color: Colors.white.withOpacity(0), width: 1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                                color: Colors.white.withOpacity(0), width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide:
                                BorderSide(color: Color(0xffD0EE17), width: 1),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 13, vertical: 10),
                        ),
                        maxLength: 200,
                        maxLines: null,
                        minLines: 5,
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            _mailController.suggestion.value =
                                _suggestionController.text;
                            _mailController
                                .sendMail(); // Owner ID를 실제 유저 ID로 변경
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xff323232),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: 12.0,
                              horizontal: 66.0,
                            ),
                          ),
                          child: Text(
                            '보내기',
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Color(0xffD0EE17),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
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
        toolbarHeight: 56.0,
        titleSpacing: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Row(
                children: [
                  SizedBox(width: 32),
                  SvgPicture.asset(
                    'assets/develop/nero-appbar-logo.svg',
                    width: 71,
                    height: 27,
                  ),
                ],
              ),
            ),
            Container(
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      _showMailToDeveloperDialog();
                    },
                    child: SvgPicture.asset(
                      'assets/develop/letter.svg',
                      width: 24,
                      height: 24,
                    ),
                  ),
                  SizedBox(width: 40),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SettingPage()),
                      );
                    },
                    child: SvgPicture.asset(
                      'assets/develop/setting.svg',
                      width: 24,
                      height: 24,
                    ),
                  ),
                  SizedBox(width: 24),
                ],
              ),
            )
          ],
        ),
      ),
      body: HomeMainContentPage(),
    );
  }
}
