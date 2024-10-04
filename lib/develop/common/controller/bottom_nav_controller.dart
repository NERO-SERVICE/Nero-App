import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nero_app/develop/fastmemo/controller/fastmemo_controller.dart';

class BottomNavController extends GetxController
    with GetTickerProviderStateMixin {
  late TabController tabController;
  RxInt menuIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 4, vsync: this);
  }

  void changeBottomNav(int index) {
    menuIndex(index);
    tabController.animateTo(index);
  }
}
