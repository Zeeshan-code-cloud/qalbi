import '../export.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: AppColors.background,
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(top: 22.h),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: AppColors.background.withOpacity(0.9),
                    blurRadius: 35,
                    spreadRadius: 12,
                  ),
                  BoxShadow(
                    color: AppColors.shadow.withOpacity(0.15),
                    blurRadius: 45,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: ShaderMask(
                blendMode: BlendMode.dstIn,
                shaderCallback: (Rect bounds) {
                  return const RadialGradient(
                    center: Alignment.center,
                    radius: 0.85,
                    colors: [Colors.white, Colors.white, Colors.transparent],
                    stops: [0.0, 0.65, 1.0],
                  ).createShader(bounds);
                },
                child: Image.asset(
                  AppAssets.splashViewBg,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // App logo
            Positioned(
              top: 5.h,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  SizedBox(height: 10.h),
                  Image.asset(AppAssets.splashViewLogo, height: 15.h, fit: BoxFit.contain),
                  const SizedBox(height: 8),
                  AppText(
                    'app_name'.tr,
                    fontSize: 31,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryColor,
                    letterSpacing: 1,
                  ),
                  const SizedBox(height: 3),
                  AppText(
                    'Your Islamic Companion'.tr,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondaryText,
                  ),
                ],
              ),
            ),

            // Bottom caption
            Positioned(
              left: 0,
              right: 0,
              bottom: 1.h,
              child: Column(
                children: [
                  AppText(
                    'Guidance for'.tr,
                    fontSize: 12,
                    color: AppColors.secondaryText,
                  ),
                  AppText(
                    'a better tomorrow'.tr,
                    fontSize: 12,
                    color: AppColors.secondaryText,
                  ),
                ],
              ),
            ),

            // Optional decorative gold border around screen
            Positioned.fill(
              child: IgnorePointer(
                child: Container(
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.border, width: 1.2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
