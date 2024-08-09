import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nero_app/drf/splash/enum/drf_step_type.dart';
import 'package:nero_app/src/common/controller/authentication_controller.dart';
import 'package:nero_app/src/common/controller/data_load_controller.dart';
import 'package:nero_app/src/common/enum/authentication_status.dart';

import '../../common/components/app_font.dart';
import '../../common/components/getx_listener.dart';
import '../controller/drf_splash_controller.dart';

class DrfSplashPage extends GetView<DrfSplashController> {
  const DrfSplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GetxListener<AuthenticationStatus>(
          listen: (AuthenticationStatus status) async {
            switch (status) {
              case AuthenticationStatus.authentication:
                Get.offNamed('/home');
                break;
              case AuthenticationStatus.unAuthenticated:
                var drfUserModel =
                    Get.find<AuthenticationController>().drfUserModel.value;
                await Get.offNamed('/signup/${drfUserModel.uid}');
                Get.find<AuthenticationController>().reload();
                break;
              case AuthenticationStatus.unknown:
                Get.offNamed('/login');
                break;
              case AuthenticationStatus.init:
                break;
            }
          },
          stream: Get.find<AuthenticationController>().status,
          child: GetxListener<bool>(
            listen: (bool value) {
              if (value) {
                controller.loadStep(DrfStepType.authCheck);
              }
            },
            stream: Get.find<DataLoadController>().isDataLoad,
            child: GetxListener<DrfStepType>(
              initCall: () {
                controller.loadStep(DrfStepType.dataLoad);
              },
              listen: (DrfStepType? value) {
                if (value == null) return;
                switch (value) {
                  case DrfStepType.init:
                  case DrfStepType.dataLoad:
                    Get.find<DataLoadController>().loadData();
                    break;
                  case DrfStepType.authCheck:
                    Get.find<AuthenticationController>().authCheck();
                    break;
                }
              },
              stream: controller.loadStep,
              child: const _DrfSplashView(),
            ),
          ),
        ),
      ),
    );
  }
}

class _DrfSplashView extends GetView<DrfSplashController> {
  const _DrfSplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 200),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 99,
                height: 116,
                child: Image.asset(
                  'assets/images/nero_icon.png',
                ),
              ),
              const SizedBox(height: 40),
              const AppFont(
                '당신 곁의 네로',
                fontWeight: FontWeight.bold,
                size: 20,
              ),
              const SizedBox(height: 40),
              AppFont(
                '중고 거래부터 동네 정보까지.\n지금 내 동네를 선택하고 시작해보세요',
                align: TextAlign.center,
                size: 18,
                color: Colors.white.withOpacity(0.6),
              )
            ],
          ),
        ),
        SizedBox(
          height: 200,
          child: Column(
            children: [
              Obx(
                () {
                  return Text(
                    '${controller.loadStep.value.name}중 입니다.',
                    style: const TextStyle(color: Colors.white),
                  );
                },
              ),
              const SizedBox(height: 20),
              const CircularProgressIndicator(
                  strokeWidth: 1, color: Colors.white)
            ],
          ),
        )
      ],
    );
  }
}
