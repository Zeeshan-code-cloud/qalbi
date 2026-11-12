import 'package:flutter_svg/flutter_svg.dart';
import 'package:qalbi/presentations/export.dart';
import 'package:qalbi/presentations/offline_access/offline_access_controller.dart';
import 'package:qalbi/widgets/custom_appbar.dart';

class OfflineAccesView extends GetView<OfflineAccessController> {
  const OfflineAccesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppCustomBar(
        title: 'Offline Access'.tr,
        onBack: Get.back,
      ),
      body: SafeArea(
        child: Obx(() {
          final sections = controller.sections;
          final hasContent = sections.any((section) => section.items.isNotEmpty);

          return RefreshIndicator(
            onRefresh: () async => controller.refreshCachedContent(),
            color: AppColors.primaryColor,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              children: [
                _buildSummaryCard(controller.totalItems),
                SizedBox(height: 2.h),
                if (!hasContent)
                  _buildEmptyState()
                else
                  ...sections.map(_buildSection),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSummaryCard(int count) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 13.w,
            height: 13.w,
            decoration: BoxDecoration(
              color: AppColors.lightSurface.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(Icons.offline_pin_rounded, color: AppColors.goldLight),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  'Available offline'.tr,
                  type: AppTextType.bodyBold,
                  color: Colors.white,
                ),
                SizedBox(height: 0.5.h),
                AppText(
                  '$count undefined',
                  type: AppTextType.caption,
                  color: Colors.white70,
                ),
              ],
            ),
          ),
          Icon(Icons.wifi_off_rounded, color: AppColors.goldLight),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      margin: EdgeInsets.only(top: 3.h),
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(Icons.cloud_download_outlined, size: 42, color: AppColors.primaryColor),
          SizedBox(height: 1.5.h),
          AppText(
            'Nothing saved offline yet'.tr,
            type: AppTextType.bodyBold,
            color: AppColors.text,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 1.h),
          AppText(
            'Open Surahs, Juz, Duas, or Adhkar while online. They will appear here for offline reading.'.tr,
            type: AppTextType.body,
            color: AppColors.secondaryText,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSection(OfflineContentSection section) {
    final icon = switch (section.icon) {
      'book' => AppAssets.surahIcons,
      'juz' => AppAssets.juzIcon,
      'dua' => AppAssets.duaIcon,
      _  => AppAssets.adhkarIcon,
    };

    return Container(
      margin: EdgeInsets.only(bottom: 1.5.h),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Theme(
        data: Theme.of(Get.context!).copyWith(
          dividerColor: Colors.transparent,
          splashColor: AppColors.prayerHighlight,
        ),
        child: ExpansionTile(
          leading: SvgPicture.asset(icon, color: AppColors.primaryColor, width: 12.w,),
          title: AppText(
            section.title.tr,
            type: AppTextType.bodyBold,
            color: AppColors.text,
          ),
          subtitle: AppText(
            '${section.items.length} undefined',
            type: AppTextType.caption,
            color: AppColors.secondaryText,
          ),
          children: section.items.isEmpty
              ? [
                  Padding(
                    padding: EdgeInsets.fromLTRB(5.w, 0, 5.w, 2.h),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: AppText(
                        'Nothing from this section is cached yet.'.tr,
                        type: AppTextType.caption,
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ),
                ]
              : section.items.map(_buildItem).toList(),
        ),
      ),
    );
  }

  Widget _buildItem(OfflineContentItem item) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 0.3.h),
      title: AppText(
        item.title,
        type: AppTextType.bodyBold,
        color: AppColors.text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: item.subtitle.isEmpty
          ? null
          : AppText(
              item.subtitle,
              type: AppTextType.caption,
              color: AppColors.secondaryText,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
      trailing: Icon(Icons.chevron_right_rounded, color: AppColors.secondaryText),
      onTap: () => _showCachedItem(item),
    );
  }

  void _showCachedItem(OfflineContentItem item) {
    Get.dialog(
      Dialog(
        backgroundColor: AppColors.card,
        insetPadding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 4.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        child: SizedBox(
          height: 78.h,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(5.w, 2.h, 3.w, 1.h),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            item.title,
                            type: AppTextType.bodyBold,
                            color: AppColors.text,
                          ),
                          if (item.subtitle.isNotEmpty)
                            AppText(
                              item.subtitle,
                              type: AppTextType.caption,
                              color: AppColors.secondaryText,
                            ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: Get.back,
                      icon: Icon(Icons.close_rounded, color: AppColors.icon),
                    ),
                  ],
                ),
              ),
              Divider(color: AppColors.divider, height: 1),
              Expanded(
                child: item.blocks.isEmpty
                    ? Center(
                        child: Padding(
                          padding: EdgeInsets.all(6.w),
                          child: AppText(
                            'This cached item has no readable text.'.tr,
                            color: AppColors.secondaryText,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding: EdgeInsets.all(5.w),
                        itemCount: item.blocks.length,
                        separatorBuilder: (_, index) => Divider(
                          height: 3.h,
                          color: AppColors.divider,
                        ),
                        itemBuilder: (context, index) =>
                            _buildTextBlock(item.blocks[index]),
                      ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }

  Widget _buildTextBlock(OfflineTextBlock block) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (block.metadata.isNotEmpty) ...[
          AppText(
            block.metadata,
            type: AppTextType.caption,
            color: AppColors.secondaryText,
          ),
          SizedBox(height: 0.8.h),
        ],
        if (block.arabic.isNotEmpty)
          AppText(
            block.arabic,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
            fontSize: 23,
            color: AppColors.text,
          ),
        if (block.translation.isNotEmpty) ...[
          SizedBox(height: 1.h),
          AppText(
            block.translation,
            color: AppColors.text,
            textDirection: TextDirection.ltr,
          ),
        ],
        if (block.reference.isNotEmpty) ...[
          SizedBox(height: 0.7.h),
          AppText(
            block.reference,
            type: AppTextType.caption,
            color: AppColors.secondaryText,
          ),
        ],
      ],
    );
  }
}
