import 'package:get/get.dart';

class TasbeehController extends GetxController {
  final count = 0.obs;
  final dailyGoal = 100.obs;

  void increment() {
    count.value++;
  }

  void decrement() {
    if (count.value > 0) {
      count.value--;
    }
  }

  void reset() {
    count.value = 0;
  }

  double get progress =>
      (count.value / dailyGoal.value).clamp(0.0, 1.0);
}