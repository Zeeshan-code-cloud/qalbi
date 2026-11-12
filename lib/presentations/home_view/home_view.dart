import 'package:flutter_svg/flutter_svg.dart';
import 'package:qalbi/enums/enum.dart';
import 'package:qalbi/presentations/export.dart';
import 'package:qalbi/presentations/home_view/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: AppColors.background,
        body: Stack(
          children: [
            Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 27.h,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(AppAssets.homeScreenBanner),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                SizedBox(height: 9.h),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 1.w),
                  itemCount: controller.features.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 1.w,
                    mainAxisSpacing: 0.3.h,
                    childAspectRatio: 1.02,
                  ),
                  itemBuilder: (context, index) {
                    return _buildFeatureTile(controller.features[index]);
                  },
                ),
                SizedBox(height: 0.2.h),
                quoteSlider(),
              ],
            ),
            Positioned(
              top: 6.h,
              left: 5.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    "welcome".tr,
                    color: AppColors.lightSurface,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  SizedBox(height: 0.1.h),
                  Row(
                    children: [
                      Obx(
                        () => AppText(
                          controller.welcomeMessage.tr,
                          color: AppColors.goldLight,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                      SizedBox(width: 1.w),
                      Icon(
                        controller.welcomeMessage == "Good Morning"
                            ? Icons.light_mode_outlined
                            : controller.welcomeMessage == "Good Afternoon"
                            ? Icons.light_mode
                            : controller.welcomeMessage == "Good Evening"
                            ? Icons.dark_mode
                            : Icons.nightlight_round,
                        color: AppColors.goldLight,
                        size: 20,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              right: 3.w,
              top: 2.h,
              child: GestureDetector(
                onTap: () {
                  Get.toNamed(Routes.settingView);
                },
                child: SvgPicture.asset(
                  AppAssets.settingIcon,
                  height: 4.h,
                  colorFilter: ColorFilter.mode(
                    AppColors.lightGold,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 15.h,
              child: Container(
                width: 98.w,
                height: 22.h,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(AppAssets.nextPrayerImage),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 20.h,
              left: 4.w,
              child: Row(
                children: [
                  Column(
                    children: [
                      Icon(
                        Icons.mosque_rounded,
                        color: AppColors.goldLight,
                        size: 8.w,
                      ),
                      Container(
                        width: 8.w,
                        height: 0.3.h,
                        color: AppColors.goldLight,
                      ),
                    ],
                  ),
                  SizedBox(width: 3.w),
                  Padding(
                    padding: EdgeInsets.only(left: 2.w),
                    child: Column(
                      children: [
                        AppText(
                          "next_prayers".tr,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkText,
                        ),
                        SizedBox(height: 0.1.h),
                        AppText(
                          controller.nextPrayerName.tr,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkText,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 26.h,
              left: 5.w,
              child: Row(
                children: [
                  Column(
                    children: [
                      AppText(
                        controller.nextPrayerTime,
                        fontSize: 23.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.goldLight,
                      ),
                      SizedBox(height: 0.1.h),
                      Row(
                        children: [
                          Icon(
                            Icons.timelapse_rounded,
                            color: AppColors.goldLight,
                            size: 4.w,
                          ),
                          AppText(
                            controller.countdownText,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkText,
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(width: 2.w),
                  Container(
                    width: 0.6.w,
                    height: 8.h,
                    color: AppColors.goldLight.withOpacity(0.5),
                  ),
                  SizedBox(width: 1.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Row(
                          children: [
                            AppText(
                              "today_prayer_times".tr,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkText,
                            ),
                            SizedBox(width: 1.w),
                            Icon(
                              Icons.arrow_forward_rounded,
                              color: AppColors.goldLight,
                              size: 15,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 0.3.h),
                      Container(
                        decoration: BoxDecoration(
                          border: BoxBorder.fromLTRB(
                            top: BorderSide(
                              color: AppColors.goldLight.withOpacity(0.6),
                            ),
                            right: BorderSide.none,
                            bottom: BorderSide.none,
                            left: BorderSide.none,
                          ),
                        ),
                        child: Row(
                          children: List.generate(controller.prayers.length, (
                            index,
                          ) {
                            return Container(
                              margin: EdgeInsets.only(top: 1.h),
                              padding: EdgeInsets.all(1.w),
                              decoration: BoxDecoration(
                                border: BoxBorder.fromLTRB(
                                  left: BorderSide(
                                    color: AppColors.goldLight.withOpacity(0.6),
                                  ),
                                  right: BorderSide.none,
                                  bottom: BorderSide.none,
                                  top: BorderSide.none,
                                ),
                              ),
                              child: Column(
                                children: [
                                  AppText(
                                    controller.prayers[index].prayerName.tr,
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.darkText,
                                  ),
                                  SizedBox(height: 0.1.h),
                                  AppText(
                                    controller.prayers[index].time,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.darkText,
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureTile(HomeFeatureModel feature) {
    return GestureDetector(
      onTap: () {
        if (feature.title == "Dark Mode") {
          controller.themeC.toggledTheme();
          return;
        }

        if (feature.title == "Multiple Language") {
          Get.dialog(
            AlertDialog(
              title: Text("Choose Your Language".tr),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _languageOption('🇺🇸', 'English'),
                  _languageOption('🇵🇰', 'Urdu'),
                  _languageOption('🇸🇦', 'Arabic'),
                ],
              ),
            ),
          );
          return;
        }
        if (feature.route.isNotEmpty) {
          Get.toNamed(feature.route, arguments: NavType.fromHomeTile);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 1.w),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(17),
          border: Border.all(color: AppColors.border, width: 0.9),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withOpacity(0.1),
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 0.8.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 7.h,
                    child: Center(
                      child:Image.asset(feature.iconPath, fit: BoxFit.contain),
                    ),
                  ),
                  SizedBox(height: 0.3.h),
                  AppText(
                    feature.title.tr,
                    color: AppColors.primaryColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 0.1.h),
                  AppText(
                    feature.subtitle.tr,
                    color: AppColors.secondaryText,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _languageOption(String flag, String language) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Text(flag, style: const TextStyle(fontSize: 24)),
      title: Text(language),
      onTap: () async {
        await controller.selectLanguage(language);
        Get.back();
      },
    );
  }

  Widget quoteSlider() {
    return Container(
      margin: EdgeInsets.all(1.w),
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      height: 7.h,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppAssets.islamicQuoteBanner),
          fit: BoxFit.cover,
        ),
        border: BoxBorder.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: PageView.builder(
        controller: controller.pageController,
        itemCount: controller.quotes.length,
        onPageChanged: controller.onPageChanged,
        itemBuilder: (context, index) {
          final quote = controller.quotes[index];

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppText(
                quote.quote.tr,
                color: AppColors.primaryColor,
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 0.1.h),
              AppText(
                quote.reference,
                color: AppColors.primaryColor,
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          );
        },
      ),
    );
  }
}
