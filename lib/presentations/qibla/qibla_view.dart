import 'package:qalbi/presentations/export.dart';

import '../../enums/enum.dart';
import '../../widgets/custom_appbar.dart';

class QiblaView extends StatelessWidget {
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
          actionIcon: Icons.search_rounded,
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
                            child: Image.asset(
                              AppAssets.qibla,
                              height: 14.h,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 5.h),
                    AppText(
                      "Qibla Directions",
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                    SizedBox(height: 1.h),
                    AppText(
                      "256°",
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: AppColors.accent,
                    ),
                    SizedBox(height: 1.h),
                    AppText(
                      "You are facing the right direction",
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.secondaryText,
                    ),
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
