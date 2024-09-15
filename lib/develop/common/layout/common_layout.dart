import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nero_app/background_layout.dart';
import 'package:nero_app/develop/common/controller/common_layout_controller.dart';

import '../components/loading.dart';

class CommonLayout extends GetView<CommonLayoutController> {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavBar;
  final Widget? floatingActionButton;
  final bool useSafeArea;
  const CommonLayout({
    super.key,
    required this.body,
    this.appBar,
    this.floatingActionButton,
    this.useSafeArea = false,
    this.bottomNavBar,
  });

  @override
  Widget build(BuildContext context) {
    return BackgroundLayout(
      child: Obx(
              () => Stack(
            fit: StackFit.expand,
            children: [
              Scaffold(
                resizeToAvoidBottomInset: false,
                appBar: appBar,
                backgroundColor: Colors.transparent,
                body: useSafeArea ? SafeArea(child: body) : body,
                bottomNavigationBar: bottomNavBar ?? const SizedBox(height: 1),
                floatingActionButton: floatingActionButton,
              ),
              controller.isLoading.value ? const Loading() : Container(),
            ],
          ),
        ),
    );
  }
}