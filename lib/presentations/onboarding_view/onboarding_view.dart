import '../export.dart';
import 'onboarding_model.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              SizedBox(
                height: 70.h,
                child: PageView.builder(
                  controller: controller.pageC,
                  itemCount: controller.onboardingList.length,
                  physics: const BouncingScrollPhysics(),
                  reverse: false,
                  onPageChanged: (index) {
                    controller.setIndex(index);
                  },
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return onboardingWidget(controller.onboardingList[index]);
                  },
                ),
              ),
              SizedBox(height: 4.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Wrap(
                      children: List.generate(controller.onboardingList.length, (index) {
                        return Obx(() {
                          final selected = controller.currentIndex.value == index;

                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 320),
                            margin: EdgeInsets.symmetric(horizontal: 2.w),
                            width: selected ? 6.w : 4.w,
                            height: 2.h,
                            decoration: BoxDecoration(
                              border: BoxBorder.all(
                                color: selected ? AppColors.accent : AppColors.border,
                              ),
                              shape: BoxShape.circle,
                              color: selected ? AppColors.accent : AppColors.card,
                            ),
                          );
                        });
                      }),
                    ),
                    GestureDetector(
                      onTap: controller.nextPage,
                      child: Container(
                        height: 12.h,
                        width: 12.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryColor,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.arrow_forward_rounded,
                            color: AppColors.onPrimary,
                          ),
                        ),
                      ),
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

  Widget onboardingWidget(OnboardingModel model) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 65.h,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(model.images),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 67.h,
          child: Container(
            width: 100.w,
            height: 40.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.background,
                  blurRadius: 55,
                  spreadRadius: 160,
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 55.h,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 4.h),
                SizedBox(
                  width: 55.w,
                  child: AppText(
                    textAlign: TextAlign.start,
                    model.titles.tr,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
                SizedBox(height: 1.h),
                SizedBox(
                  width: 60.w,
                  child: AppText(
                    model.captions.tr,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.secondaryText,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
