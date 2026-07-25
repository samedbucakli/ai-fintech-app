import 'dart:convert'; // UTF-8 decode için gerekli
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:webfeed_plus/webfeed_plus.dart';

class RssService {
  static const String _rssUrl = 'https://tr.investing.com/rss/news_285.rss';

  Future<List<RssItem>> getTurkishNews() async {
    try {
      final response = await http.get(Uri.parse(_rssUrl));

      if (response.statusCode == 200) {
        // BURASI DÜZELTİLDİ: Türkçe karakterlerin bozulmaması için bodyBytes UTF-8 olarak decode ediliyor
        final utf8Body = utf8.decode(response.bodyBytes);

        final feed = RssFeed.parse(utf8Body);
        return feed.items ?? [];
      } else {
        throw Exception(
          'RSS verisi alınamadı. Durum Kodu: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('RSS Çekme Hatası: $e');
      }
      return [];
    }
  }
}
