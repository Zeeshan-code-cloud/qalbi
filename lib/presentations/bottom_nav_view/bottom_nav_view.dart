import 'package:qalbi/widgets/custom_dialog.dart';

import '../export.dart';

class BottomNavView extends GetView<BottomNavController> {
  const BottomNavView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result){
        if(didPop){
          return;
        }
        ShowCustomDialog.showCustomDialog(
          context: context,
          icon: Icons.exit_to_app_rounded,
          iconColor: Colors.orange,
          title: "Exit App?",
          content: "Are you sure you want to close the application?",
          cancelText: "Stay",
          confirmText: "Exit",
          confirmButtonColor: Colors.orange,
          confirmTextColor: Colors.white,
          onConfirm: () {
            Navigator.pop(context);
            SystemNavigator.pop();
          },
        );

      },

      child: Scaffold(
        body: Obx(() => controller.pages[controller.currentIndex.value]),

        bottomNavigationBar: Obx(
                () {
              return Container(
                margin: EdgeInsets.all(1.w),
                padding: EdgeInsets.symmetric(
                  horizontal: 0.w,
                 ),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  border: BoxBorder.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(12),

                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _navItem(
                      index: 0,
                      title: "home".tr,
                      icon: AppAssets.homeImage,
                    ),
                    _navItem(
                      index: 1,
                      title: "quran".tr,
                      icon: AppAssets.quranIcon,
                    ),
                    _navItem(
                      index: 2,
                      title: "duas".tr,
                      icon: AppAssets.duasIcon,
                    ),
                    _navItem(
                      index: 3,
                      title: "calender".tr,
                      icon: AppAssets.calenderIcon,
                    ),
                    _navItem(
                      index: 4,
                      title: "more".tr,
                      icon: AppAssets.moreIcon,
                    ),
                  ],
                ),
              );
            }
        ),
      ),
    );
  }

  Widget _navItem({
    required int index,
    required String title,
    required String icon,
  }) {
    final bool isSelected = controller.currentIndex.value == index;

    return GestureDetector(
      onTap: () {
        controller.currentIndex.value = index;
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 1.4.w,
          vertical: 1.h,
        ),

        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(

              child: Image.asset(
                icon,
                height: 3.3.h,
                width: 4.0.h,
                color:    AppColors.icon  ,
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(height: .3.h),

            AppText(
              title,
              type: AppTextType.micro,
              color: isSelected
                  ? AppColors.icon
                  : AppColors.secondary,
              fontWeight: isSelected
                  ? FontWeight.w600
                  : FontWeight.w400,
            ),
            SizedBox(height: .2.h),
            isSelected ? Container(
              width: 5.w,
              height: 0.3.h,
              color: AppColors.icon,
            ) : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
