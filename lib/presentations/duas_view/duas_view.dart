import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qalbi/enums/enum.dart';
import 'package:qalbi/presentations/export.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_text.dart';
import '../../widgets/custom_appbar.dart';
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
                      final items = controller.filteredDuas;

                      if (items.isEmpty) {
                        return SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(
                            child: Text(
                              'No supplications found'.tr,
                              style: TextStyle(
                                color: secondaryText,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        );
                      }

                      return SliverPadding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              return _buildDuaTile(items[index]);
                            },
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
                duration: const Duration(milliseconds: 180),
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.symmetric(
                  horizontal: 19,
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
    return GestureDetector(
      onTap: () {
        controller.selectCategory('Morning');
      },
      child: Container(
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
                          'Morning Adhkar'.tr,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '12 supplications'.tr,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
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
                ],
              ),
            ),
          ],
        ),
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
        Icon(
          Icons.tune_rounded,
          color: green,
          size: 21,
        ),
      ],
    );
  }

  Widget _buildDuaTile(DuaModel dua) {
    return InkWell(
      onTap: () => controller.openDua(dua),
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
                _iconFor(dua.iconKey),
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
        return Icons.nightlight_outlined;
      default:
        return Icons.auto_awesome_outlined;
    }
  }
}
