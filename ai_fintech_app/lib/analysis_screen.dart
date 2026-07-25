import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'profile_screen.dart';
import 'stock_detail_screen.dart';

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  bool _isGainersSelected = true;

  List<Map<String, dynamic>> _sectorData = [];
  bool _isLoadingSectors = true;

  @override
  void initState() {
    super.initState();
    _fetchSectorData();
  }

  Future<void> _fetchSectorData() async {
    final data = await ApiService().getSectorPerformances();
    if (mounted) {
      setState(() {
        _sectorData = data;
        _isLoadingSectors = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FA),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/images/logo.png',
                height: 36,
                width: 36,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'AIFinTech',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                fontSize: 22,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            // YENİ EKLENEN KISIM: Profil resmini tıklanabilir yaptık
            child: GestureDetector(
              onTap: () {
                // Tıklandığında Profil sayfasına git
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(),
                  ),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/images/user_logo.png',
                  height: 32,
                  width: 32,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            _buildSearchBar(),
            const SizedBox(height: 24),
            _buildSectionTitle('SON ARAMALAR'),
            _buildRecentSearches(),
            const SizedBox(height: 24),
            _buildSectorPerformanceHeader(),
            const SizedBox(height: 8),
            _buildSectorList(),
            const SizedBox(height: 32),
            _buildSectionTitle(
              'YAPAY ZEKA: GÜNÜN ÖNEMLİ HABERLERİ',
              center: true,
            ),
            const SizedBox(height: 16),
            _buildAINewsCard(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // Arama için kullanacağımız örnek BIST100 hisse listesi
  static const List<String> _kStockOptions = <String>[
    'THYAO',
    'EREGL',
    'GARAN',
    'ASELS',
    'SASA',
    'HEKTS',
    'KCHOL',
    'TUPRS',
    'PGSUS',
    'AKBNK',
    'ISCTR',
    'SISE',
  ];

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      // Autocomplete widget'ı kullanıcı yazdıkça öneri sunar
      child: Autocomplete<String>(
        optionsBuilder: (TextEditingValue textEditingValue) {
          // Eğer kutu boşsa hiçbir şey gösterme
          if (textEditingValue.text == '') {
            return const Iterable<String>.empty();
          }
          // Kullanıcının yazdığı harfleri içeren hisseleri filtrele
          return _kStockOptions.where((String option) {
            return option.contains(textEditingValue.text.toUpperCase());
          });
        },
        // Listeden bir hisse seçildiğinde (tıklandığında) çalışacak kod
        onSelected: (String selection) {
          // Klavyeyi kapat
          FocusScope.of(context).unfocus();

          // Seçilen hissenin koduyla birlikte detay sayfasına (StockDetailScreen) yönlendir
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StockDetailScreen(symbol: selection),
            ),
          );
        },
        // Arama kutusunun kendi tasarımı
        fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              onEditingComplete: onEditingComplete,
              textCapitalization:
                  TextCapitalization.characters, // Harfleri otomatik büyüt
              decoration: InputDecoration(
                hintText: 'Hisse veya sektör ara...',
                hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey.shade600,
                  size: 26,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title, {bool center = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Align(
        alignment: center ? Alignment.center : Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: Colors.black54,
            letterSpacing: 1.0,
          ),
        ),
      ),
    );
  }

  Widget _buildRecentSearches() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
      child: Row(
        children: const [
          _RecentSearchChip(text: 'THYAO'),
          _RecentSearchChip(text: 'EREGL'),
          _RecentSearchChip(text: 'GARAN'),
          _RecentSearchChip(text: 'ASELS'),
        ],
      ),
    );
  }

  Widget _buildSectorPerformanceHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text(
            'SEKTÖR PERFORMANSI',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: Colors.black54,
              letterSpacing: 1.0,
            ),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isGainersSelected = true;
                  });
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Yükselenler',
                      style: TextStyle(
                        fontWeight: _isGainersSelected
                            ? FontWeight.bold
                            : FontWeight.w600,
                        fontSize: 14,
                        color: _isGainersSelected
                            ? Colors.black87
                            : Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: 2,
                      width: 80,
                      color: _isGainersSelected
                          ? Colors.black87
                          : Colors.transparent,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isGainersSelected = false;
                  });
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Düşenler',
                      style: TextStyle(
                        fontWeight: !_isGainersSelected
                            ? FontWeight.bold
                            : FontWeight.w600,
                        fontSize: 14,
                        color: !_isGainersSelected
                            ? Colors.black87
                            : Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: 2,
                      width: 70,
                      color: !_isGainersSelected
                          ? Colors.black87
                          : Colors.transparent,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectorList() {
    if (_isLoadingSectors) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 32.0),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_sectorData.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 32.0),
        child: Center(child: Text('Sektör verileri alınamadı.')),
      );
    }

    final filteredData = _sectorData.where((sector) {
      final double change = sector['changePercent'] ?? 0.0;
      return _isGainersSelected ? change >= 0 : change < 0;
    }).toList();

    if (filteredData.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 32.0),
        child: Center(
          child: Text(
            _isGainersSelected
                ? 'Şu an yükselen sektör bulunmuyor.'
                : 'Şu an düşen sektör bulunmuyor.',
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ),
      );
    }

    IconData getIconForSector(String name) {
      if (name.contains('Banka')) return Icons.account_balance;
      if (name.contains('Sanayi')) return Icons.factory;
      if (name.contains('Teknoloji')) return Icons.laptop_chromebook;
      if (name.contains('Hizmet')) return Icons.design_services;
      if (name.contains('Holding')) return Icons.business;
      return Icons.show_chart;
    }

    return Column(
      children: filteredData.map((sector) {
        final String title = sector['name'];
        final double changePercent = sector['changePercent'];
        final bool isPositive = changePercent >= 0;

        return _SectorCard(
          icon: getIconForSector(title),
          title: title,
          change:
              '${isPositive ? '+' : ''}${changePercent.toStringAsFixed(2)}%',
          isPositive: isPositive,
        );
      }).toList(),
    );
  }

  Widget _buildAINewsCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: const Color(0xFF111827),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'MAKRO ANALİZ',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                const Text(
                  '14:30',
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Enflasyon Verisi Sonrası Bankacılık Sektörü Hareketli',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Yapay zekamızın analizine göre, açıklanan son veriler bankacılık endeksinde (XBANK) yukarı yönlü bir ivme başlattı. GARAN ve AKBNK...',
              style: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Text(
                  'ANALİZİ GENİŞLET',
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey.shade400,
                  size: 10,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// --- Alt Bileşenler (Widgets) ---

class _RecentSearchChip extends StatelessWidget {
  final String text;

  const _RecentSearchChip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.close, size: 16, color: Colors.black54),
        ],
      ),
    );
  }
}

class _SectorCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String change;
  final bool isPositive;

  const _SectorCard({
    required this.icon,
    required this.title,
    required this.change,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: isPositive
                ? const Color(0xFF008955)
                : const Color(0xFFD92D20),
            size: 28,
          ),
          const SizedBox(width: 16),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          const Spacer(),
          Text(
            change,
            style: TextStyle(
              color: isPositive
                  ? const Color(0xFF008955)
                  : const Color(0xFFD92D20),
              fontWeight: FontWeight.bold,
              fontSize: 16,
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}
