import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nero_app/src/common/enum/authentication_status.dart';
import '../../common/components/app_font.dart';
import '../../common/components/getx_listener.dart';
import '../../common/controller/authentication_controller.dart';
import '../../common/controller/data_load_controller.dart';
import '../controller/splash_controller.dart';
import '../enum/step_type.dart';

class SplashPage extends GetView<SplashController> {
  const SplashPage({super.key});

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
                var userModel =
                    Get.find<AuthenticationController>().userModel.value;
                await Get.offNamed('/signup/${userModel?.uid}');
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
                controller.loadStep(StepType.authCheck);
              }
            },
            stream: Get.find<DataLoadController>().isDataLoad,
            child: GetxListener<StepType>(
              initCall: () {
                controller.loadStep(StepType.dataLoad);
              },
              listen: (StepType? value) {
                if (value == null) return;
                switch (value) {
                  case StepType.init:
                  case StepType.dataLoad:
                    Get.find<DataLoadController>().loadData();
                    break;
                  case StepType.authCheck:
                    Get.find<AuthenticationController>().authCheck();
                    break;
                }
              },
              stream: controller.loadStep,
              child: const _SplashView(),
            ),
          ),
        ),
      ),
    );
  }
}

class _SplashView extends GetView<SplashController> {
  const _SplashView({super.key});

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
                '토탈 케어 플랫폼 \n 네로를 시작하세요',
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
