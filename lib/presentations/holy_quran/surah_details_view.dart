import 'package:qalbi/core/localizations/app_localizations/language_controller.dart';

import '../export.dart';
import 'holly_quran_controller.dart';

class SurahDetailView extends GetView<HollyQuranController> {
  final int number;

  const SurahDetailView({super.key, required this.number});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        if (controller.surahFetching.value) {
          return const Center(child: CircularProgressIndicator());
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

        final languageCode =
            Get.find<LanguageController>().selectedLocal.value.languageCode;

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  child: Icon(Icons.arrow_back),
                  onTap: () {
                    Get.back();
                  },
                ),
                Text(
                  surah.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: AppColors.background,
              ),
              child: Column(
                children: surah.ayahs.map((ayah) {
                  final translation = switch (languageCode) {
                    'ur' => ayah.urduTranslation,
                    'en' => ayah.translation,
                    _ => '',
                  };

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(text: '${ayah.text} '),
                                TextSpan(
                                  text: '۝${ayah.numberInSurah}',
                                  style: const TextStyle(
                                    fontSize: 19,
                                    color: Colors.amber,
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.justify,
                            style: const TextStyle(
                              fontSize: 27,
                              height: 2.2,
                              fontFamily: 'Amiri',
                            ),
                          ),
                        ),
                        if (translation.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            translation,
                            textAlign: languageCode == 'ur'
                                ? TextAlign.right
                                : TextAlign.left,
                            textDirection: languageCode == 'ur'
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                            style: TextStyle(
                              fontSize: 15,
                              height: 1.6,
                              color: AppColors.secondaryText,
                            ),
                          ),
                        ],
                        Divider(
                          height: 24,
                          color: AppColors.divider,
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        );
      }),
    );
  }
}
