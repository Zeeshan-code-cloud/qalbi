import 'package:flutter_svg/svg.dart';
 import 'package:qalbi/enums/enum.dart';
import 'package:qalbi/presentations/export.dart';
import 'package:qalbi/presentations/holy_quran/repository/surah_entity.dart';
import 'package:qalbi/widgets/custom_appbar.dart';

import 'holly_quran_controller.dart';

class HolyQuranVew extends GetView<HollyQuranController> {
  const HolyQuranVew({super.key});

  @override
  Widget build(BuildContext context) {
    final navType = Get.arguments;
    return Obx(
      () => Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppCustomBar(
          leading: navType == NavType.fromHomeTile
              ? IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(Icons.arrow_back, color: AppColors.primaryColor),
                )
              : const SizedBox.shrink(),
          title: "Holy Quran".tr,
          backgroundColor: Colors.transparent,
          actionIcon: Icons.search_rounded,
          onActionTap: () {
            controller.isSearching.value = !controller.isSearching.value;
          },
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),

                // Search
                if (controller.isSearching.value)
                  Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: TextField(
                      controller: controller.searchController,
                      onChanged: controller.onSearchChanged,
                      onTapOutside: (vale) {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      decoration: InputDecoration(
                        hintText: 'Search Surah...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: Obx(() {
                          if (controller.searchQuery.isEmpty) {
                            return const SizedBox.shrink();
                          }

                          return IconButton(
                            onPressed: controller.clearSearch,
                            icon: const Icon(Icons.close),
                          );
                        }),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  )
                else
                  const SizedBox(height: 10),

                // Tabs
                buildTabs(),

                const SizedBox(height: 18),

                // Content
                Expanded(
                  child: Obx(() {
                    switch (controller.selectedTab.value) {
                      case 0:
                        return buildSurahList();
                      case 1:
                        return buildJuzList();
                      default:
                        return buildBookmarksList();
                    }
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildJuzList() {
    return Obx(() {
      if (controller.juzFetching.value) {
        return Center(child: CircularProgressIndicator());
      }
      return ListView.separated(
        itemBuilder: (context, index) {
          final juz = controller.allJuz[index];
          return ListTile(
            leading: CircleAvatar(
              child: AppText(
                juz.juzNumber.toString(),
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
                fontSize: 20,
              ),
            ),
            title: AppText('Juz ${juz.juzNumber}'),
            subtitle: AppText(juz.juzArabicName),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              controller.fetchJuzDetails(juz.juzNumber);
            },
          );
        },
        separatorBuilder: (_, __) => SizedBox(height: 2.h),
        itemCount: controller.allJuz.length,
      );
    });
  }

  Widget buildTabs() {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: List.generate(controller.tabs.length, (index) {
          final selected = controller.selectedTab.value == index;

          return Expanded(
            child: GestureDetector(
              onTap: () => controller.selectTab(index),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: AppText(
                      controller.tabs[index].tr,
                      fontSize: 16.sp,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                      color: selected
                          ? AppColors.primaryColor
                          : AppColors.secondaryText,
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    height: 2.5,
                    width: selected ? 32 : 0,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget buildSurahList() {
    return Obx(() {
      if (controller.allSurahFetching.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final surahs = controller.filteredSurah;

      if (surahs.isEmpty) {
        return Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(AppAssets.searchNotFound, height: 8.h,),
              SizedBox(height: 2.h,),
              AppText(
                'No Surahs found'.tr,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.secondaryText,
              ),
            ],
          ),
        );
      }

      return ListView.separated(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.only(bottom: 20, top: 2),
        itemCount: surahs.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final surah = surahs[index];
          final bookmarked = controller.isBookmarked(surah.number);

          return Dismissible(
            key: ValueKey('surah_${surah.number}'),
            direction: DismissDirection.startToEnd, // right se left
            confirmDismiss: (_) async {
              controller.adToBookmark(surah.number);
              Get.snackbar(
                "Surah added",
                "Surah are added to bookmark",
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 24),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(
                bookmarked ? Icons.bookmark_remove : Icons.bookmark_add,
                color: Colors.white,
                size: 28,
              ),
            ),
            child: SurahTile(
              surah: surah,
              onTap: () => controller.fetchSurah(surah.number),
            ),
          );
        },
      );
    });
  }

  Widget buildBookmarksList() {
    return Obx(() {
      final items = controller.bookmarkedSurahs;

      if (items.isEmpty) {
        return Center(
          child: AppText(
            'No bookmarks yet\nSwipe a surah from right to left'.tr,
            textAlign: TextAlign.center,
            color: AppColors.secondaryText,
          ),
        );
      }

      return ListView.separated(
        padding: const EdgeInsets.only(bottom: 20, top: 2),
        itemCount: items.length,
        separatorBuilder: (_, __) => SizedBox(height: 12),
        itemBuilder: (context, i) => Dismissible(
          key: ValueKey('surah_${items[i].number}'),
          direction: DismissDirection.endToStart, // right se left
          confirmDismiss: (_) async {
            controller.removeFromBookmark(items[i].number);
            Get.snackbar(
              "Surah Removed",
              "Surah are removed from  bookmark",
              snackPosition: SnackPosition.BOTTOM,
            );
          },
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 24),
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          child: SurahTile(
            surah: items[i],
            onTap: () => controller.fetchSurah(items[i].number),
          ),
        ),
      );
    });
  }
}

class SurahTile extends StatelessWidget {
  final SurahEntity surah;
  final VoidCallback onTap;

  const SurahTile({super.key, required this.surah, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.card,
            image: AppColors.isDark
                ? null
                : DecorationImage(
                    image: AssetImage(AppAssets.surahTiles),
                    fit: BoxFit.fitWidth,
                  ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.border.withOpacity(0.5)),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow.withOpacity(0.045),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.inputFill,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.border.withOpacity(0.3)),
                ),
                child: AppText(
                  '${surah.number}',
                  type: AppTextType.bodyBold,
                  fontSize: 15,
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      surah.name.tr,
                      type: AppTextType.heading1,
                      fontSize: 14,
                      color: AppColors.text,
                    ),
                    const SizedBox(height: 5),
                    AppText(
                      '${surah.number} ${'verses'.tr}  |  '
                      '${surah.revelationType.tr}',
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                      color: AppColors.secondaryText,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                surah.englishNameTranslation,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontFamily: 'Amiri',
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

