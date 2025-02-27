// lib/pages/profile_page.dart - Çıkış işlevi eklenmiş

import 'package:flutter/material.dart';
import '../models/user_model.dart';

// Alt sayfalar için forward declarations
import 'profile/personal_info_page.dart';
import 'profile/settings_page.dart';
import 'profile/support_page.dart';
// Login sayfası import edildi
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  final UserModel? user;

  const ProfilePage({
    Key? key,
    this.user,
  }) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late UserModel _user;

  @override
  void initState() {
    super.initState();
    // Örnek kullanıcı bilgisi (normalde giriş yapmış kullanıcının bilgileri alınır)
    _user = widget.user ??
        UserModel(
          id: '1',
          name: 'Admin',
          email: 'admin@donusturkiye.com',
          profileImageUrl: 'https://picsum.photos/200',
          walletBalance: 125.50,
          totalRecycledItems: 72,
          totalEarnings: 184.00,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Kullanıcı bilgileri özeti
            _buildProfileHeader(),

            // İstatistikler
            _buildUserStats(),

            // Ana sayfalar menüsü
            _buildMenu(),
          ],
        ),
      ),
    );
  }

  // Profil başlığı - kullanıcı bilgileri
  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(_user.profileImageUrl),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _user.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _user.email,
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Cüzdan: ₺${_user.walletBalance.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Colors.green[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Kullanıcı istatistikleri
  Widget _buildUserStats() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            icon: Icons.recycling,
            label: 'Toplam Atık',
            value: _user.totalRecycledItems.toString(),
          ),
          Container(
            height: 40,
            width: 1,
            color: Colors.grey[300],
          ),
          _buildStatItem(
            icon: Icons.savings,
            label: 'Toplam Kazanç',
            value: '₺${_user.totalEarnings.toStringAsFixed(2)}',
          ),
        ],
      ),
    );
  }

  // Tekil istatistik öğesi
  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.green[600],
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  // Ana menü öğeleri
  Widget _buildMenu() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildMenuItem(
            icon: Icons.person,
            title: 'Kişisel Bilgiler',
            subtitle: 'Hesap, adresler, cüzdan',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PersonalInfoPage(user: _user),
                ),
              );
            },
          ),
          const Divider(height: 1),
          _buildMenuItem(
            icon: Icons.settings,
            title: 'Ayarlar',
            subtitle: 'Tema, dil, bildirimler',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsPage(user: _user),
                ),
              );
            },
          ),
          const Divider(height: 1),
          _buildMenuItem(
            icon: Icons.support_agent,
            title: 'Destek',
            subtitle: 'Yardım merkezi, yasal bilgiler',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SupportPage(user: _user),
                ),
              );
            },
          ),
          const Divider(height: 1),
          _buildMenuItem(
            icon: Icons.logout,
            title: 'Çıkış Yap',
            subtitle: 'Hesabınızdan güvenli çıkış yapın',
            onTap: () {
              _showLogoutDialog();
            },
          ),
        ],
      ),
    );
  }

  // Tekil menü öğesi
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.green[50],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: Colors.green[600],
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  // Çıkış yapma diyaloğu
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Çıkış Yap'),
        content:
            const Text('Hesabınızdan çıkış yapmak istediğinize emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('İPTAL'),
          ),
          ElevatedButton(
            onPressed: () {
              _performLogout(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('ÇIKIŞ YAP'),
          ),
        ],
      ),
    );
  }
  
  // Çıkış yap işlemini gerçekleştir
  void _performLogout(BuildContext context) {
    // Önce diyaloğu kapat
    Navigator.pop(context);
    
    // Başarılı çıkış mesajı göster
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Başarıyla çıkış yapıldı'),
      ),
    );
    
    // Tüm sayfaları temizleyip Login sayfasına yönlendir
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (Route<dynamic> route) => false, // Bu koşul tüm route'ları temizler
    );
  }
}