import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qalbi/presentations/export.dart';

class AppCustomBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack;
  final VoidCallback? onActionTap;
  final IconData? actionIcon;
  final Widget? leading;
  final Widget? action;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double height;
  final bool showBackButton;
  final bool centerTitle;

  const AppCustomBar({
    super.key,
    required this.title,
    this.onBack,
    this.onActionTap,
    this.actionIcon,
    this.leading,
    this.action,
    this.backgroundColor,
    this.foregroundColor,
    this.height = 56,
    this.showBackButton = true,
    this.centerTitle = true,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    final effectiveBg = backgroundColor ?? AppColors.background;
    final effectiveFg = foregroundColor ?? AppColors.text;

    return AppBar(
      backgroundColor: effectiveBg,
      foregroundColor: effectiveFg,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      toolbarHeight: height,
      centerTitle: centerTitle,
      automaticallyImplyLeading: false,
      leadingWidth: 56,
      leading: leading ??
          (showBackButton
              ? IconButton(
            onPressed: onBack ?? Get.back,
            icon: Icon(
              Icons.arrow_back,
              size: 30,
              color: AppColors.primaryColor,
            ),
          )
              : null),
      title: Text(
        title,
        style: TextStyle(
          color: effectiveFg,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
      ),
      actions: [
        if (action != null)
          action!
        else if (actionIcon != null)
          IconButton(
            onPressed: onActionTap,
            icon: Icon(actionIcon, size: 30, color: AppColors.primaryColor),
          )
        else
          const SizedBox(width: 56),
      ],
    );
  }
}