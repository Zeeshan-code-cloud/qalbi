import 'package:get/get.dart';

import '../export.dart';

class ZakatController  extends GetxController{

  final showInformation = true.obs;
  final nisabValue = 0.0.obs;
  final selectedCategory = Rxn<ZakatCategoryModel>();

  final goldController = TextEditingController();
  final silverController = TextEditingController();
  final cashController = TextEditingController();
  final businessController = TextEditingController();
  final investmentController = TextEditingController();
  final agricultureController = TextEditingController();
  final otherAssetsController = TextEditingController();
  final liabilitiesController = TextEditingController();

  final categories = const <ZakatCategoryModel>[
    ZakatCategoryModel(
      title: 'Gold & Silver',
      subtitle: 'Calculate Zakat on gold and silver',
      icon: Icons.diamond_outlined,
      iconColor: Color(0xFFB98520),
      iconBackground: Color(0xFFF8EBD0),
    ),
    ZakatCategoryModel(
      title: 'Cash & Savings',
      subtitle: 'Calculate Zakat on cash, bank balance',
      icon: Icons.account_balance_wallet_outlined,
      iconColor: Color(0xFFB98520),
      iconBackground: Color(0xFFF8EBD0),
    ),
    ZakatCategoryModel(
      title: 'Business Assets',
      subtitle: 'Calculate Zakat on business assets',
      icon: Icons.apartment_rounded,
      iconColor: Color(0xFF275B4A),
      iconBackground: Color(0xFFE5EBDD),
    ),
    ZakatCategoryModel(
      title: 'Investments',
      subtitle: 'Calculate Zakat on investments',
      icon: Icons.trending_up_rounded,
      iconColor: Color(0xFF275B4A),
      iconBackground: Color(0xFFE5EBDD),
    ),
    ZakatCategoryModel(
      title: 'Agriculture',
      subtitle: 'Calculate Zakat on crops and produce',
      icon: Icons.eco_outlined,
      iconColor: Color(0xFF477B43),
      iconBackground: Color(0xFFE5EBDD),
    ),
    ZakatCategoryModel(
      title: 'Other Assets',
      subtitle: 'Calculate Zakat on other assets',
      icon: Icons.inventory_2_outlined,
      iconColor: Color(0xFFB98520),
      iconBackground: Color(0xFFF8EBD0),
    ),
  ];

  double _amount(TextEditingController controller) {
    return double.tryParse(
      controller.text.trim().replaceAll(',', ''),
    ) ??
        0;
  }

  double get goldAndSilver => _amount(goldController) +
      _amount(silverController);

  double get totalAssets =>
      goldAndSilver +
          _amount(cashController) +
          _amount(businessController) +
          _amount(investmentController) +
          _amount(agricultureController) +
          _amount(otherAssetsController);

  double get netZakatableWealth =>
      (totalAssets - _amount(liabilitiesController))
          .clamp(0.0, double.infinity)
          .toDouble();

  bool get meetsNisab =>
      nisabValue.value > 0 &&
          netZakatableWealth >= nisabValue.value;

  double get estimatedZakat =>
      meetsNisab ? netZakatableWealth * 0.025 : 0;

  void selectCategory(ZakatCategoryModel category) {
    selectedCategory.value = category;
    Get.toNamed(
      '/zakat-details',
      arguments: category,
    );
  }

  void dismissInformation() {
    showInformation.value = false;
  }

  void updateNisab(double value) {
    nisabValue.value = value;
  }

  @override
  void onClose() {
    goldController.dispose();
    silverController.dispose();
    cashController.dispose();
    businessController.dispose();
    investmentController.dispose();
    agricultureController.dispose();
    otherAssetsController.dispose();
    liabilitiesController.dispose();
    super.onClose();
  }

}
class ZakatCategoryModel {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Color iconBackground;

  const ZakatCategoryModel({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
  });
}