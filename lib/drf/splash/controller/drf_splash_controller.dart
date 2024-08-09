
import 'package:get/get.dart';
import 'package:nero_app/drf/splash/enum/drf_step_type.dart';

class DrfSplashController extends GetxController{
  Rx<DrfStepType> loadStep = DrfStepType.dataLoad.obs;

  changeStep(DrfStepType type){
    loadStep(type);
  }
}