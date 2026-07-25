import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  // ==========================================
  // 1. AŞAMA: HIZLI FİYAT ÇEKME FONKSİYONU (ORTAK)
  // ==========================================

  Future<Map<String, dynamic>?> _getFastPriceData(String symbol) async {
    try {
      final url = Uri.parse(
        'https://query1.finance.yahoo.com/v8/finance/chart/$symbol',
      );
      final response = await http.get(
        url,
        headers: {'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final meta = data['chart']['result'][0]['meta'];

        final double fiyat = double.parse(
          meta['regularMarketPrice'].toString(),
        );
        final double dunkuKapanis = double.parse(
          meta['previousClose'].toString(),
        );
        final double degisimYuzdesi =
            ((fiyat - dunkuKapanis) / dunkuKapanis) * 100;

        return {
          'symbol': symbol,
          'price': fiyat,
          'changePercent': degisimYuzdesi,
        };
      }
      return null;
    } catch (e) {
      if (kDebugMode) debugPrint("Hızlı veri hatası ($symbol): $e");
      return null;
    }
  }

  // ==========================================
  // ANA SAYFA PİYASA ÖZETİ (BİST, ALTIN, DOLAR)
  // ==========================================

  Future<List<Map<String, dynamic>>> getMarketSummaryData() async {
    final tickers = ['XU100.IS', 'GC=F', 'TRY=X'];
    List<Map<String, dynamic>> results = [];

    for (String ticker in tickers) {
      final data = await _getFastPriceData(ticker);
      if (data != null) {
        results.add(data);
      }
    }
    return results;
  }

  // ==========================================
  // 2. AŞAMA: KAZANANLAR / KAYBEDENLER
  // ==========================================

  Future<List<Map<String, dynamic>>> getPopularBistStocks() async {
    final tickers = [
      'THYAO.IS',
      'EREGL.IS',
      'SASA.IS',
      'HEKTS.IS',
      'GARAN.IS',
      'ASELS.IS',
      'KCHOL.IS',
      'TUPRS.IS',
    ];

    List<Map<String, dynamic>> results = [];

    for (String ticker in tickers) {
      final data = await _getFastPriceData(ticker);
      if (data != null) {
        results.add({
          'symbol': data['symbol'],
          'regularMarketPrice': data['price'],
          'regularMarketChangePercent': data['changePercent'],
        });
      }
    }
    return results;
  }

  // ==========================================
  // 3. AŞAMA: DETAYLI HİSSE ANALİZİ (RAPID-API)
  // ==========================================

  Future<Map<String, dynamic>?> getDetailedFinancialData(String symbol) async {
    final apiKey = dotenv.env['RAPID_API_KEY'];
    final apiHost = dotenv.env['RAPID_API_HOST'];

    final url = Uri.parse(
      'https://$apiHost/api/v1/markets/stock/modules?ticker=$symbol&module=financial-data',
    );

    try {
      final response = await http.get(
        url,
        headers: {
          'X-RapidAPI-Key': apiKey ?? '',
          'X-RapidAPI-Host': apiHost ?? '',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  // ==========================================
  // 4. AŞAMA: İZLEME LİSTESİ VERİLERİ (TL ÇEVİRİLİ)
  // ==========================================

  Future<List<Map<String, dynamic>>> getWatchlistData() async {
    final tickers = ['GARAN.IS', 'ASELS.IS', 'SI=F', 'HG=F'];
    List<Map<String, dynamic>> results = [];

    // 1. Anlık Dolar/TL kurunu çekiyoruz
    final usdTryData = await _getFastPriceData('TRY=X');
    // Eğer kur çekilemezse varsayılan bir değer (örneğin 33.0) veya 1.0 kullanıyoruz hata almamak için
    final double usdToTryRate = usdTryData != null ? usdTryData['price'] : 1.0;

    // 2. Hisseleri ve emtiaları dönüyoruz
    for (String ticker in tickers) {
      final data = await _getFastPriceData(ticker);
      if (data != null) {
        // Eğer gelen veri Gümüş (SI=F) veya Bakır (HG=F) ise Dolar kurunu TL'ye çevir
        if (ticker == 'SI=F' || ticker == 'HG=F') {
          data['price'] = data['price'] * usdToTryRate;
        }

        results.add(data);
      }
    }
    return results;
  }

  // ==========================================
  // 5. AŞAMA: SEKTÖR PERFORMANSLARI (ANALİZ SAYFASI)
  // ==========================================

  Future<List<Map<String, dynamic>>> getSectorPerformances() async {
    // Çekilecek BIST Sektör Endeksleri ve Ekranda Görünecek İsimleri
    final Map<String, String> sectorTickers = {
      'XBANK.IS': 'Bankacılık',
      'XUSIN.IS': 'Sanayi',
      'XUTEK.IS': 'Teknoloji',
      'XUHIZ.IS': 'Hizmetler',
      'XHOLD.IS': 'Holding',
    };

    List<Map<String, dynamic>> results = [];

    for (var entry in sectorTickers.entries) {
      final data = await _getFastPriceData(entry.key);
      if (data != null) {
        results.add({
          'symbol': entry.key,
          'name': entry.value,
          'changePercent': data['changePercent'],
        });
      }
    }

    // Verileri yüzde değişimine göre büyükten küçüğe sıralayalım (En çok yükselen en üstte)
    results.sort((a, b) => b['changePercent'].compareTo(a['changePercent']));

    return results;
  }
} // <--- ApiService SINIFININ BİTİŞ PARANTEZİ
