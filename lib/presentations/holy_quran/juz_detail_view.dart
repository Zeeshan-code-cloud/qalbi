import 'package:qalbi/core/localizations/app_localizations/language_controller.dart';

import '../export.dart';
import 'holly_quran_controller.dart';

class JuzDetailView extends GetView<HollyQuranController> {
  final int  number;

  const JuzDetailView({
    super.key,
    required this.number,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Juz $number'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Obx(() {
        if (controller.juzDetailsFetching.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final juz = controller.juzDetails.value;
        final languageCode =
            Get.find<LanguageController>().selectedLocal.value.languageCode;

        if (juz == null) {
          return Center(
            child: ElevatedButton(
              onPressed: () => controller.fetchJuzDetails(number),
              child: const Text('Retry'),
            ),
          );
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding:   EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: AppColors.background,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: juz.ayahList.map((ayah) {
                  final translation = switch (languageCode) {
                    'ur' => ayah.urduTranslation,
                    'en' => ayah.translation,
                    _ => '',
                  };

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(text: '${ayah.text} '),
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.middle,
                                  child: Container(
                                    width: 27,
                                    height: 27,
                                    margin: const EdgeInsets.symmetric(horizontal: 3),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.amber, width: 1),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      '${ayah.numberInSurah}',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontFamily: 'Amiri',
                                      ),
                                    ),
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
                        if (translation.trim().isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            translation,
                            textDirection: languageCode == 'ur'
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                            textAlign: languageCode == 'ur'
                                ? TextAlign.right
                                : TextAlign.left,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              height: 1.5,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                }).toList(),
              ),            ),
          ],
        );
      }),
    );
  }
}