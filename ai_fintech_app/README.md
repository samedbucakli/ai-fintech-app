# 📈 AI Fintech & Piyasa Analiz Uygulaması

Borsa İstanbul (BİST) yatırımcıları için tasarlanmış, yapay zeka destekli kapsamlı bir piyasa takibi ve hisse analizi aracı.

> **📌 Geliştirici Notu:** Bu proje, bir Bilişim Sistemleri ve Teknolojileri bölümü öğrencisi tarafından uçtan uca yazılım mimarisi ve finansal teknoloji pratikleri kapsamında geliştirilmektedir.

---

## 🚀 Öne Çıkan Özellikler

* 🤖 **Yapay Zeka Destekli Analizler:** Hisselerin genel piyasa durumunun ve hisseye özel son dakika haberlerinin yapay zeka tarafından okunabilir, net metinler halinde özetlenmesi.
* ⚖️ **Hisse Karşılaştırma Modülü:** Yatırım kararlarını veriye dayandırmak için seçilen 2 farklı hissenin performans ve rasyolarının yan yana detaylı kıyaslaması.
* 📰 **Sektörel Takip ve Gelişmiş Haber Akışı:** Piyasada yükselen ve düşen sektörlerin anlık listelenmesi; şirket bazlı güncel haber akışlarının filtrelenerek sunulması.
* 📊 **Kapsamlı Temel Analiz Arayüzü:** Her hisse senedi için; Özet, Çarpanlar, Bilanço ve Gelir Tablosu olmak üzere 4 sekmeli derinlemesine veri görünümü.
* 📈 **İnteraktif Zaman Çizelgeleri:** 1G, 1H, 1A, 1Y periyotlarında dinamik olarak güncellenen ve kullanıcı etkileşimine duyarlı fiyat grafikleri.

---

## ⚠️ Canlı Veri ve API Durumu (Önemli)

Uygulamanın mimarisi anlık veri işleyecek şekilde tasarlanmış olup şu an aktif geliştirme/test aşamasındadır. Kullanılan mevcut API sağlayıcısının ücretsiz istek kotalarının yetersiz kalması sebebiyle **canlı veri akışı geçici olarak duraklatılmıştır.**

Sistemin veri güvenliğini artırmak ve kullanıcılara kesintisiz, stabil bir deneyim sunmak amacıyla, altyapının **Fintables** gibi profesyonel ve BİST verilerinde uzmanlaşmış bir API servis sağlayıcısına entegre edilmesi hedeflenmektedir. Bu geçiş sağlandığında uygulamanın tüm canlı veri modülleri tam kapasiteyle çalışacaktır.

---

## 🛠 Teknolojik Altyapı

* **Çerçeve (Framework):** Flutter
* **Dil:** Dart
* **Veri Kaynağı:** Yahoo Finance / RapidAPI (Mevcut Test Altyapısı)
* **Güvenlik:** flutter_dotenv entegrasyonu ile API anahtarlarının ve hassas verilerin yerel ortamda gizlenmesi.
* **Arayüz (UI):** Finansal odaklanmayı artıran koyu gri/siyah tema ve standartlaştırılmış metrik kartları.

---

## 💻 Kurulum Adımları

Projeyi kendi yerel ortamınızda çalıştırmak ve kodları incelemek için aşağıdaki adımları takip edebilirsiniz:

**1. Depoyu Klonlayın:**
git clone [https://github.com/](https://github.com/)/ai-fintech-app.git
(Not: Kodu kopyalarken  kısmını kendi güncel GitHub kullanıcı adınız ile değiştirmeyi unutmayın.)

**2. Proje Dizinine Girin ve Bağımlılıkları Yükleyin:**
cd ai-fintech-app
flutter pub get

**3. Çevre Değişkenlerini (.env) Yapılandırın:**
Projenin ana dizininde (root) bir .env dosyası oluşturun ve RapidAPI test ortamı için gerekli olan anahtarlarınızı aşağıdaki formata uygun şekilde ekleyin:

RAPIDAPI_KEY=kendi_api_anahtariniz_buraya_gelecek
RAPIDAPI_HOST=apidojo-yahoo-finance-v1.p.rapidapi.com

**4. Uygulamayı Başlatın:**
flutter run
