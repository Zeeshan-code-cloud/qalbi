 import 'package:qalbi/presentations/export.dart';

class LightTheme {

  static ThemeData themeData = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.goldLight,
    primaryColor: AppColors.primary,

    appBarTheme:   AppBarTheme(
      backgroundColor: AppColors.goldLight,
      foregroundColor: AppColors.lightSurface,
      elevation: 0,
    ),
    cardColor: AppColors.lightCard,
    colorScheme:   ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.primaryDark,
    ),

    textTheme:   TextTheme(
      bodyLarge: TextStyle(
        color: AppColors.primaryDark,
      ),
      bodyMedium: TextStyle(
        color: AppColors.primary,
      ),
    ),
  );
}