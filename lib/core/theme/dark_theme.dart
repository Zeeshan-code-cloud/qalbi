import '../../presentations/export.dart';

class DarkTheme {
  static ThemeData theme = ThemeData(
    brightness: Brightness.dark,

    scaffoldBackgroundColor: AppColors.darkBackground,

    primaryColor: AppColors.goldLight,

    cardColor: AppColors.darkCard,

    colorScheme:   ColorScheme.dark(
      primary: AppColors.goldLight,
      secondary: AppColors.secondary,
    ),
  );
}