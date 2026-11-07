
 import '../presentations/export.dart';
import '../utils/app_buttons.dart';

class ShowCustomDialog {
  static  Future<void> showCustomDialog({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String content,
    required VoidCallback onConfirm,

    VoidCallback? onCancel,

    String cancelText = "Cancel",
    String confirmText = "Confirm",

    Color iconColor = Colors.red,
    Color? cancelButtonColor,
    Color? confirmButtonColor,

    Color? cancelTextColor,
    Color? confirmTextColor,

    bool barrierDismissible = true,
  }) async {
    return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(5.w),
            decoration: BoxDecoration(
              gradient: AppColors.goldGradient,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: AppColors.border,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// Icon
                Container(
                  height: 8.h,
                  width: 8.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: iconColor.withOpacity(.15),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 32.sp,
                  ),
                ),

                SizedBox(height: 2.h),

                /// Title
                AppText(
                  title,
                  type: AppTextType.heading3,
                  color: AppColors.primary,
                ),

                SizedBox(height: 1.h),

                /// Content
                AppText(
                  content,
                  textAlign: TextAlign.center,
                  type: AppTextType.body,
                  color: AppColors.secondaryText,
                ),

                SizedBox(height: 3.h),

                /// Buttons
                Row(
                  children: [
                    Expanded(
                      child: AppButtonWidget(
                        text: cancelText,
                        height: 6.h,
                        radius: 16,
                        buttonColor:
                        cancelButtonColor ?? AppColors.error,
                        borderColor: AppColors.border,
                        textColor:
                        cancelTextColor ?? AppColors.text,
                        onPressed: () {
                          Navigator.pop(dialogContext);

                          if (onCancel != null) {
                            onCancel();
                          }
                        },
                      ),
                    ),

                    SizedBox(width: 3.w),

                    Expanded(
                      child: AppButtonWidget(
                        text: confirmText,
                        height: 6.h,
                        radius: 16,
                        buttonColor:
                        confirmButtonColor ?? AppColors.primary,
                        textColor:
                        confirmTextColor ?? AppColors.primary,
                        onPressed: onConfirm,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}