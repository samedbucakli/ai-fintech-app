import 'package:flutter/material.dart';
import 'compare_screen.dart';
import 'home_page_screen.dart';
import 'analysis_screen.dart';
import 'profile_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  // Sayfalarımızı burada tutuyoruz. Diğer sayfalar yapılana kadar yer tutucu (Container) ekledik.
  final List<Widget> _pages = [
    const HomePage(),
    const AnalysisScreen(),
    const CompareScreen(),
    const ProfileScreen(), // Profil sayfamızı da menüye ekledik!
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack sayfalar arası geçişte performansı artırır ve sayfa durumunu korur.
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black87,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Ana Sayfa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            activeIcon: Icon(Icons.bar_chart),
            label: 'Analiz',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.balance_outlined),
            activeIcon: Icon(Icons.balance),
            label: 'Karşılaştırma',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
