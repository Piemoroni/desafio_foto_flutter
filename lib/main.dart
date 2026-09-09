import 'package:flutter/material.dart';
import 'style/theme.dart';
import 'ui/splash.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Meus Momentos',
      theme: AppTheme.claro,
      darkTheme: AppTheme.escuro,
      themeMode: ThemeMode.light,
      home: const Splash(),
    );
  }
}