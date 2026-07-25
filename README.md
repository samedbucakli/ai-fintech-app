# 📈 AI Fintech App

Kapsamlı bir finansal analiz ve portföy takip mobil uygulaması. Kullanıcılara anlık piyasa verilerini sunarken, detaylı şirket analizleri ve interaktif grafikler ile yatırımlarını takip etme imkanı sağlar. 

**Not:** Bu uygulama bir bilgi teknolojileri öğrencisi projesi olarak geliştirilmektedir ve ağırlıklı olarak Borsa İstanbul (BİST) hisselerine yönelik temel analiz ve rasyo takibi yapmayı hedeflemektedir.

## ⚠️ API ve Canlı Veri Durumu

Uygulama şu an test ve geliştirme aşamasındadır. Kullanılan mevcut API sağlayıcısının ücretsiz istek kotası (limit) dolduğu için, uygulamadaki **canlı veri çekim işlemi geçici olarak duraklatılmıştır.** 

Finansal verilerin (özellikle BİST verilerinin) daha güvenilir, stabil ve kesintisiz bir şekilde uygulamaya entegre edilebilmesi için sistemin **Fintables** gibi profesyonel ve sağlam bir API servis sağlayıcısına taşınması planlanmaktadır. Daha güçlü bir altyapıdan sağlanacak yeni bir API anahtarı (API key) ile birlikte, uygulamanın veri çekim mimarisi çok daha güvenli hale getirilecek ve canlı veri akışı yeniden aktif edilecektir.

## ✨ Özellikler

*   **Detaylı Hisse Analizi:** Hisse senedi detay ekranında Özet, Çarpanlar, Bilanço ve Gelir Tablosu olmak üzere 4 sekmeli yapı.
*   **İnteraktif Fiyat Grafikleri:** 1G, 1H, 1A ve 1Y gibi dinamik zaman filtreleri ile geçmiş veri analizi.
*   **Modern Arayüz (UI):** Odaklanmayı kolaylaştıran, "Koyu Gri/Siyah" temalı standartlaştırılmış finansal metrik kartları.
*   **Güvenli Altyapı:** Çevre değişkenleri (`.env`) kullanılarak API anahtarlarının güvenli ve gizli yönetimi.

## 🛠️ Kullanılan Teknolojiler

*   **Mobil Geliştirme:** Flutter & Dart
*   **Güvenlik:** `flutter_dotenv` 

## 🚀 Kurulum ve Çalıştırma

Projeyi yerel ortamında çalıştırmak için aşağıdaki adımları izleyebilirsin.

1.  **Projeyi Klonlayın:**
    ```bash
    git clone [https://github.com/samedbucakli/ai-fintech-app.git](https://github.com/samedbucakli/ai-fintech-app.git)
    ```
2.  **Bağımlılıkları Yükleyin:**
    ```bash
    cd ai-fintech-app
    flutter pub get
    ```
3.  **Çevre Değişkenlerini (Environment Variables) Ayarlayın:**
    Ana dizinde (root) `.env` adında bir dosya oluşturun ve API anahtarınızı ekleyin. *(Mevcut durumda kota dolu olduğu için kendi test anahtarınızı kullanmanız gerekebilir).*
    ```env
    API_KEY=senin_api_anahtarin_buraya_gelecek
    ```
4.  **Uygulamayı Çalıştırın:**
    ```bash
    flutter run
    ```
