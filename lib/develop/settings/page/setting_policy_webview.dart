import 'dart:convert';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:nero_app/develop/common/components/custom_detail_app_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SettingPolicyWebview extends StatefulWidget {
  const SettingPolicyWebview({Key? key}) : super(key: key);

  @override
  State<SettingPolicyWebview> createState() => _SettingPolicyWebviewState();
}

class _SettingPolicyWebviewState extends State<SettingPolicyWebview> {
  late WebViewController _controller;
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  void initState() {
    super.initState();

    // WebViewController 초기화 및 설정
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xff202020))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // 페이지 로딩 진행 상황 처리 (옵션)
          },
          onPageStarted: (String url) {
            // 페이지 로딩 시작 시 처리 (옵션)
          },
          onPageFinished: (String url) {
            // 페이지 로딩 완료 시 처리 (옵션)
          },
          onWebResourceError: (WebResourceError error) {
            // 웹 리소스 오류 처리 (옵션)
          },
          onNavigationRequest: (NavigationRequest request) {
            // 특정 URL로의 네비게이션을 제어하고 싶을 때 사용
            return NavigationDecision.navigate;
          },
        ),
      )
      ..addJavaScriptChannel(
        'Test',
        onMessageReceived: (JavaScriptMessage message) {
          Map<String, dynamic> data = json.decode(message.message);
          print("JavaScript 메시지: ${data['action']}");
          if (data['action'] == "download") {
            print("JavaScript에서 다운로드 요청 실행");
            print("값: ${data['value']}");
            // 다운로드 로직 추가 가능
          }
        },
      )
      ..loadRequest(Uri.parse(
          'https://lavish-flower-814.notion.site/8905c3179c664d8f848a6bcc85419f1d'));
  }

  @override
  Widget build(BuildContext context) {
    analytics.logScreenView(
      screenName: 'SettingPolicyWebviewPage',
      screenClass: 'SettingPolicyWebviewPage',
    );
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomDetailAppBar(title: '개인정보 처리방침'),
      body: SafeArea(
        child: WebViewWidget(controller: _controller),
      ),
    );
  }
}
