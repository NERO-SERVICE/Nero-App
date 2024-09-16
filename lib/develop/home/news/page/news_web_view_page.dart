import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsWebViewPage extends StatefulWidget {
  final String url;

  const NewsWebViewPage({Key? key, required this.url}) : super(key: key);

  @override
  State<NewsWebViewPage> createState() => _WebviewPageState();
}

class _WebviewPageState extends State<NewsWebViewPage> {
  WebViewController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xff202020))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..addJavaScriptChannel('Test', onMessageReceived: (JavaScriptMessage message) {
        Map<String, dynamic> data = json.decode(message.message);
        print("javascript func message: " + data['action'].toString());
        if (data['action'] == "download") {
          print("javascript func download 실행");
          print("value: " + data['value'].toString());
        }
      })
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.chevron_left, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
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
      ),
      body: SafeArea(
        child: WebViewWidget(controller: _controller!),
      ),
    );
  }
}
