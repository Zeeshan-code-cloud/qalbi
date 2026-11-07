import 'package:qalbi/presentations/tasbeeh_view/tasbeeh_controller.dart';
import 'package:qalbi/widgets/custom_appbar.dart';

import '../export.dart';

class TasbeehView extends GetView<TasbeehController> {
  const TasbeehView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightSurface,
      appBar: AppCustomBar(
        title: "Tasbeeh",
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
                          const SizedBox(height: 2),
                          AppText(
                            'SubhanAllah',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF49433A),
                          ),
                          SizedBox(height: 5.h),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12.h),

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
                    color: const Color(0xFFFFFCF6),
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
                            const Expanded(
                              child: Text(
                                'Daily Goal',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF69645B),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            IconButton(
                              visualDensity: VisualDensity.compact,
                              onPressed: () {
                                Get.dialog(
                                  AlertDialog(
                                    backgroundColor: AppColors.goldLight,
                                    title: const Text('Daily Goal'),
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
                        Text(
                          '${controller.count.value} / ${controller.dailyGoal.value}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF282720),
                          ),
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

  Widget _tasbeehButton({
    required IconData icon,
    required VoidCallback onTap,
    bool isPrimary = false,
  }) {
    return Material(
      color: isPrimary ? const Color(0xFFE9DFC9) : const Color(0xFFF0E9DC),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 54,
          height: 54,
          child: Icon(icon, size: 28, color: const Color(0xFF292820)),
        ),
      ),
    );
  }
}
