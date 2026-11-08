import 'package:qalbi/enums/enum.dart';
import 'package:qalbi/presentations/export.dart';
 import 'package:qalbi/presentations/holy_quran/repository/surah_entity.dart';
import 'package:qalbi/widgets/custom_appbar.dart';

import '../../utils/app_text_field.dart';
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
            controller.isSearching.value = true;
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
                    padding: const EdgeInsets.only(bottom: 12),
                    child: AppFormField(
                      title: 'Search Surah...'.tr,
                      textColor: AppColors.text,
                      textEditingController: controller.searchController,
                      isFilled: true,
                      filledColor: AppColors.card,
                      showBorder: true,
                      borderColor: AppColors.border,
                      focusedBorderColor: AppColors.primaryColor,
                      icon: Icons.cancel,
                      onTap: () {
                        controller.isSearching.value = false;
                      },
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
                        return Center(
                          child: Text(
                            'Juz list'.tr,
                            style: TextStyle(color: AppColors.secondaryText),
                          ),
                        );
                      default:
                        return Center(
                          child: Text(
                            'Bookmarks'.tr,
                            style: TextStyle(color: AppColors.secondaryText),
                          ),
                        );
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

  Widget buildTabs() {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.06),
            blurRadius: 12,
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
    // final surahs = controller.filteredSurahs;

    if (controller.allSurah.isEmpty) {
      return Center(
        child: AppText(
          'No Surahs found'.tr,
          type: AppTextType.body,
          color: AppColors.secondaryText,
        ),
      );
    }

    return Obx(
        () {
          if(controller.allSurachFetching.value){
            return Center(child: CircularProgressIndicator(),);
          }
        return   ListView.separated(
            padding: const EdgeInsets.only(bottom: 20, top: 2),
            itemCount: controller.allSurah.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final surah = controller.allSurah[index];

              return SurahTile(surah: surah, onTap: () async{
                await controller.fetchSurah(surah.number);
              });
            },
          );
        }
    );
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

class SurahDetailView extends GetView<HollyQuranController> {
  final int number;

  const SurahDetailView({
    super.key,
    required this.number,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:   Text(controller.surah.value!.name.toString()),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.surahFetching.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final surah = controller.surah.value;

        if (surah == null) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('No Surah found'),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => controller.fetchSurah(number),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              surah.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),

            ...surah.ayahs.map((ayah) {
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Theme.of(context).cardColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      ayah.numberInSurah.toString(),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      ayah.text,
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                      style: const TextStyle(
                        fontSize: 27,
                        height: 2.0,
                        fontFamily: 'Amiri',
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        );
      }),
    );
  }
}