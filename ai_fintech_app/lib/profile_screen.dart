import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFFF8F9FA,
      ), // Uygulamanın genel arka plan rengi
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
            icon: const Icon(
              Icons.notifications_none,
              color: Colors.black87,
              size: 28,
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          children: [
            // 1. Profil Resmi ve Durum Noktası
            _buildProfileAvatar(),
            const SizedBox(height: 16),

            // 2. İsim ve E-posta
            const Text(
              'Selin Yılmaz',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A), // Çok koyu lacivert/siyah
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'selin@example.com',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 32),

            // 3. Abonelik Kartı
            _buildSubscriptionCard(),
            const SizedBox(height: 32),

            // 4. Ayarlar Menüsü Listesi
            _buildSettingsMenu(),
            const SizedBox(height: 48),

            // 5. Çıkış Yap Butonu
            _buildLogoutButton(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // --- Alt Bileşenler (Widgets) ---

  Widget _buildProfileAvatar() {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        // Güncellenmiş Profil Görseli Alanı
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white,
              width: 4,
            ), // Dışındaki beyaz çerçeve efekti
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            // Gri arka plan ve yazı yerine görseli ekledik
            image: const DecorationImage(
              image: AssetImage('assets/images/user_logo.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Yeşil Aktif Noktası
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: const Color(0xFF059669), // Canlı yeşil
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
          ),
        ),
      ],
    );
  }

  Widget _buildSubscriptionCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Yeşil Kare İkon Alanı
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFF69F0AE), // Açık yeşil / Mint
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: const Text(
                  '+',
                  style: TextStyle(color: Colors.black54, fontSize: 10),
                ), // Görseldeki detayı simüle etmek için
              ),
              const SizedBox(width: 16),
              // Metinler ve Rozet
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ABONELİK DURUMU',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Text(
                          'Premium',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Aktif Rozeti
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'AKTİF',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF059669),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Yönet Butonu
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black, // Siyah Buton
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Yönet',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsMenu() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          _buildMenuTile(
            icon: Icons.manage_accounts_outlined,
            title: 'Profil Bilgileri',
          ),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          _buildMenuTile(
            icon: Icons.shield_outlined,
            title: 'Güvenlik ve Şifre',
          ),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          _buildMenuTile(
            icon: Icons.settings_outlined,
            title: 'Uygulama Ayarları',
          ),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          _buildMenuTile(icon: Icons.help_outline, title: 'Yardım ve Destek'),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          _buildMenuTile(
            icon: Icons.info_outline,
            title: 'Hakkımızda',
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    bool isLast = false,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 8.0,
      ),
      leading: Icon(icon, color: Colors.black87, size: 26),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.black45),
      onTap: () {
        // İlgili sayfaya yönlendirme kodları buraya gelecek
      },
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {
          // Çıkış yapma işlemleri
        },
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          side: BorderSide(color: Colors.red.shade700), // Kırmızı kenarlık
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout, color: Colors.red.shade700, size: 22),
            const SizedBox(width: 8),
            Text(
              'Çıkış Yap',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.red.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
