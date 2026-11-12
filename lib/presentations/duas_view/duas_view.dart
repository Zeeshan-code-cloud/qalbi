
import 'dart:ui';
import 'package:flutter_svg/svg.dart';
import 'package:qalbi/enums/enum.dart';
import 'package:qalbi/presentations/export.dart';
import '../../widgets/custom_appbar.dart';
import 'domain/adhkar_entity.dart';
import 'domain/duas_entity.dart';
import 'duas_controller.dart';

class DuasView extends GetView<DuasController> {
  DuasView({super.key});

  Color get cream => AppColors.goldLight;
  Color get secondaryText => AppColors.secondaryText;
  Color get green => AppColors.primaryColor;
  Color get mutedGreen => AppColors.secondaryText;

  @override
  Widget build(BuildContext context) {
    final navType = Get.arguments;
    return Obx(
      () => Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppCustomBar(
          backgroundColor: Colors.transparent,
          title: 'Duas & Adhkar'.tr,
          leading: navType == NavType.fromHomeTile
              ? IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(Icons.arrow_back, color: AppColors.primaryColor),
                )
              : const SizedBox.shrink(),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: CustomScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTabs(),
                            const SizedBox(height: 18),
                            _buildSearchField(),
                            const SizedBox(height: 18),
                            _buildCategories(),
                            const SizedBox(height: 20),
                            _buildFeaturedCard(),
                            const SizedBox(height: 22),
                            _buildSectionHeader(),
                          ],
                        ),
                      ),
                    ),
                    Obx(() {
                      if (controller.selectedTab.value.toLowerCase() == 'adhkar') {
                        if (controller.dhikrFetching.value) {
                          return const SliverFillRemaining(
                            hasScrollBody: false,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        final items = controller.filteredDhikr;
                        if (items.isEmpty) {
                          return _emptyResults('No adhkar found'.tr);
                        }

                        return SliverPadding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) => _buildDhikrTile(items[index]),
                              childCount: items.length,
                            ),
                          ),
                        );
                      }

                      final items = controller.filteredDuas;
                      if (controller.duaFetching.value) {
                        return const SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      if (items.isEmpty) {
                        return _emptyResults('No supplications found'.tr);
                      }

                      return SliverPadding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) => _buildDuaTile(items[index]),
                            childCount: items.length,
                          ),
                        ),
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

  Widget _buildTabs() {
    return Obx(
      () => Row(
        children: controller.tabs.map((tab) {
          final selected = controller.selectedTab.value == tab;

          return Expanded(
            child: GestureDetector(
              onTap: () => controller.selectTab(tab),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                margin: const EdgeInsets.only(right: 6),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: selected
                      ? AppColors.card
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: selected
                        ? AppColors.border
                        : Colors.transparent,
                  ),
                  boxShadow: selected
                      ? [
                          BoxShadow(
                            color: AppColors.shadow.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      : [],
                ),
                child: Center(
                  child: AppText(
                    tab.tr,
                    type: selected
                        ? AppTextType.body
                        : AppTextType.captionDark,
                    color: selected ? AppColors.primaryColor : secondaryText,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.search_rounded,
            size: 23,
            color: green,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller.searchController,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.text,
              ),
              decoration: InputDecoration(
                hintText: 'Search duas and adhkar...'.tr,
                hintStyle: TextStyle(
                  color: secondaryText,
                  fontSize: 13,
                ),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          Obx(
            () => controller.searchQuery.value.isNotEmpty
                ? GestureDetector(
                    onTap: controller.searchController.clear,
                    child: Icon(
                      Icons.close_rounded,
                      size: 19,
                      color: secondaryText,
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories() {
    return Obx(
      () => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
           children: controller.categories.map((category) {
            final selected = controller.selectedCategory.value == category;

            return GestureDetector(
              onTap: () => controller.selectCategory(category),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                margin: const EdgeInsets.only(right: 10),
                padding:   EdgeInsets.symmetric(
                  horizontal: 7.w,
                  vertical: 11,
                ),
                decoration: BoxDecoration(
                  color: selected ? AppColors.accent : AppColors.card,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: selected
                        ? AppColors.border
                        : AppColors.border,
                  ),
                ),
                child: AppText(
                  category.tr,
                  type: AppTextType.body,
                  color: selected
                      ? (AppColors.isDark ? AppColors.darkBackground : Colors.white)
                      : AppColors.text,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildFeaturedCard() {
    return Container(
      height: 154,
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE4D1AE),
          width: 1,
        ),
        image: DecorationImage(
          image: AssetImage(
            AppAssets.homeScreenBanner,
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.72),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 18,
            right: 16,
            bottom: 17,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${controller.selectedCategory.value} Adhkar'.tr,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${controller.filteredDuas.length} supplications'.tr,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: controller.changeCategory,
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: green,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Row(
      children: [
        Expanded(
          child: AppText(
            'Daily Supplications'.tr,
            type: AppTextType.heading4,
            color: AppColors.text,
          ),
        ),

      ],
    );
  }

  Widget _emptyResults(String message) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(AppAssets.searchNotFound, height: 7.h),
            SizedBox(height: 4.h),
            Text(message, style: TextStyle(color: secondaryText, fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Widget _buildDhikrTile(AdhkarEntity dhikr) {
    return InkWell(
      onTap: () => _showDhikrDialog(dhikr),
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.divider, width: 0.8),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: AppColors.goldGradient,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.auto_awesome_outlined,
                color: AppColors.icon,
                size: 22,
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    'Dhikr ${dhikr.id}',
                    type: AppTextType.bodyBold,
                    color: AppColors.text,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dhikr.arabic,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(fontSize: 15, color: secondaryText),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '× ${dhikr.repeatCount}',
              style: TextStyle(
                color: secondaryText,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right_rounded, color: secondaryText),
          ],
        ),
      ),
    );
  }

  void _showDhikrDialog(AdhkarEntity dhikr) {
    _showRecitationDialog(
      arabic: dhikr.arabic,
      translation: dhikr.translation,
      reference: dhikr.reference,
      repeatCount: dhikr.repeatCount,
    );
  }

  void _showDuaDialog(DuaEntity dua) {
    _showRecitationDialog(
      arabic: dua.arabic,
      translation: dua.translation,
      reference: dua.reference,
    );
  }

  void _showRecitationDialog({
    required String arabic,
    required String translation,
    required String reference,
    int? repeatCount,
  }) {
    Get.dialog<void>(
      Dialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              width: double.infinity,
              height: 60.h,
              decoration: BoxDecoration(
                color: AppColors.background.withValues(alpha: 0.94),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.18),
                    blurRadius: 28,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 16, 22, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Read and recite'.tr,
                            style: TextStyle(
                              color: AppColors.text,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Get.back<void>(),
                          icon: Icon(Icons.close, color: AppColors.text),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      arabic,
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        color: AppColors.text,
                        fontSize: 28,
                        height: 2,
                        fontFamily: 'Amiri',
                      ),
                    ),
                    if (translation.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      Text(
                        translation,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: secondaryText,
                          fontSize: 15,
                          height: 1.5,
                        ),
                      ),
                    ],
                    if (repeatCount != null) ...[
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Text(
                          '${'Repeat'.tr}: $repeatCount',
                          style: TextStyle(
                            color: AppColors.text,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                    if (reference.isNotEmpty) ...[
                      const SizedBox(height: 14),
                      Text(
                        reference,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: secondaryText, fontSize: 12),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.45),
    );
  }

  Widget _buildDuaTile(DuaEntity dua) {
    return InkWell(
      onTap: () => _showDuaDialog(dua),
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: AppColors.divider,
              width: 0.8,
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: AppColors.goldGradient,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _iconFor(dua.category.toString()),
                color: AppColors.icon,
                size: 22,
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    dua.title.tr,
                    type: AppTextType.bodyBold,
                    color: AppColors.text,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dua.translation.tr,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: secondaryText,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              visualDensity: VisualDensity.compact,
              onPressed: () => controller.toggleFavorite(dua),
              icon: Obx(
                () => Icon(
                  controller.isFavorite(dua)
                      ? Icons.favorite_rounded
                      : Icons.favorite_border,
                  color: controller.isFavorite(dua)
                      ? const Color(0xFFB66A56)
                      : secondaryText,
                  size: 23,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconFor(String key) {
    switch (key) {
      case 'protection':
        return Icons.shield_moon_outlined;
      case 'guidance':
        return Icons.spa_outlined;
      case 'knowledge':
        return Icons.menu_book_outlined;
      case 'forgiveness':
        return Icons.volunteer_activism_outlined;
      case 'provision':
        return Icons.water_drop_outlined;
      case 'sleep':
        return Icons.bed;
     case 'morning':
        return Icons.sunny;
     case 'evening':
        return Icons.nightlight_rounded;
      default:
        return Icons.auto_awesome_outlined;
    }
  }
}
