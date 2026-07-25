import 'package:flutter/material.dart';
import 'models/stock_model.dart';
import 'services/api_service.dart'; // ApiService dosyanın yolu

class CompareScreen extends StatefulWidget {
  const CompareScreen({super.key});

  @override
  State<CompareScreen> createState() => _CompareScreenState();
}

class _CompareScreenState extends State<CompareScreen> {
  // Başlangıçta seçili olan hisseler
  late StockModel _stock1;
  late StockModel _stock2;

  // Canlı API verilerini tutacağımız değişkenler
  Map<String, dynamic>? _apiData1;
  Map<String, dynamic>? _apiData2;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // İlk açılışta THYAO ve PEKGY seçili gelsin
    _stock1 = mockStocks[0];
    _stock2 = mockStocks[1];

    // Sayfa açılır açılmaz canlı verileri çek
    _fetchComparisonData();
  }

  // API'den iki hissenin verilerini paralel olarak çeken fonksiyon
  Future<void> _fetchComparisonData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Yahoo Finance Borsa İstanbul hisseleri için sonuna .IS ekliyoruz
      final sym1 = '${_stock1.ticker}.IS';
      final sym2 = '${_stock2.ticker}.IS';

      // İki isteği aynı anda atarak bekleme süresini yarıya indiriyoruz
      final results = await Future.wait([
        ApiService().getDetailedFinancialData(sym1),
        ApiService().getDetailedFinancialData(sym2),
      ]);

      if (mounted) {
        setState(() {
          _apiData1 = results[0];
          _apiData2 = results[1];
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

  // API'den gelen karmaşık JSON içerisinden istediğimiz metriği güvenle alan yardımcı fonksiyon
  String _getApiMetric(
    Map<String, dynamic>? data,
    String key, {
    String fallback = "-",
  }) {
    if (data == null) return fallback;
    try {
      // Kullandığın API'nin (RapidAPI vs.) JSON formatına göre burayı güncelleyebilirsin.
      // Genelde 'body' içinde 'fmt' (formatlanmış) olarak gelir.
      if (data['body'] != null && data['body'][key] != null) {
        return data['body'][key]['fmt'] ?? data['body'][key].toString();
      }
      return data[key]?.toString() ?? fallback;
    } catch (e) {
      return fallback;
    }
  }

  // Hisse Seçim Penceresini (Bottom Sheet) Açan Fonksiyon
  void _showStockPicker(int stockIndex) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Hisse Seçin',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: mockStocks.length,
                  itemBuilder: (context, index) {
                    final stock = mockStocks[index];
                    return ListTile(
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE2E8F0),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          stock.logoText,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      title: Text(
                        stock.ticker,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(stock.name),
                      trailing: const Icon(
                        Icons.add_circle_outline,
                        color: Colors.blueGrey,
                      ),
                      onTap: () {
                        // KENDİ KENDİSİYLE KARŞILAŞTIRMA KONTROLÜ
                        if (stockIndex == 1 && stock.ticker == _stock2.ticker) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Aynı hisseyi kendisiyle karşılaştıramazsınız.',
                              ),
                            ),
                          );
                          return; // İşlemi iptal et
                        } else if (stockIndex == 2 &&
                            stock.ticker == _stock1.ticker) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Aynı hisseyi kendisiyle karşılaştıramazsınız.',
                              ),
                            ),
                          );
                          return; // İşlemi iptal et
                        }

                        // Eğer farklı bir hisse seçildiyse normal akışa devam et
                        Navigator.pop(context);

                        setState(() {
                          if (stockIndex == 1) {
                            _stock1 = stock;
                          } else {
                            _stock2 = stock;
                          }
                        });

                        // Yeni hisse seçildiği için API'den yeni verileri çek
                        _fetchComparisonData();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hisse Karşılaştır',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'İki farklı şirketi yan yana getirin ve temel finansal rasyoları analiz edin.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade700,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),

            _buildStockSelector(_stock1, 1),
            const SizedBox(height: 12),
            _buildStockSelector(_stock2, 2),
            const SizedBox(height: 24),

            // Tabloyu yüklenme durumuna göre göster
            _isLoading
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: CircularProgressIndicator(
                        color: Color(0xFF111827),
                      ),
                    ),
                  )
                : _buildMetricsTable(),

            const SizedBox(height: 24),
            _buildAnalystOpinion(),
            const SizedBox(height: 24),
            _buildAIAnalysisCard(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildStockSelector(StockModel stock, int index) {
    return InkWell(
      onTap: () => _showStockPicker(index),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Text(
                stock.logoText,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stock.ticker,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  stock.name,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
              ],
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.swap_vert, color: Colors.grey.shade700),
            ),
          ],
        ),
      ),
    );
  }

  // Dinamik Tablo
  Widget _buildMetricsTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'TEMEL ANALİZ METRİKLERİ',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                    color: Colors.black54,
                    letterSpacing: 1.0,
                  ),
                ),
                Icon(Icons.info_outline, color: Colors.grey.shade600, size: 20),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            child: Row(
              children: [
                const Expanded(
                  flex: 2,
                  child: Text(
                    'METRİK',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    _stock1.ticker,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    _stock2.ticker,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          _buildMetricRow(
            'Fiyat',
            '${_getApiMetric(_apiData1, 'currentPrice', fallback: _stock1.price)}\nTL',
            '${_getApiMetric(_apiData2, 'currentPrice', fallback: _stock2.price)}\nTL',
          ),

          // Günlük değişim genellikle artı/eksi olduğu için renklendirmesi korundu.
          // İstemezsen buradaki val1Color ve val2Color satırlarını da silebilirsin.
          _buildMetricRow(
            'Günlük\nDeğişim',
            _stock1.change,
            _stock2.change,
            val1Color: _stock1.isChangePos ? Colors.green : Colors.red,
            val2Color: _stock2.isChangePos ? Colors.green : Colors.red,
          ),

          // F/K (P/E) renklendirmesi kaldırıldı. Artık standart renk (siyah) olacak.
          _buildMetricRow(
            'F/K (P/E)',
            _getApiMetric(_apiData1, 'trailingPE', fallback: _stock1.pe),
            _getApiMetric(_apiData2, 'trailingPE', fallback: _stock2.pe),
          ),

          // PD/DD (P/B) renklendirmesi kaldırıldı. Artık standart renk (siyah) olacak.
          _buildMetricRow(
            'PD/DD\n(P/B)',
            _getApiMetric(_apiData1, 'priceToBook', fallback: _stock1.pb),
            _getApiMetric(_apiData2, 'priceToBook', fallback: _stock2.pb),
          ),

          _buildMetricRow(
            'Piyasa\nDeğeri',
            _getApiMetric(_apiData1, 'marketCap', fallback: _stock1.marketCap),
            _getApiMetric(_apiData2, 'marketCap', fallback: _stock2.marketCap),
          ),

          _buildMetricRow(
            'Temettü\nVerimi',
            _getApiMetric(
              _apiData1,
              'dividendYield',
              fallback: _stock1.dividend,
            ),
            _getApiMetric(
              _apiData2,
              'dividendYield',
              fallback: _stock2.dividend,
            ),
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildMetricRow(
    String title,
    String val1,
    String val2, {
    Color val1Color = Colors.black87,
    Color val2Color = Colors.black87,
    bool isLast = false,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  val1,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: val1Color,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  val2,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: val2Color,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (!isLast) const Divider(height: 1, color: Color(0xFFEEEEEE)),
      ],
    );
  }

  Widget _buildAnalystOpinion() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ANALİST GÖRÜŞÜ',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 13,
              color: Colors.black54,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 20),
          _buildAnalystRow(_stock1),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Divider(height: 1),
          ),
          _buildAnalystRow(_stock2),
        ],
      ),
    );
  }

  Widget _buildAnalystRow(StockModel stock) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              stock.ticker,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: stock.ratingBgColor,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                stock.ratingText,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                  color: stock.ratingTextColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: stock.ratingProgress,
          backgroundColor: Colors.grey.shade300,
          color: stock.ratingBarColor,
          minHeight: 6,
          borderRadius: BorderRadius.circular(4),
        ),
        const SizedBox(height: 12),
        Text(
          stock.analystComment,
          style: TextStyle(
            color: Colors.grey.shade700,
            fontSize: 13,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildAIAnalysisCard() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Yapay Zeka Analizi',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Seçili hisseler arasında ${_stock1.ticker}, matematiksel veriler ve tarihsel ortalamalara göre yapılan hesaplamalar neticesinde iskontolu işlem görmesiyle öne çıkıyor.',
            style: TextStyle(
              color: Colors.grey.shade300,
              fontSize: 15,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black87,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: const Text(
                'DETAYLI RAPORU İNDİR',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
