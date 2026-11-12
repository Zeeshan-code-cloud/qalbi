
import 'package:qalbi/presentations/export.dart';

import '../../enums/enum.dart';
import '../../widgets/custom_appbar.dart';
import 'calender_controller.dart';
import 'domain/entity/islamic_event_entity.dart';

class CalenderView extends GetView<CalenderController> {
  CalenderView({super.key});

  Color get cream => AppColors.goldLight;
  Color get green => AppColors.primaryColor;
  Color get muted => AppColors.secondaryText;
  Color get cardColor => AppColors.card;

  @override
  Widget build(BuildContext context) {
    final navType = Get.arguments;
    return Obx(
      () => Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppCustomBar(
          title: 'Islamic Calendar'.tr,
          leading: navType == NavType.fromHomeTile
              ? IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(Icons.arrow_back, color: AppColors.primaryColor),
                )
              : const SizedBox.shrink(),
           backgroundColor: Colors.transparent,
        ),
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildHijriBanner(),
                    const SizedBox(height: 16),
                    _buildWeekSelector(),
                    const SizedBox(height: 24),
                    _buildSectionHeader('Upcoming Events'.tr),
                    const SizedBox(height: 12),
                    _buildEventList(
                      controller.specialDays.toList(),
                      isLoading: controller.specialDaysFetching.value,
                    ),
                    const SizedBox(height: 24),
                    _buildSectionHeader('Important Dates'.tr),
                    const SizedBox(height: 12),
                    _buildEventList(
                      controller.monthHolidays,
                      isLoading: controller.islamicMonthFetching.value,
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHijriBanner() {
    return Obx(() {
      final date = controller.selectedDate.value;
      final hijriDate = controller.calendarFor(date);

      return Container(
        height: 22.h,
        width: double.infinity,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: const Color(0xFFE4D1AE),
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
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      const Color(0xFF142E30).withValues(alpha: 0.88),
                      const Color(0xFF142E30).withValues(alpha: 0.1),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    hijriDate?.hijriMonthEnglish ?? 'Islamic Calendar',
                    color: const Color(0xFFF5D99A),
                    fontSize: 23,
                    fontWeight: FontWeight.w700,
                  ),
                  const SizedBox(height: 5),
                  AppText(
                    hijriDate == null ? 'Hijri date unavailable' : '${hijriDate.hijriYear} AH',
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                  ),
                  const SizedBox(height: 8),
                  AppText(
                    '${_weekday(date).tr}, ${date.day} '
                    '${_gregorianMonth(date.month).tr} ${date.year}',
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _bannerArrow(
                        icon: Icons.arrow_back_rounded,
                        onTap: controller.previousMonth,
                      ),
                      _bannerArrow(
                        icon: Icons.arrow_forward_rounded,
                        onTap: controller.nextMonth,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Positioned(
              top: 28,
              right: 25,
              child: Icon(
                Icons.nightlight_round,
                color: Color(0xFFFFD38A),
                size: 28,
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _bannerArrow({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: Icon(
          icon,
          color: Colors.white,
          size: 22,
        ),
      ),
    );
  }

  Widget _buildWeekSelector() {
    return Obx(() {
      final selectedDate = controller.selectedDate.value;
      final dates = controller.weekDates;

      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.border,
          ),
        ),
        child: Row(
          children: dates.map((date) {
            final selected = _sameDate(date, selectedDate);

            return Expanded(
              child: GestureDetector(
                onTap: () => controller.selectDate(date),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: selected ? green : Colors.transparent,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Column(
                    children: [
                      AppText(
                        _weekdayShort(date).tr,
                        fontSize: 11,
                        color: selected ? Colors.white70 : muted,
                      ),
                      const SizedBox(height: 8),
                      AppText(
                        '${date.day}',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: selected ? Colors.white : (AppColors.isDark ? AppColors.text : green),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      );
    });
  }

  Widget _buildSectionHeader(
    String title, {
    VoidCallback? onViewAll,
  }) {
    return Row(
      children: [
        Expanded(
          child: AppText(
            title,
            type: AppTextType.heading4,
            color: AppColors.text,
          ),
        ),
        if (onViewAll != null)
          GestureDetector(
            onTap: onViewAll,
            child: AppText(
              'View All'.tr,
              fontSize: 13,
              color: muted,
              fontWeight: FontWeight.w500,
            ),
          ),
      ],
    );
  }

  Widget _buildEventList(
    List<IslamicEventEntity> events, {
    bool isLoading = false,
  }) {
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (events.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: AppColors.border,
          ),
        ),
        child: Text(
          'No events to display.'.tr,
          style: TextStyle(color: muted),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        children: events.asMap().entries.map((entry) {
          final index = entry.key;
          final event = entry.value;

          return Column(
            children: [
              _buildEventTile(event),
              if (index != events.length - 1)
                Divider(
                  height: 1,
                  indent: 18,
                  endIndent: 18,
                  color: AppColors.divider,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEventTile(IslamicEventEntity event) {
    final icon = _eventIcon(event.name.toLowerCase());
    final iconColor = _eventColor(event.name.toLowerCase());

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 23,
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    event.name.tr,
                    type: AppTextType.bodyBold,
                    color: AppColors.text,
                  ),
                  const SizedBox(height: 4),
                  AppText(
                    '${event.day} ${_hijriMonth(event.month)}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    fontSize: 12,
                    color: muted,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${event.day}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.text,
                  ),
                ),
                Text(
                  _hijriMonth(event.month),
                  style: TextStyle(
                    fontSize: 12,
                    color: muted,
                  ),
                ),
              ],
            ),
          ],
      ),
    );
  }

  String _hijriMonth(int month) {
    const names = [
      'Muharram', 'Safar', "Rabi' al-Awwal", "Rabi' al-Thani",
      'Jumada al-Awwal', 'Jumada al-Thani', 'Rajab', "Sha'ban",
      'Ramadan', 'Shawwal', "Dhu al-Qi'dah", 'Dhu al-Hijjah',
    ];
    return month >= 1 && month <= names.length ? names[month - 1] : '';
  }

  IconData _eventIcon(String key) {
    switch (key) {
      case 'month':
        return Icons.spa_rounded;
      case 'fasting':
        return Icons.nightlight_round;
      case 'prayer':
        return Icons.front_hand_rounded;
      case 'calendar':
        return Icons.calendar_month_rounded;
      default:
        return Icons.event_rounded;
    }
  }

  Color _eventColor(String key) {
    switch (key) {
      case 'month':
        return const Color(0xFF64854B);
      case 'fasting':
        return const Color(0xFF625D50);
      case 'prayer':
        return cream;
      case 'calendar':
        return const Color(0xFF56804F);
      default:
        return green;
    }
  }

  bool _sameDate(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  String _weekday(DateTime date) {
    const names = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return names[date.weekday - 1];
  }

  String _weekdayShort(DateTime date) {
    const names = [
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun',
    ];
    return names[date.weekday - 1];
  }

  String _gregorianMonth(int month) {
    const names = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return names[month - 1];
  }
}
