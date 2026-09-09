import 'package:flutter/material.dart';
import 'colors.dart';

class AppTheme {
  static ThemeData claro = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.fundoClaro,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.rosaQueimado,
      brightness: Brightness.light,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.fundoClaro,
      foregroundColor: AppColors.rosaQueimadoEscuro,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.rosaQueimado,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
  );

  static ThemeData escuro = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.fundoEscuro,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.rosaQueimado,
      brightness: Brightness.dark,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.fundoEscuro,
      foregroundColor: AppColors.rosaQueimadoClaro,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.rosaQueimadoMedio,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
  );
}