import 'package:get/get.dart';
import 'package:nero_app/develop/splash/enum/step_type.dart';

class SplashController extends GetxController {
  Rx<StepType> loadStep = StepType.dataload.obs;

  changeStep(StepType type) {
    loadStep(type);
  }
}