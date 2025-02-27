// lib/pages/profile/settings_page.dart

import 'package:flutter/material.dart';
import '../../models/user_model.dart';

class SettingsPage extends StatefulWidget {
  final UserModel user;

  const SettingsPage({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // Tema ayarları
  bool _isDarkTheme = false;

  // Dil ayarları
  String _selectedLanguage = 'Türkçe';
  final List<String> _availableLanguages = ['Türkçe', 'English', 'Deutsch'];

  // Bildirim ayarları
  bool _generalNotifications = true;
  bool _orderNotifications = true;
  bool _paymentNotifications = true;
  bool _instantNotifications = true;

  // Bildirim kanalları
  bool _pushNotifications = true;
  bool _smsNotifications = false;
  bool _emailNotifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayarlar'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Tema Ayarları
          _buildSectionTitle('Tema'),
          _buildThemeSettings(),

          const SizedBox(height: 24),

          // Dil Ayarları
          _buildSectionTitle('Dil'),
          _buildLanguageSettings(),

          const SizedBox(height: 24),

          // Bildirim Ayarları
          _buildSectionTitle('Bildirim Ayarları'),
          _buildNotificationSettings(),

          const SizedBox(height: 24),

          // Bildirim Kanalları
          _buildSectionTitle('Bildirim Kanalları'),
          _buildNotificationChannels(),

          const SizedBox(height: 24),

          // Gizlilik ve Güvenlik
          _buildSectionTitle('Gizlilik ve Güvenlik'),
          _buildPrivacySettings(),

          const SizedBox(height: 24),

          // Sürüm Bilgisi
          _buildVersionInfo(),
        ],
      ),
    );
  }

  // Bölüm başlığı
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Tema ayarları
  Widget _buildThemeSettings() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SwitchListTile(
        title: const Text(
          'Karanlık Tema',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: const Text('Uygulamanın renklerini karanlık moda geçir'),
        value: _isDarkTheme,
        onChanged: (value) {
          setState(() {
            _isDarkTheme = value;
          });
          // Tema değiştirme işlemi burada yapılacak
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text(value ? 'Karanlık tema aktif' : 'Aydınlık tema aktif'),
            ),
          );
        },
        secondary: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.green[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _isDarkTheme ? Icons.dark_mode : Icons.light_mode,
            color: Colors.green[600],
          ),
        ),
        activeColor: Colors.green,
      ),
    );
  }

  // Dil ayarları
  Widget _buildLanguageSettings() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.language,
                    color: Colors.green[600],
                  ),
                ),
                const SizedBox(width: 16),
                const Text(
                  'Uygulama Dili',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.grey[300]!,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
              value: _selectedLanguage,
              onChanged: (value) {
                setState(() {
                  _selectedLanguage = value!;
                });
                // Dil değiştirme işlemi burada yapılacak
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Dil değiştirildi: $value'),
                  ),
                );
              },
              items: _availableLanguages
                  .map((language) => DropdownMenuItem(
                        value: language,
                        child: Text(language),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  // Bildirim ayarları
  Widget _buildNotificationSettings() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          SwitchListTile(
            title: const Text(
              'Genel Bildirimler',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: const Text('Kampanyalar, duyurular ve teklifler'),
            value: _generalNotifications,
            onChanged: (value) {
              setState(() {
                _generalNotifications = value;
              });
            },
            secondary: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.campaign,
                color: Colors.green[600],
              ),
            ),
            activeColor: Colors.green,
          ),
          const Divider(height: 1),
          SwitchListTile(
            title: const Text(
              'Sipariş Bildirimleri',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: const Text('Atık toplama durumu, tamamlanan işlemler'),
            value: _orderNotifications,
            onChanged: (value) {
              setState(() {
                _orderNotifications = value;
              });
            },
            secondary: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.local_shipping,
                color: Colors.green[600],
              ),
            ),
            activeColor: Colors.green,
          ),
          const Divider(height: 1),
          SwitchListTile(
            title: const Text(
              'Ödeme Bildirimleri',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle:
                const Text('Cüzdan hareketleri, ödeme alındı bildirimleri'),
            value: _paymentNotifications,
            onChanged: (value) {
              setState(() {
                _paymentNotifications = value;
              });
            },
            secondary: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.payment,
                color: Colors.green[600],
              ),
            ),
            activeColor: Colors.green,
          ),
          const Divider(height: 1),
          SwitchListTile(
            title: const Text(
              'Anlık Bildirimler',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: const Text('Önemli güncellemeler için push bildirimleri'),
            value: _instantNotifications,
            onChanged: (value) {
              setState(() {
                _instantNotifications = value;
              });
            },
            secondary: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.notifications_active,
                color: Colors.green[600],
              ),
            ),
            activeColor: Colors.green,
          ),
        ],
      ),
    );
  }

  // Bildirim kanalları
  Widget _buildNotificationChannels() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          SwitchListTile(
            title: const Text(
              'Push Bildirimleri',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: const Text('Uygulama bildirimleri'),
            value: _pushNotifications,
            onChanged: (value) {
              setState(() {
                _pushNotifications = value;
              });
            },
            secondary: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.notifications,
                color: Colors.green[600],
              ),
            ),
            activeColor: Colors.green,
          ),
          const Divider(height: 1),
          SwitchListTile(
            title: const Text(
              'SMS Bildirimleri',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: const Text('Kısa mesaj ile bildirimler'),
            value: _smsNotifications,
            onChanged: (value) {
              setState(() {
                _smsNotifications = value;
              });
            },
            secondary: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.sms,
                color: Colors.green[600],
              ),
            ),
            activeColor: Colors.green,
          ),
          const Divider(height: 1),
          SwitchListTile(
            title: const Text(
              'E-posta Bildirimleri',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: const Text('E-posta ile bildirimler'),
            value: _emailNotifications,
            onChanged: (value) {
              setState(() {
                _emailNotifications = value;
              });
            },
            secondary: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.email,
                color: Colors.green[600],
              ),
            ),
            activeColor: Colors.green,
          ),
        ],
      ),
    );
  }

  // Gizlilik ayarları
  Widget _buildPrivacySettings() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          ListTile(
            title: const Text(
              'Gizlilik Politikası',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: const Text('Gizlilik ve veri işleme politikamızı okuyun'),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.privacy_tip,
                color: Colors.green[600],
              ),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Gizlilik politikası sayfasına yönlendir
            },
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text(
              'Kullanım Koşulları',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: const Text('Kullanım şartları ve koşulları'),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.description,
                color: Colors.green[600],
              ),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Kullanım koşulları sayfasına yönlendir
            },
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text(
              'Konum İzinleri',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: const Text('Konum erişimi ayarlarını yönetin'),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.location_on,
                color: Colors.green[600],
              ),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Konum izinleri sayfasına yönlendir
            },
          ),
        ],
      ),
    );
  }

  // Sürüm bilgisi
  Widget _buildVersionInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/app_logo.png',
            width: 24,
            height: 24,
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                Icons.eco,
                color: Colors.green[700],
                size: 24,
              );
            },
          ),
          const SizedBox(width: 8),
          const Text(
            'DönüşTürkiye v1.0.0',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
