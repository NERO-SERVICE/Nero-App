import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nero_app/src/chat/controller/chat_controller.dart';
import 'package:nero_app/src/common/components/app_font.dart';
import 'package:nero_app/src/common/layout/common_layout.dart';

class ChatPage extends GetView<ChatController> {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonLayout(
      appBar: AppBar(),
      body: const Column(
        children: [
          _HeaderItemInfo(),
        ],
      ),
    );
  }
}

class _HeaderItemInfo extends GetView<ChatController> {
  const _HeaderItemInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Obx(
        () => Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(7),
              child: controller.product.value.imageUrls?.first == null
                  ? Container()
                  : CachedNetworkImage(
                      imageUrl: controller.product.value.imageUrls?.first ?? '',
                      height: 50,
                      width: 50,
                      fit: BoxFit.cover,
                    ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      AppFont(
                        controller.product.value.status!.name,
                        size: 13,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(width: 5),
                      AppFont(
                        controller.product.value.title ?? '',
                        size: 13,
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  AppFont(
                    controller.product.value.productPrice == 0
                        ? '무료 나눔'
                        : '${NumberFormat('###,###,###,###').format(controller.product.value.productPrice ?? 0)}원',
                    size: 16,
                    fontWeight: FontWeight.bold,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
