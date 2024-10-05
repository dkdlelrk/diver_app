import 'package:get/get.dart';

class AnimationsData extends GetxController {
  var isFloatingButton = false.obs;

  void isClick() {
    isFloatingButton.value = !isFloatingButton.value;
  }
}
