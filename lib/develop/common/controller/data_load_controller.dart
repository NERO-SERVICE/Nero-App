import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DataLoadController extends GetxController{
  RxBool isDataLoad = false.obs;

  void loadData() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(Duration(seconds: 2)); // 예시로 딜레이를 추가
      isDataLoad(true); // 상태 변경
    });
  }
}