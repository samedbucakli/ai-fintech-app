import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'main_navigation.dart'; // dotenv paketini dahil ediyoruz

Future<void> main() async {
  // Uygulama başlamadan önce environment değişkenlerini yüklüyoruz
  await dotenv.load(fileName: ".env");

  runApp(const AIFinTechApp());
}

class AIFinTechApp extends StatelessWidget {
  const AIFinTechApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AIFinTech',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      home:
          const MainNavigation(), // Uygulama artık navigasyon yöneticisinden başlayacak
    );
  }
}
