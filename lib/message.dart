import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Message extends StatefulWidget {
  const Message({super.key});

  @override
  State<Message> createState() => _MessageState();
}

class _MessageState extends State<Message> {
  @override
  Widget build(BuildContext context) {
    Map payload = {};
    final data = ModalRoute.of(context)!.settings.arguments;
    if (data is RemoteMessage){ // 백그라운드에서 푸시 알람 탭할 때 처리
      payload = data.data;
    }
    if (data is NotificationResponse) { // 포그라운드에서 푸시 알람 탭할 때 처리
      payload = jsonDecode(data.payload!);
    }
    return Scaffold(
      appBar: AppBar(title: Text('Push Alarm Message')),
      body: Center(child: Text(payload.toString())),
    );
  }
}
