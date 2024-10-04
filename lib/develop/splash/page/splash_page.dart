import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nero_app/develop/common/components/custom_loading_indicator.dart';
import 'package:nero_app/develop/common/components/getx_listener.dart';
import 'package:nero_app/develop/common/controller/data_load_controller.dart';
import 'package:nero_app/develop/splash/controller/splash_controller.dart';
import 'package:nero_app/develop/splash/enum/step_type.dart';
import 'package:nero_app/develop/user/controller/authentication_controller.dart';
import 'package:nero_app/develop/user/enum/authentication_status.dart';

class SplashPage extends GetView<SplashController> {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const _BackgroundView(),
          Center(
            child: GetxListener<AuthenticationStatus>(
              listen: (AuthenticationStatus status) async {
                switch (status) {
                  case AuthenticationStatus.authentication:
                    Future.microtask(() => Get.offNamed('/home'));
                    break;
                  case AuthenticationStatus.unAuthenticated:
                    Future.microtask(() => Get.offNamed('/signup'));
                    break;
                  case AuthenticationStatus.unknown:
                    Future.microtask(() => Get.offNamed('/login'));
                    break;
                  case AuthenticationStatus.init:
                    break;
                }
              },
              stream: Get.find<AuthenticationController>().status,
              child: GetxListener<bool>(
                listen: (bool value) {
                  if (value) {
                    Future.microtask(
                        () => controller.changeStep(StepType.authCheck));
                  }
                },
                stream: Get.find<DataLoadController>().isDataLoad,
                child: GetxListener<StepType>(
                  initCall: () {
                    Future.microtask(
                        () => controller.changeStep(StepType.dataload));
                  },
                  listen: (StepType? value) {
                    if (value == null) return;
                    switch (value) {
                      case StepType.init:
                        break;
                      case StepType.dataload:
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
        ],
      ),
    );
  }
}

class _BackgroundView extends StatelessWidget {
  const _BackgroundView({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/login_background.png',
            fit: BoxFit.cover,
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.center,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.9),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SplashView extends GetView<SplashController> {
  const _SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 65),
          Expanded(
            child: _ContentView(),
          ),
          const SizedBox(height: 200, child: _ProgressView()),
        ],
      ),
    );
  }
}

class _ContentView extends StatelessWidget {
  const _ContentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'By Your Side',
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w500,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 8),
        Text(
          '오늘도 한발짝\n스스로 돌아보며\n네로(Nero)',
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w600,
            fontSize: 44,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class _ProgressView extends GetView<SplashController> {
  const _ProgressView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Obx(
          () {
            return Text(
              '${controller.loadStep.value.name} 중입니다.',
              style: const TextStyle(
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.white,
              ),
            );
          },
        ),
        const SizedBox(height: 20),
        CustomLoadingIndicator(),
      ],
    );
  }
}
