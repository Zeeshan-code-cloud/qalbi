import 'dart:async';

import 'package:flutter_compass/flutter_compass.dart';
import 'package:get/get.dart';
import 'package:qalbi/presentations/qibla/qibla_entity.dart';

import 'get_qibla_use_case.dart';

class QiblaController  extends GetxController{
  final GetQiblaDirectionUseCase getQiblaDirectionUseCase;

  QiblaController({
    required this.getQiblaDirectionUseCase,
  });

  final Rxn<QiblaEntity> qiblaInfo = Rxn<QiblaEntity>();

  final RxDouble deviceHeading = 0.0.obs;
  final RxDouble qiblaRotation = 0.0.obs;

  final RxBool locationLoading = false.obs;
  final RxBool compassAvailable = true.obs;

  StreamSubscription<CompassEvent>? compassSubscription;

  @override
  void onInit() {
    super.onInit();

    fetchQiblaDirection();
    startCompass();
  }

  // Get current location and Qibla direction
  Future<void> fetchQiblaDirection() async {
    locationLoading.value = true;

    try {
      final result = await getQiblaDirectionUseCase();

      qiblaInfo.value = result;

      updateQiblaRotation();
    } catch (e) {
      Get.snackbar(
        'Qibla Error',
        e.toString(),
      );
    } finally {
      locationLoading.value = false;
    }
  }

  // Listen to device compass
  void startCompass() {
    compassSubscription?.cancel();

    final compassStream = FlutterCompass.events;

    if (compassStream == null) {
      compassAvailable.value = false;
      return;
    }

    compassSubscription = compassStream.listen(
          (event) {
        final heading = event.heading;

        if (heading == null || !heading.isFinite) {
          compassAvailable.value = false;
          return;
        }

        compassAvailable.value = true;

        deviceHeading.value = (heading + 360) % 360;

        updateQiblaRotation();
      },
      onError: (_) {
        compassAvailable.value = false;
      },
    );
  }

  // Calculate needle rotation
  void updateQiblaRotation() {
    final qibla = qiblaInfo.value;

    if (qibla == null) return;

    final difference =
        (qibla.qiblaDirection - deviceHeading.value + 360) %
            360;

    qiblaRotation.value = difference;
  }

  // Refresh location
  Future<void> refreshLocation() async {
    await fetchQiblaDirection();
  }

  double get distanceInKm {
    return (qiblaInfo.value?.distanceToKaaba ?? 0) / 1000;
  }

  @override
  void onClose() {
    compassSubscription?.cancel();
    super.onClose();
  }
}