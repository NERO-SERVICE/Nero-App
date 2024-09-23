import 'package:get/get.dart';
import 'package:nero_app/develop/splash/enum/step_type.dart';

class SplashController extends GetxController {
  var loadStep = StepType.init.obs;

  void changeStep(StepType step) {
    loadStep.value = step;
  }
}