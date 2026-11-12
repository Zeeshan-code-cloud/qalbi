import 'dart:math' as math;

import 'package:qalbi/presentations/export.dart';
import 'package:qalbi/presentations/qibla/qibla_controller.dart';

import '../../enums/enum.dart';
import '../../widgets/custom_appbar.dart';

class QiblaView extends GetView<QiblaController> {
  const QiblaView({super.key});

  @override
  Widget build(BuildContext context) {
    final navType = Get.arguments;
    return Obx(
      () => Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppCustomBar(
          title: 'Qibla Compass',
          leading: navType == NavType.fromHomeTile
              ? IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(Icons.arrow_back, color: AppColors.primaryColor),
                )
              : const SizedBox.shrink(),
           backgroundColor: AppColors.background,
        ),
        body: SafeArea(
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(AppAssets.qiblaScreenBg, fit: BoxFit.cover),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 2.w,
                  vertical: 2.h,
                ),
                child: Column(
                  children: [
                    SizedBox(height: 20.h),
                    SizedBox(
                      width: double.infinity,
                      height: 35.h,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Image.asset(
                              AppAssets.qiblaCompass,
                              fit: BoxFit.contain,
                            ),
                          ),
                          Positioned(
                            left: 32.8.w,
                            top: 10.6.h,
                            child: Obx(
                              () => Transform.rotate(
                                angle: controller.qiblaRotation.value *
                                    math.pi /
                                    180,
                                child: Image.asset(
                                  AppAssets.qibla,
                                  height: 14.h,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 5.h),
                    AppText(
                      'Qibla Direction',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                    SizedBox(height: 1.h),
                    Obx(() {
                      final direction = controller.qiblaInfo.value?.qiblaDirection;
                      return AppText(
                        direction == null ? '--°' : '${direction.round()}°',
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      );
                    }),
                    SizedBox(height: 1.h),
                    Obx(() {
                      final message = controller.locationLoading.value
                          ? 'Finding your Qibla direction...'
                          : controller.qiblaInfo.value == null
                              ? 'Enable location to find the Qibla direction'
                              : !controller.compassAvailable.value
                                  ? 'Compass sensor is unavailable'
                                  : 'Turn your device until the marker points toward the Qibla';
                      return AppText(
                        message,
                        textAlign: TextAlign.center,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.prayerHighlight,
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
