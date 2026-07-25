import 'package:flutter/material.dart';

class StockModel {
  final String ticker;
  final String name;
  final String logoText;
  final String price;
  final String change;
  final bool isChangePos;
  final String pe;
  final bool isPeGood;
  final String pb;
  final bool isPbGood;
  final String marketCap;
  final String dividend;

  // Analist Verileri
  final String ratingText;
  final Color ratingBgColor;
  final Color ratingTextColor;
  final double ratingProgress;
  final Color ratingBarColor;
  final String analystComment;

  StockModel({
    required this.ticker,
    required this.name,
    required this.logoText,
    required this.price,
    required this.change,
    required this.isChangePos,
    required this.pe,
    required this.isPeGood,
    required this.pb,
    required this.isPbGood,
    required this.marketCap,
    required this.dividend,
    required this.ratingText,
    required this.ratingBgColor,
    required this.ratingTextColor,
    required this.ratingProgress,
    required this.ratingBarColor,
    required this.analystComment,
  });
}

// Tüm uygulamada kullanabileceğimiz örnek hisse listesi
final List<StockModel> mockStocks = [
  StockModel(
    ticker: 'THYAO',
    name: 'Türk Hava Yolları',
    logoText: 'THY',
    price: '294.50',
    change: '+1.24%',
    isChangePos: true,
    pe: '4.52',
    isPeGood: true,
    pb: '1.10',
    isPbGood: true,
    marketCap: '406.41 B',
    dividend: '0.00%',
    ratingText: 'GÜÇLÜ AL',
    ratingBgColor: const Color(0xFF69F0AE),
    ratingTextColor: Colors.black87,
    ratingProgress: 0.85,
    ratingBarColor: const Color(0xFF008955),
    analystComment:
        'Artan turizm talebi ve kargo gelirleri finansalları desteklemeye devam ediyor.',
  ),
  StockModel(
    ticker: 'PEKGY',
    name: 'Peker GYO',
    logoText: 'PKY',
    price: '12.18',
    change: '-0.85%',
    isChangePos: false,
    pe: '8.12',
    isPeGood: false,
    pb: '2.34',
    isPbGood: false,
    marketCap: '7.89 B',
    dividend: '2.15%',
    ratingText: 'TUT',
    ratingBgColor: Colors.blue.shade100,
    ratingTextColor: Colors.black87,
    ratingProgress: 0.50,
    ratingBarColor: Colors.blueGrey,
    analystComment:
        'Gayrimenkul sektöründeki faiz baskısı büyüme hızını sınırlayabilir.',
  ),
  StockModel(
    ticker: 'GARAN',
    name: 'Garanti BBVA',
    logoText: 'GRN',
    price: '68.45',
    change: '+0.60%',
    isChangePos: true,
    pe: '3.20',
    isPeGood: true,
    pb: '0.95',
    isPbGood: true,
    marketCap: '287.5 B',
    dividend: '4.50%',
    ratingText: 'AL',
    ratingBgColor: Colors.green.shade200,
    ratingTextColor: Colors.black87,
    ratingProgress: 0.70,
    ratingBarColor: Colors.green,
    analystComment:
        'Net faiz marjındaki toparlanma ve güçlü aktif kalitesi karlılığı destekliyor.',
  ),
  StockModel(
    ticker: 'ASELS',
    name: 'Aselsan',
    logoText: 'ASL',
    price: '58.20',
    change: '+1.25%',
    isChangePos: true,
    pe: '12.50',
    isPeGood: false,
    pb: '4.10',
    isPbGood: false,
    marketCap: '265.4 B',
    dividend: '1.10%',
    ratingText: 'GÜÇLÜ AL',
    ratingBgColor: const Color(0xFF69F0AE),
    ratingTextColor: Colors.black87,
    ratingProgress: 0.90,
    ratingBarColor: const Color(0xFF008955),
    analystComment:
        'Artan bakiye siparişler (backlog) ve yeni projeler ciro büyümesini garantiliyor.',
  ),
  StockModel(
    ticker: 'EREGL',
    name: 'Erdemir',
    logoText: 'ERG',
    price: '45.10',
    change: '-0.40%',
    isChangePos: false,
    pe: '14.20',
    isPeGood: false,
    pb: '1.45',
    isPbGood: true,
    marketCap: '157.8 B',
    dividend: '6.20%',
    ratingText: 'TUT',
    ratingBgColor: Colors.blue.shade100,
    ratingTextColor: Colors.black87,
    ratingProgress: 0.45,
    ratingBarColor: Colors.blueGrey,
    analystComment:
        'Küresel çelik fiyatlarındaki dalgalanma kar marjları üzerinde baskı yaratıyor.',
  ),
];
