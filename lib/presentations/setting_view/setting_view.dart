import 'package:qalbi/presentations/export.dart';
import 'package:qalbi/presentations/setting_view/setting_controller.dart';

import '../../widgets/custom_appbar.dart';

class SettingView extends GetView<SettingController> {
  const SettingView({super.key});

  Color get cream => AppColors.goldLight;
  Color get green => AppColors.primaryColor;
  Color get muted => AppColors.secondaryText;
  Color get cardColor => AppColors.card;
  Color get dividerColor => AppColors.divider;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppCustomBar(
          title: 'settings'.tr,
          backgroundColor: AppColors.background,
        ),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            children: [
              _sectionTitle('App Preferences'.tr),
              const SizedBox(height: 10),

              _settingsGroup([
                _settingsTile(
                  icon: Icons.language_rounded,
                  title: 'language'.tr,
                  subtitle: () => controller.selectedLanguage.value,
                  onTap: _showLanguageDialog,
                ),
                _settingsTile(
                  icon: Icons.nightlight_round,
                  title: 'Theme'.tr,
                  subtitle: () => controller.selectedTheme.value.tr,
                  onTap: _showThemeDialog,
                ),
                _settingsTile(
                  icon: Icons.settings_outlined,
                  title: 'Prayer Time Calculation'.tr,
                  subtitle: () => controller.prayerCalculationMethod.value,
                  onTap: _showPrayerMethodDialog,
                ),
                _settingsTile(
                  icon: Icons.notifications_rounded,
                  title: 'Notifications'.tr,
                  subtitle: () => 'Adhan, Prayer Reminders'.tr,
                  showDivider: false,
                  onTap: () => Get.toNamed('/notification-settings'),
                ),
              ]),

              const SizedBox(height: 24),
              _sectionTitle('General'.tr),
              const SizedBox(height: 10),

              _settingsGroup([
                _settingsTile(
                  icon: Icons.verified_user_rounded,
                  title: 'Privacy Policy'.tr,
                  onTap: controller.openPrivacyPolicy,
                ),
                _settingsTile(
                  icon: Icons.description_rounded,
                  title: 'Terms and Conditions'.tr,
                  onTap: controller.openTerms,
                ),
                _settingsTile(
                  icon: Icons.star_rounded,
                  title: 'Rate the App'.tr,
                  onTap: controller.rateApp,
                ),
                _settingsTile(
                  icon: Icons.share_rounded,
                  title: 'Share App'.tr,
                  onTap: controller.shareApp,
                ),
                _settingsTile(
                  icon: Icons.headset_mic_rounded,
                  title: 'Contact Support'.tr,
                  showDivider: false,
                  onTap: controller.contactSupport,
                ),
              ]),

              const SizedBox(height: 24),
              _sectionTitle('About'.tr),
              const SizedBox(height: 10),

              _settingsGroup([
                _settingsTile(
                  icon: Icons.info_rounded,
                  title: 'App Version'.tr,
                  trailing: Text(
                    '1.0.0',
                    style: TextStyle(
                      fontSize: 12,
                      color: muted,
                    ),
                  ),
                  showDivider: false,
                  onTap: () {},
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return AppText(
      title,
      type: AppTextType.bodyBold,
      color: AppColors.primaryColor,
    );
  }

  Widget _settingsGroup(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(
          color: dividerColor,
          width: 0.7,
        ),
      ),
      child: Column(children: children),
    );
  }

  Widget _settingsTile({
    required IconData icon,
    required String title,
    String Function()? subtitle,
    required VoidCallback onTap,
    bool showDivider = true,
    Widget? trailing,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 13,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: green,
                  size: 23,
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        title,
                        type: AppTextType.body,
                        color: AppColors.text,
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 3),
                        AppText(
                          subtitle(),
                          type: AppTextType.caption,
                          color: AppColors.secondaryText,
                        ),
                      ],
                    ],
                  ),
                ),
                if (trailing != null)
                  trailing
                else
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 23,
                    color: muted,
                  ),
              ],
            ),
          ),
        ),
        if (showDivider)
          Padding(
            padding: const EdgeInsets.only(left: 58, right: 15),
            child: Divider(
              height: 1,
              thickness: 0.7,
              color: dividerColor,
            ),
          ),
      ],
    );
  }

  // Language selection
  void _showLanguageDialog() {
    _showOptionsDialog(
      title: 'Select Language'.tr,
      options: const [
        'English',
        'اردو',
        'العربية',
      ],
      selected: controller.selectedLanguage.value,
      onSelected: controller.changeLanguage,
    );
  }

  // Theme selection
  void _showThemeDialog() {
    _showOptionsDialog(
      title: 'Choose Theme'.tr,
      options: const [
        'Light',
        'Dark',
      ],
      selected: controller.selectedTheme.value,
      onSelected: controller.changeTheme,
    );
  }

  // Prayer calculation method selection
  void _showPrayerMethodDialog() {
    _showOptionsDialog(
      title: 'Prayer Time Calculation'.tr,
      options: const [
        'Muslim World League',
        'University of Islamic Sciences, Karachi',
        'Egyptian General Authority',
        'Umm Al-Qura University',
        'ISNA',
      ],
      selected: controller.prayerCalculationMethod.value,
      onSelected: controller.changePrayerMethod,
    );
  }

  void _showOptionsDialog({
    required String title,
    required List<String> options,
    required String selected,
    required ValueChanged<String> onSelected,
  }) {
    Get.dialog(
      Dialog(
        backgroundColor: cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: green,
                ),
              ),
              const SizedBox(height: 14),
              ...options.map((option) {
                return RadioListTile<String>(
                  contentPadding: EdgeInsets.zero,
                  activeColor: green,
                  title: Text(
                    option,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.text,
                    ),
                  ),
                  value: option,
                  groupValue: selected,
                  onChanged: (value) {
                    if (value == null) return;
                    onSelected(value);
                    Get.back();
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
