import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nero_app/src/chat/controller/chat_controller.dart';
import 'package:nero_app/src/common/components/app_font.dart';
import 'package:nero_app/src/common/components/user_temperature_widget.dart';
import 'package:nero_app/src/common/layout/common_layout.dart';

class ChatPage extends GetView<ChatController> {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonLayout(
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        title: Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppFont(
                controller.opponentUser.value.nickname ?? '',
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(width: 6),
              UserTemperatureWidget(
                temperature: controller.opponentUser.value.temperature ?? 0,
                isSimpled: true,
              ),
            ],
          ),
        ),
        actions: const [
          SizedBox(width: 50),
        ],
      ),
      body: Column(
        children: [
          _HeaderItemInfo(),
          Spacer(),
          _TextFieldWidget(),
          KeyboardVisibilityBuilder(builder: (context, visible) {
            return SizedBox(
                height: visible
                    ? MediaQuery.of(context).viewInsets.bottom
                    : Get.mediaQuery.padding.bottom);
          }),
        ],
      ),
    );
  }
}

class _TextFieldWidget extends GetView<ChatController> {
  const _TextFieldWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                filled: true,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(30.0))
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(30.0))
                ),
                border: InputBorder.none,
                hintStyle: TextStyle(color: Color(0xff696D75)),
                hintText: '메세지 보내기',
                contentPadding:
                  EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                fillColor: Color(0xff2B2E32),
              ),
              maxLines: null,
              onSubmitted: (value) {},
            ),
          ),
          GestureDetector(
            onTap: () async {},
            behavior: HitTestBehavior.translucent,
            child: Container(
              padding: const EdgeInsets.all(7),
              child: SvgPicture.asset('assets/svg/icons/icon_sender.svg'),
            ),
          )
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
