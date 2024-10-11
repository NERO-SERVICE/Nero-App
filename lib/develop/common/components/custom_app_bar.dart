import 'dart:ui';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nero_app/develop/common/components/custom_complete_button.dart';
import 'package:nero_app/develop/mail/controller/mail_controller.dart';
import 'package:nero_app/develop/settings/page/setting_page.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;

  CustomAppBar({required this.title});

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(56.0);
}

class _CustomAppBarState extends State<CustomAppBar> {
  final TextEditingController _suggestionController = TextEditingController();
  final MailController _mailController = Get.put(MailController());
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  void _showMailToDeveloperDialog() {
    analytics.logEvent(
      name: 'MailToDeveloperDialog',
      parameters: {'action': 'open_dialog'},
    );
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
                      ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: 120, minHeight: 120),
                        child: Scrollbar(
                          child: TextField(
                            cursorColor: Color(0xffD9D9D9),
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
                                borderSide: BorderSide(color: Colors.white.withOpacity(0), width: 1),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(color: Colors.white.withOpacity(0), width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(color: Color(0xffD0EE17), width: 1),
                              ),
                              contentPadding: EdgeInsets.symmetric(horizontal: 13, vertical: 10),
                              counterStyle: TextStyle( // maxLength 스타일
                                fontSize: 12,
                                color: Color(0xffD9D9D9).withOpacity(0.3),
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            maxLength: 200,
                            maxLines: null,
                            minLines: 5,
                            expands: false,
                            scrollPadding: EdgeInsets.zero,
                            keyboardType: TextInputType.multiline,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: CustomCompleteButton(
                          onPressed: () {
                            analytics.logEvent(
                              name: 'try_send_suggestion',
                              parameters: {'action': 'try_send_mail'},
                            );
                            _mailController.suggestion.value = _suggestionController.text;
                            _mailController.sendMail();
                            _suggestionController.clear();
                            Navigator.of(context).pop();
                          },
                          text: '보내기',
                          isEnabled: true,
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
    return AppBar(
      automaticallyImplyLeading: false,
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
          Row(
            children: [
              SizedBox(width: 32),
              Text(
                widget.title,
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Row(
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
        ],
      ),
    );
  }
}
