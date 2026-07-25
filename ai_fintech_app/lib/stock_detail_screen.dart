import 'package:flutter/material.dart';
import 'package:webfeed_plus/webfeed_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'services/api_service.dart';
import 'services/rss_service.dart';
import 'models/stock_model.dart';

class StockDetailScreen extends StatefulWidget {
  final String symbol;

  const StockDetailScreen({super.key, required this.symbol});

  @override
  State<StockDetailScreen> createState() => _StockDetailScreenState();
}

class _StockDetailScreenState extends State<StockDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  Map<String, dynamic>? _apiData;
  bool _isLoading = true;
  String _selectedTimeFilter = '1G';

  List<RssItem> _stockNews = [];
  bool _isNewsLoading = true;

  late StockModel _fallbackStock;

  final Map<String, String> _companyNames = {
    'THYAO': 'Türk Hava Yolları',
    'EREGL': 'Erdemir',
    'GARAN': 'Garanti BBVA',
    'ASELS': 'Aselsan',
    'SASA': 'Sasa Polyester',
    'HEKTS': 'Hektaş',
    'KCHOL': 'Koç Holding',
    'TUPRS': 'Tüpraş',
    'PGSUS': 'Pegasus Hava Yolları',
    'AKBNK': 'Akbank',
    'ISCTR': 'İş Bankası (C)',
    'SISE': 'Şişecam',
  };

  @override
  void initState() {
    super.initState();

    // Controller başlatılıyor ve dinleyici ekleniyor (Sekme geçişlerini sağlar)
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });

    _fallbackStock = mockStocks.firstWhere(
      (stock) => stock.ticker == widget.symbol,
      orElse: () => StockModel(
        ticker: widget.symbol,
        name: _companyNames[widget.symbol] ?? widget.symbol,
        price: '0.00',
        change: '%0.00',
        isChangePos: true,
        pe: '8.50',
        pb: '1.20',
        marketCap: '-',
        dividend: '-',
        logoText: widget.symbol.substring(0, 2),
        ratingText: '-',
        ratingBgColor: Colors.grey,
        ratingTextColor: Colors.white,
        ratingBarColor: Colors.grey,
        ratingProgress: 0.0,
        analystComment: '-',
        isPeGood: false,
        isPbGood: false,
      ),
    );

    _fetchStockData();
    _fetchNewsData();
  }

  Future<void> _fetchStockData() async {
    try {
      final data = await ApiService().getDetailedFinancialData(
        '${widget.symbol}.IS',
      );

      if (mounted) {
        setState(() {
          _apiData = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _fetchNewsData() async {
    try {
      final rssService = RssService();
      final allNews = await rssService.getTurkishNews();

      final companyName = _companyNames[widget.symbol] ?? widget.symbol;

      var filteredNews = allNews.where((item) {
        final title = (item.title ?? '').toUpperCase();
        final description = (item.description ?? '').toUpperCase();

        return title.contains(widget.symbol.toUpperCase()) ||
            title.contains(companyName.toUpperCase()) ||
            description.contains(widget.symbol.toUpperCase()) ||
            description.contains(companyName.toUpperCase());
      }).toList();

      filteredNews = filteredNews.take(3).toList();

      if (mounted) {
        setState(() {
          _stockNews = filteredNews;
          _isNewsLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isNewsLoading = false;
        });
      }
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

  String _getApiMetric(String key, {String fallback = "-"}) {
    if (_apiData == null) return fallback;
    try {
      if (_apiData!['body'] != null && _apiData!['body'][key] != null) {
        if (_apiData!['body'][key] is Map) {
          return _apiData!['body'][key]['fmt'] ??
              _apiData!['body'][key].toString();
        }
        return _apiData!['body'][key].toString();
      }
      return _apiData![key]?.toString() ?? fallback;
    } catch (e) {
      return fallback;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black87,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
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
            const SizedBox(width: 8),
            const Text(
              'AIFinTech',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
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
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.black87),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  _buildTabs(),
                  _buildSelectedTabContent(), // Kullanıcının seçtiği sekmeyi gösteren fonksiyon
                ],
              ),
            ),
    );
  }

  // HANGİ SEKMEYE TIKLANDIYSA ONU GETİREN FONKSİYON
  Widget _buildSelectedTabContent() {
    switch (_tabController.index) {
      case 0: // ÖZET SEKME
        return Column(
          children: [
            const SizedBox(height: 16),
            _buildChartSection(),
            _buildMetricsGrid(),
            _buildAIAnalysisSection(),
            _buildMarketNewsSection(),
          ],
        );
      case 1: // ÇARPANLAR SEKME
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 24.0, left: 16.0),
              child: Text(
                'TÜM TEMEL ÇARPANLAR',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ),
            _buildMetricsGrid(),
          ],
        );
      case 2: // BİLANÇO SEKME
        return _buildBilancoTab();
      case 3: // GELİR TABLOSU SEKME
        return _buildGelirTablosuTab();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildHeader() {
    final companyName = _companyNames[widget.symbol] ?? widget.symbol;
    final currentPrice = _getApiMetric(
      'currentPrice',
      fallback: _fallbackStock.price,
    );
    final changePercent = _fallbackStock.change;
    final isPos = _fallbackStock.isChangePos;
    final statusColor = isPos ? Colors.green.shade700 : Colors.red.shade700;
    final statusIcon = isPos ? Icons.arrow_drop_up : Icons.arrow_drop_down;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'BIST 100',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                companyName,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            widget.symbol,
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w900,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '₺$currentPrice',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 12),
              Icon(statusIcon, color: statusColor, size: 28),
              Text(
                changePercent,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: statusColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Son güncelleme: ${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}',
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        labelColor: Colors.black,
        unselectedLabelColor: Colors.grey,
        indicatorColor: Colors.black,
        indicatorWeight: 3,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        tabs: const [
          Tab(text: 'ÖZET'),
          Tab(text: 'ÇARPANLAR'),
          Tab(text: 'BİLANÇO'),
          Tab(text: 'GELİR TABL'),
        ],
      ),
    );
  }

  Widget _buildMetricsGrid() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.4,
        children: [
          MetricCard(
            title: 'F/K ORANI',
            value: _getApiMetric('trailingPE', fallback: _fallbackStock.pe),
            subtitle: 'Sektör Ort: Bekleniyor',
            progress: 0.3,
          ),
          MetricCard(
            title: 'PD/DD',
            value: _getApiMetric('priceToBook', fallback: _fallbackStock.pb),
            progress: 0.15,
          ),
          MetricCard(
            title: 'FD/FAVÖK',
            value: _getApiMetric('enterpriseToEbitda', fallback: '6.4'),
            progress: 0.4,
          ),
          MetricCard(
            title: 'ÖZSERMAYE KARLILIĞI',
            value: _getApiMetric('returnOnEquity', fallback: '%42.1'),
            progress: 0.8,
          ),
          MetricCard(
            title: 'BRÜT KAR MARJI',
            value: _getApiMetric('grossMargins', fallback: '%18.5'),
            progress: 0.35,
          ),
          MetricCard(
            title: 'BORÇ / ÖZKAYNAK',
            value: _getApiMetric('debtToEquity', fallback: '1.1x'),
            progress: 0.2,
          ),
        ],
      ),
    );
  }

  Widget _buildChartSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'FİYAT GRAFİĞİ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
              Row(
                children: [
                  _buildTimeFilter('1G'),
                  _buildTimeFilter('1H'),
                  _buildTimeFilter('1A'),
                  _buildTimeFilter('1Y'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 120,
            width: double.infinity,
            child: CustomPaint(painter: MockChartPainter()),
          ),
          const SizedBox(height: 12),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('09:00', style: TextStyle(color: Colors.grey, fontSize: 10)),
              Text('12:00', style: TextStyle(color: Colors.grey, fontSize: 10)),
              Text('15:00', style: TextStyle(color: Colors.grey, fontSize: 10)),
              Text('18:00', style: TextStyle(color: Colors.grey, fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }

  // Tıklanabilir ve dinamik hale getirilmiş filtre butonu
  Widget _buildTimeFilter(String text) {
    // Eğer butonun metni, seçili olan metne eşitse aktif (siyah) yap
    final isActive = _selectedTimeFilter == text;

    return GestureDetector(
      behavior: HitTestBehavior.opaque, // Tıklama alanını genişletmek için
      onTap: () {
        // Tıklandığında ekranı güncelle ve yeni seçileni kaydet
        setState(() {
          _selectedTimeFilter = text;
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 12.0, top: 4.0, bottom: 4.0),
        child: Column(
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                color: isActive ? Colors.black : Colors.grey,
              ),
            ),
            if (isActive)
              Container(
                margin: const EdgeInsets.only(top: 4),
                height: 2,
                width: 12,
                color: Colors.black,
              )
            else
              // Aktif olmadığında altının boş kalıp yazıların zıplamasını engellemek için
              const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }

  Widget _buildAIAnalysisSection() {
    double peValue =
        double.tryParse(
          _getApiMetric(
            'trailingPE',
            fallback: _fallbackStock.pe,
          ).replaceAll(',', '.'),
        ) ??
        0.0;
    double pbValue =
        double.tryParse(
          _getApiMetric(
            'priceToBook',
            fallback: _fallbackStock.pb,
          ).replaceAll(',', '.'),
        ) ??
        0.0;

    String aiComment = "Veriler analiz ediliyor...";

    if (peValue > 0 && peValue < 10 && pbValue > 0 && pbValue < 2) {
      aiComment =
          "${widget.symbol}'nun düşük F/K ($peValue) ve PD/DD ($pbValue) oranları, temel analiz modellerimize göre şu an iskontolu bir işlem gördüğüne işaret ediyor. Uzun vadeli alım fırsatı sunabilir.";
    } else if (peValue >= 10 && peValue <= 20) {
      aiComment =
          "${widget.symbol} hissesi sektör ortalamalarına paralel fiyatlanıyor (F/K: $peValue). Operasyonel karlılıktaki artış veya düşüş trendi hissenin kısa vadeli yönünü belirleyecektir.";
    } else if (peValue > 20) {
      aiComment =
          "Algoritmalarımız, ${widget.symbol} hissesinin yüksek F/K ($peValue) çarpanıyla işlem gördüğünü tespit etti. Şirketin agresif büyüme beklentileri fiyatlanmış olabilir, temkinli yaklaşılmalı.";
    } else {
      aiComment =
          "${widget.symbol} için temel rasyo analizi gerçekleştirildi. Hissenin mevcut makroekonomik koşullara ve sektör dinamiklerine karşı gösterdiği duyarlılık takip ediliyor.";
    }

    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text(
              'YAPAY ZEKA ANALİZ MERKEZİ',
              style: TextStyle(
                color: Color(0xFF047857),
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'TEMEL VERİ ANALİZİ',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            aiComment,
            style: const TextStyle(
              fontSize: 14,
              height: 1.5,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'HABER DUYARLILIĞI',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Piyasa duyarlılığı analizimize göre genel haber akışı stabil yönde seyrediyor. Kurumsal alıcıların hisse üzerindeki hareketleri destekleyici nitelikte.",
            style: TextStyle(fontSize: 14, height: 1.5, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildMarketNewsSection() {
    return Container(
      width: double.infinity,
      color: const Color(0xFF0F172A),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${widget.symbol} HABERLERİ',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),

          if (_isNewsLoading)
            const Center(child: CircularProgressIndicator(color: Colors.white))
          else if (_stockNews.isEmpty)
            const Text(
              'Şu an için güncel haber bulunmuyor.',
              style: TextStyle(color: Colors.white70),
            )
          else
            ..._stockNews.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;

              final pubDate = item.pubDate != null
                  ? '${item.pubDate!.hour.toString().padLeft(2, '0')}:${item.pubDate!.minute.toString().padLeft(2, '0')}'
                  : 'Bugün';

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => _launchUrl(item.link),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title ?? 'Başlık yok',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          pubDate,
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (index != _stockNews.length - 1)
                    const Divider(color: Colors.white24, height: 32),
                ],
              );
            }),

          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white30),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'TÜM HABERLER',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- YENİ BİLANÇO VE GELİR TABLOSU ARAYÜZLERİ ---

  Widget _buildBilancoTab() {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFinancialRow(
            'Dönen Varlıklar',
            '45.2 Milyar TL',
            isHeader: true,
          ),
          const Divider(),
          _buildFinancialRow('Nakit ve Benzerleri', '12.4 Milyar TL'),
          _buildFinancialRow('Ticari Alacaklar', '18.1 Milyar TL'),
          const SizedBox(height: 16),
          _buildFinancialRow(
            'Duran Varlıklar',
            '112.4 Milyar TL',
            isHeader: true,
          ),
          const Divider(),
          _buildFinancialRow('Maddi Duran Varlıklar', '85.6 Milyar TL'),
          const SizedBox(height: 16),
          _buildFinancialRow(
            'Toplam Yükümlülükler',
            '68.6 Milyar TL',
            isHeader: true,
          ),
          const Divider(),
          _buildFinancialRow(
            'Özkaynaklar',
            '89.0 Milyar TL',
            isHeader: true,
            textColor: Colors.green.shade700,
          ),
        ],
      ),
    );
  }

  Widget _buildGelirTablosuTab() {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFinancialRow(
            'Satış Gelirleri',
            '125.4 Milyar TL',
            isHeader: true,
          ),
          const Divider(),
          _buildFinancialRow('Satışların Maliyeti (-)', '85.2 Milyar TL'),
          const SizedBox(height: 8),
          _buildFinancialRow(
            'Brüt Kar',
            '40.2 Milyar TL',
            isHeader: true,
            textColor: Colors.black87,
          ),
          const Divider(),
          _buildFinancialRow('Faaliyet Giderleri (-)', '15.1 Milyar TL'),
          _buildFinancialRow(
            'Esas Faaliyet Karı',
            '25.1 Milyar TL',
            isHeader: true,
            textColor: Colors.black87,
          ),
          const Divider(),
          _buildFinancialRow(
            'Net Dönem Karı',
            '18.4 Milyar TL',
            isHeader: true,
            textColor: Colors.green.shade700,
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialRow(
    String title,
    String value, {
    bool isHeader = false,
    Color? textColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: isHeader ? Colors.black87 : Colors.grey.shade700,
              fontWeight: isHeader ? FontWeight.bold : FontWeight.w500,
              fontSize: isHeader ? 14 : 13,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: isHeader ? 14 : 13,
              color: textColor ?? Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

class MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final double progress;

  const MetricCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    const Color uniformColor = Colors.black87;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: uniformColor,
            ),
          ),
          // Spacer barı daima aşağı iter
          const Spacer(),
          Stack(
            children: [
              Container(
                height: 4,
                width: double.infinity,
                color: const Color(0xFFF1F5F9),
              ),
              FractionallySizedBox(
                widthFactor: progress,
                child: Container(height: 4, color: uniformColor),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // ÇÖZÜM BURASI: Alt metin olsa da olmasa da hep 14 piksel yer ayrılır, barlar hizalanır.
          SizedBox(
            height: 14,
            child: subtitle != null
                ? Text(
                    subtitle!,
                    style: const TextStyle(color: Colors.grey, fontSize: 10),
                  )
                : null,
          ),
        ],
      ),
    );
  }
}

class MockChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF047857)
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    path.moveTo(0, size.height * 0.9);
    path.lineTo(size.width * 0.1, size.height * 0.85);
    path.lineTo(size.width * 0.2, size.height * 0.88);
    path.lineTo(size.width * 0.35, size.height * 0.65);
    path.lineTo(size.width * 0.45, size.height * 0.70);
    path.lineTo(size.width * 0.55, size.height * 0.50);
    path.lineTo(size.width * 0.65, size.height * 0.55);
    path.lineTo(size.width * 0.75, size.height * 0.30);
    path.lineTo(size.width * 0.85, size.height * 0.35);
    path.lineTo(size.width * 0.95, size.height * 0.1);
    path.lineTo(size.width, size.height * 0.15);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
