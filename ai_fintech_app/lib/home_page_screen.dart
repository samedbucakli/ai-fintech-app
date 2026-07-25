import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'package:webfeed_plus/webfeed_plus.dart'; // HABERLER İÇİN EKLENDİ
import 'package:url_launcher/url_launcher.dart'; // HABER LİNKLERİ İÇİN EKLENDİ
import 'services/rss_service.dart'; // RSS SERVİSİ İÇİN EKLENDİ (Bu dosyayı oluşturduğunu varsayıyoruz)

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> _marketData = [];
  List<dynamic> _gainers = [];
  List<dynamic> _losers = [];
  List<Map<String, dynamic>> _watchlistData = [];

  bool _isLoading = true;
  bool _isStocksLoading = true;

  // Hisselerin tam adlarını ve sektörlerini güzel göstermek için eşleştirme tablosu
  final Map<String, Map<String, String>> _stockDetails = {
    'THYAO.IS': {'name': 'Türk Hava Yolları', 'sector': 'Ulaştırma'},
    'EREGL.IS': {'name': 'Erdemir', 'sector': 'Metal'},
    'SASA.IS': {'name': 'Sasa Polyester', 'sector': 'Kimya'},
    'HEKTS.IS': {'name': 'Hektaş', 'sector': 'Tarım'},
    'GARAN.IS': {'name': 'Garanti BBVA', 'sector': 'Finans'},
    'ASELS.IS': {'name': 'Aselsan', 'sector': 'Savunma'},
    'KCHOL.IS': {'name': 'Koç Holding', 'sector': 'Holding'},
    'TUPRS.IS': {'name': 'Tüpraş', 'sector': 'Enerji'},
  };

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    // 1. Piyasa Özeti Verisini Çek
    final marketData = await ApiService().getMarketSummaryData();

    // 2. Popüler Hisse Verilerini Çek
    final stockData = await ApiService().getPopularBistStocks();

    // Hisseleri günlük değişim yüzdesine göre büyükten küçüğe sıralıyoruz
    stockData.sort((a, b) {
      final double changeA = a['regularMarketChangePercent'] ?? 0.0;
      final double changeB = b['regularMarketChangePercent'] ?? 0.0;
      return changeB.compareTo(changeA);
    });

    // Artıda olanları Kazananlara, ekside olanları Kaybedenlere ayırıyoruz
    final gainers = stockData
        .where((s) => (s['regularMarketChangePercent'] ?? 0.0) >= 0)
        .toList();
    final losers = stockData
        .where((s) => (s['regularMarketChangePercent'] ?? 0.0) < 0)
        .toList();

    // Kaybedenleri en çok düşenden başlayacak şekilde ters çeviriyoruz
    losers.sort((a, b) {
      final double changeA = a['regularMarketChangePercent'] ?? 0.0;
      final double changeB = b['regularMarketChangePercent'] ?? 0.0;
      return changeA.compareTo(changeB);
    });

    // 3. İzleme Listesi Verilerini Çek
    final watchlistData = await ApiService().getWatchlistData();

    setState(() {
      _marketData = marketData;
      _gainers = gainers;
      _losers = losers;
      _watchlistData = watchlistData;
      _isLoading = false;
      _isStocksLoading = false;
    });
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
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black87, size: 28),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('PİYASA ÖZETİ'),
              _buildMarketSummary(),
              const SizedBox(height: 24),

              _buildSectionTitle('EN ÇOK DEĞER KAZANANLAR', showSeeAll: true),
              _buildStockList(isGainer: true),
              const SizedBox(height: 24),

              _buildSectionTitle('EN ÇOK DEĞER KAYBEDENLER', showSeeAll: true),
              _buildStockList(isGainer: false),
              const SizedBox(height: 24),

              _buildSectionTitle('İZLEME LİSTENİZ'),
              _buildWatchlist(),
              const SizedBox(height: 24),

              _buildSectionTitle('GÜNÜN HABERLERİ'),
              const NewsWidget(), // DİNAMİK HABER WIDGET'I BURAYA EKLENDİ
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, {bool showSeeAll = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: Colors.black54,
              letterSpacing: 1.2,
            ),
          ),
          if (showSeeAll)
            Text(
              'TÜMÜNÜ GÖR',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMarketSummary() {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24.0),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_marketData.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24.0),
        child: Center(child: Text('Piyasa verileri şu an alınamıyor.')),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        children: _marketData.map((item) {
          final symbol = item['symbol'] ?? '';
          final price = item['price']?.toDouble() ?? 0.0;
          final changePercent = item['changePercent']?.toDouble() ?? 0.0;

          String displayTitle = symbol;
          if (symbol == 'XU100.IS') displayTitle = 'BIST 100';
          if (symbol == 'GC=F') displayTitle = 'ALTIN (Ons)';
          if (symbol == 'TRY=X' || symbol == 'USDTRY=X') {
            displayTitle = 'USD/TRY';
          }

          String formattedPrice = (symbol == 'TRY=X' || symbol == 'USDTRY=X')
              ? price.toStringAsFixed(4)
              : price.toStringAsFixed(2);

          return _MarketCard(
            title: displayTitle,
            value: formattedPrice,
            change:
                '${changePercent > 0 ? '+' : ''}${changePercent.toStringAsFixed(2)}%',
            isPositive: changePercent >= 0,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStockList({required bool isGainer}) {
    if (_isStocksLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24.0),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final listToShow = isGainer ? _gainers : _losers;

    if (listToShow.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Text(
          'Şu an bu kategoride hisse bulunmuyor.',
          style: TextStyle(color: Colors.grey, fontSize: 13),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        children: listToShow.map((item) {
          final symbol = item['symbol'] ?? '';
          final price = item['regularMarketPrice']?.toDouble() ?? 0.0;
          final changePercent =
              item['regularMarketChangePercent']?.toDouble() ?? 0.0;

          final displayCode = symbol.replaceAll('.IS', '');
          final details =
              _stockDetails[symbol] ??
              {'name': displayCode, 'sector': 'Borsa İstanbul'};

          return _StockCard(
            name: details['name']!,
            code: displayCode,
            sector: details['sector']!,
            price: '₺${price.toStringAsFixed(2)}',
            change:
                '${changePercent > 0 ? '+' : ''}${changePercent.toStringAsFixed(2)}%',
            isPositive: changePercent >= 0,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildWatchlist() {
    if (_isStocksLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24.0),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_watchlistData.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Text(
          'İzleme listeniz şu an boş veya veriler alınamıyor.',
          style: TextStyle(color: Colors.grey, fontSize: 13),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: _watchlistData.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final symbol = item['symbol'] ?? '';
            final price = item['price']?.toDouble() ?? 0.0;
            final changePercent = item['changePercent']?.toDouble() ?? 0.0;

            String code = symbol;
            String name = symbol;
            Color logoColor = Colors.grey.shade200;
            String prefix = '₺';

            if (symbol == 'GARAN.IS') {
              code = 'GARAN';
              name = 'Garanti BBVA';
              logoColor = Colors.blue.shade100;
            } else if (symbol == 'ASELS.IS') {
              code = 'ASELS';
              name = 'Aselsan';
              logoColor = Colors.indigo.shade50;
            } else if (symbol == 'SI=F') {
              code = 'GÜMŞ';
              name = 'Gümüş (Ons)';
              logoColor = Colors.grey.shade300;
              prefix = '₺';
            } else if (symbol == 'HG=F') {
              code = 'BAKR';
              name = 'Bakır';
              logoColor = Colors.brown.shade200;
              prefix = '₺';
            }

            final isPositive = changePercent >= 0;
            String formattedPrice = price.toStringAsFixed(2);
            String formattedChange =
                '${isPositive ? '+' : ''}${changePercent.toStringAsFixed(2)}%';

            return Column(
              children: [
                _WatchlistItem(
                  code: code,
                  name: name,
                  price: '$prefix$formattedPrice',
                  change: formattedChange,
                  isPositive: isPositive,
                  logoColor: logoColor,
                ),
                if (index < _watchlistData.length - 1)
                  const Divider(height: 1, color: Color(0xFFEEEEEE)),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

// --- DİNAMİK VE MODERN HABER BİLEŞENİ ---
class NewsWidget extends StatefulWidget {
  const NewsWidget({super.key});

  @override
  State<NewsWidget> createState() => _NewsWidgetState();
}

class _NewsWidgetState extends State<NewsWidget> {
  List<RssItem> _news = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchNews();
  }

  Future<void> _fetchNews() async {
    final rssService = RssService();
    final news = await rssService.getTurkishNews();
    if (mounted) {
      setState(() {
        _news = news;
        _isLoading = false;
      });
    }
  }

  Future<void> _launchUrl(String? urlString) async {
    if (urlString == null) return;
    final Uri url = Uri.parse(urlString);
    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw Exception('Açılamadı: $url');
      }
    } catch (e) {
      debugPrint('Link açma hatası: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24.0),
        child: Center(child: CircularProgressIndicator(color: Colors.black87)),
      );
    }

    if (_news.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Text('Şu an için güncel haber bulunamadı.'),
      );
    }

    return SizedBox(
      height: 150, // Daha kompakt ve şık yükseklik
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        itemCount: _news.length > 10 ? 10 : _news.length,
        itemBuilder: (context, index) {
          final item = _news[index];

          return GestureDetector(
            onTap: () => _launchUrl(item.link),
            child: Container(
              width: 280,
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Üst Kısım: Minik Etiket ve Kaynak İkonu
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'PİYASA ANALİZİ',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.arrow_outward,
                        size: 14,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Haber Başlığı (Daha okunabilir ve şık tipografi)
                  Text(
                    item.title ?? 'Başlık yok',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      height: 1.4,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// --- DİĞER ALT BİLEŞENLER (DEĞİŞTİRİLMEDİ) ---

class _MarketCard extends StatelessWidget {
  final String title;
  final String value;
  final String change;
  final bool isPositive;

  const _MarketCard({
    required this.title,
    required this.value,
    required this.change,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                isPositive ? Icons.trending_up : Icons.trending_down,
                size: 16,
                color: isPositive ? Colors.green : Colors.red,
              ),
              const SizedBox(width: 4),
              Text(
                change,
                style: TextStyle(
                  color: isPositive ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StockCard extends StatelessWidget {
  final String name;
  final String code;
  final String sector;
  final String price;
  final String change;
  final bool isPositive;

  const _StockCard({
    required this.name,
    required this.code,
    required this.sector,
    required this.price,
    required this.change,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black87,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            '$code • $sector',
            style: const TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                price,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Row(
                children: [
                  Icon(
                    isPositive ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                    color: isPositive ? Colors.green : Colors.red,
                  ),
                  Text(
                    change,
                    style: TextStyle(
                      color: isPositive ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WatchlistItem extends StatelessWidget {
  final String code;
  final String name;
  final String price;
  final String change;
  final bool isPositive;
  final Color logoColor;

  const _WatchlistItem({
    required this.code,
    required this.name,
    required this.price,
    required this.change,
    required this.isPositive,
    required this.logoColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: logoColor,
              borderRadius: BorderRadius.circular(6),
            ),
            alignment: Alignment.center,
            child: Text(
              code,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 10,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Colors.black87,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                price,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              Text(
                change,
                style: TextStyle(
                  color: isPositive ? Colors.green : Colors.red,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
