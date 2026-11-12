import 'package:qalbi/presentations/tasbeeh_view/tasbeeh_controller.dart';
import 'package:qalbi/widgets/custom_appbar.dart';

import '../export.dart';

class TasbeehView extends GetView<TasbeehController> {
  const TasbeehView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppCustomBar(
        title: "Tasbeeh".tr,
         backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header

              // Tasbeeh beads image
              SizedBox(
                width: 90.w,
                height: 50.h,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(AppAssets.tasbeehImage, fit: BoxFit.cover),

                    // Counter
                    Obx(
                      () => Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppText(
                            '${controller.count.value}',
                            fontSize: 38,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),

                          SizedBox(height: 10.h),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 3.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Obx(
                  () => Material(
                    color:  AppColors.background,
                    borderRadius: BorderRadius.circular(18),
                    child: InkWell(
                      onTap: _showTasbeehPicker,
                      borderRadius: BorderRadius.circular(18),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: const Color(0xFFEAE1D1)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: AppText(
                                controller.selectedTasbeeh.value,
                                textDirection: TextDirection.rtl,
                                textAlign: TextAlign.right,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                   fontSize: 19,
                                   color: AppColors.text,
                                  fontWeight: FontWeight.w600,
                               ),
                            ),
                            const SizedBox(width: 12),
                            const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: AppColors.goldDark,
                              size: 28,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 2.h),

              // Decrease and increase controls
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _tasbeehButton(
                    icon: Icons.remove_rounded,
                    onTap: controller.decrement,
                  ),
                  const SizedBox(width: 100),
                  _tasbeehButton(
                    icon: Icons.add_rounded,
                    onTap: controller.increment,
                    isPrimary: true,
                  ),
                ],
              ),

              SizedBox(height: 2.h),

              // Daily goal card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: const Color(0xFFEAE1D1)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.brown.withValues(alpha: 0.06),
                        blurRadius: 18,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Obx(
                    () => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.track_changes_rounded,
                              color: AppColors.icon,
                              size: 21,
                            ),
                            const SizedBox(width: 9),
                              Expanded(
                              child: AppText(
                                'Daily Goal',
                                   fontSize: 13,
                                  color: AppColors.text,
                                  fontWeight: FontWeight.w500,
                               ),
                            ),
                            IconButton(
                              visualDensity: VisualDensity.compact,
                              onPressed: () {
                                Get.dialog(
                                  AlertDialog(
                                    backgroundColor: AppColors.goldLight,
                                    title:   AppText('Daily Goal',color: AppColors.text,),
                                    content: TextField(
                                      autofocus: true,
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        hintText: 'Enter your daily target',
                                      ),
                                      onSubmitted: (value) {
                                        final goal = int.tryParse(value);
                                        if (goal != null && goal > 0) {
                                          controller.dailyGoal.value = goal;
                                        }
                                        Get.back();
                                      },
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.edit_outlined,
                                size: 18,
                                color: AppColors.goldDark,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppText(
                              '${controller.count.value} / ${controller.dailyGoal.value}',
                                 fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: AppColors.text
                              ),

                            IconButton(onPressed: controller.reset, icon: Icon(Icons.clear))
                          ],
                        ),
                        const SizedBox(height: 14),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: controller.progress,
                            minHeight: 6,
                            backgroundColor: const Color(0xFFECE3D4),
                            // valueColor: const AlwaysStoppedAnimation<Color>(gold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 18.h),
            ],
          ),
        ),
      ),
    );
  }

  void _showTasbeehPicker() {
    Get.bottomSheet<void>(
      SafeArea(
        top: false,
        child: Container(
          height: 78.h,
          padding: EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 1.h),
          decoration:   BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
          ),
          child: Column(
            children: [
              Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              SizedBox(height: 2.h),
              Row(
                children: [
                    Expanded(
                    child: AppText(
                      'Choose a Tasbeeh',
                         fontSize: 19,
                        fontWeight: FontWeight.w700,
                        color: AppColors.text,
                      ),
                   ),
                  IconButton(
                    onPressed: () => Get.back<void>(),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              SizedBox(height: 1.h),
              TextField(
                controller: controller.tasbeehSearchController,
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                onChanged: (value) => controller.tasbeehSearchQuery.value = value,
                decoration: InputDecoration(
                  hintText: 'ابحث عن التسبيح',
                  prefixIcon: const Icon(Icons.search_rounded),
                  filled: true,
                  fillColor: AppColors.background,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                ),
              ),
              SizedBox(height: 1.h),
              Expanded(
                child: Obx(() {
                  final phrases = controller.filteredTasbeehOptions;
                  if (phrases.isEmpty) {
                    return   Center(child: AppText('لا توجد نتائج'));
                  }
                  return ListView.separated(
                    itemCount: phrases.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final phrase = phrases[index];
                      final selected =
                          controller.selectedTasbeeh.value == phrase;
                      return ListTile(
                        onTap: () {
                          controller.selectTasbeeh(phrase);
                          Get.back<void>();
                        },
                        title: AppText(
                          phrase,
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.right,
                             fontSize: 17,
                             color: AppColors.text,
                          ),
                         trailing: selected
                            ? const Icon(
                                Icons.check_circle_rounded,
                                color: AppColors.goldDark,
                              )
                            : const Icon(Icons.circle_outlined),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  Widget _tasbeehButton({
    required IconData icon,
    required VoidCallback onTap,
    bool isPrimary = false,
  }) {
    return Material(
      color: AppColors.background,
      shape: const CircleBorder(),

      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            border: BoxBorder.all(color: AppColors.border),
            shape: BoxShape.circle
          ),
          child: Icon(icon, size: 28, color: AppColors.text),
        ),
      ),
    );
  }
}
