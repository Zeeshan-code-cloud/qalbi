import 'package:qalbi/presentations/export.dart';
import 'package:qalbi/presentations/zakat/zakat_controller.dart';
import '../../widgets/custom_appbar.dart';


class ZakatView extends GetView<ZakatController> {
    ZakatView({super.key});
 final cream = AppColors.goldLight;
  final green = AppColors.success;
  final muted = AppColors.secondaryText;
  final cardColor = AppColors.lightCard;
   @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cream,
      appBar: AppCustomBar(
        title: 'Zakat Calculator',
        actionIcon: Icons.info_outline_rounded,
        backgroundColor: cream,
        onActionTap: _showZakatInformation,
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildWealthBanner(),
                  const SizedBox(height: 16),
                  ...controller.categories.map(
                        (category) => Padding(
                      padding: const EdgeInsets.only(bottom: 9),
                      child: _buildCategoryTile(category),
                    ),
                  ),
                  const SizedBox(height: 4),
                  _buildInformationCard(),
                ]),
              ),
            ),
          ],
        ),
      ),
     );
  }

  Widget _buildWealthBanner() {
    return Container(
      height: 148,
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
         borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE5D4B5),
        ),
        image:   DecorationImage(
          image: AssetImage(
           AppAssets.homeScreenBanner
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
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    green.withValues(alpha: 0.88),
                    green.withValues(alpha: 0.58),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Purify Your Wealth',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 7),
                const Text(
                  'Calculate your Zakat according\nto Islamic principles',
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    color: Colors.white70,
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: () {
                    Get.toNamed('/zakat-information');
                  },
                  child: const Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.white,
                    size: 21,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTile(ZakatCategoryModel category) {
    return Material(
      color: cardColor,
      borderRadius: BorderRadius.circular(19),
      child: InkWell(
        onTap: () => controller.selectCategory(category),
        borderRadius: BorderRadius.circular(19),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 13,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(19),
            border: Border.all(
              color: const Color(0xFFEFE6D9),
              width: 0.8,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: category.iconBackground,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  category.icon,
                  color: category.iconColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                       category.title,
                      type: AppTextType.bodyBold,
                    ),
                    const SizedBox(height: 4),
                    AppText(
                      category.subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                         fontSize: 12,
                         color: muted,
                     ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
                Icon(
                Icons.chevron_right_rounded,
                color: AppColors.icon,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInformationCard() {
    return Obx(() {
      if (!controller.showInformation.value) {
        return const SizedBox.shrink();
      }

      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFFBF1DA),
          borderRadius: BorderRadius.circular(19),
          border: Border.all(
            color: const Color(0xFFF0E2C5),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: const BoxDecoration(
                color: Color(0xFFF5E5C2),
                shape: BoxShape.circle,
              ),
              child:   Icon(
                Icons.menu_book_rounded,
                color: cream,
                size: 25,
              ),
            ),
            const SizedBox(width: 12),
              Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    'Zakat Information',
                       fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: green,
                   ),
                  SizedBox(height: 5),
                  Text(
                    'Learn about Zakat, Nisab, and Islamic rulings.',
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.4,
                      color: muted,
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: controller.dismissInformation,
              child:   Icon(
                Icons.close_rounded,
                size: 19,
                color: AppColors.icon,
              ),
            ),
          ],
        ),
      );
    });
  }

  void _showZakatInformation() {
    Get.dialog(
      AlertDialog(
        backgroundColor: cream,
        title: const Text('About Zakat'),
        content: const Text(
          'Zakat is an obligatory form of charity subject to '
              'specific eligibility, Nisab, and timing rules. '
              'Consult a trusted scholar for guidance on your assets.',
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            child:   AppText(
              'Close',
                   color: green),
           ),
        ],
      ),
    );
  }

}
