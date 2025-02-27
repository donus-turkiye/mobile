// lib/pages/profile/personal_info_page.dart

import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import 'account_page.dart';
import 'addresses_page.dart';
import 'wallet_settings_page.dart'; // veya doğru import yolu

class PersonalInfoPage extends StatelessWidget {
  final UserModel user;

  const PersonalInfoPage({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kişisel Bilgiler'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),

          // Hesap bilgileri
          _buildInfoItem(
            context,
            icon: Icons.person_outline,
            title: 'Hesap',
            subtitle: 'Profil bilgilerini güncelle',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AccountPage(user: user),
                ),
              );
            },
          ),

          // Adresler
          _buildInfoItem(
            context,
            icon: Icons.location_on_outlined,
            title: 'Adreslerim',
            subtitle: 'Kayıtlı adreslerini yönet',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddressesPage(user: user),
                ),
              );
            },
          ),

          // Cüzdan
          _buildInfoItem(
            context,
            icon: Icons.account_balance_wallet_outlined,
            title: 'Cüzdan',
            subtitle: 'Banka hesapları ve ödeme yöntemleri',
            onTap: () {
            Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => WalletSettingsPage(user: user), // doğrudan user değişkenini kullanın
  ),
);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
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
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.green[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: Colors.green[600],
            size: 28,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            subtitle,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Colors.grey[400],
          size: 16,
        ),
        onTap: onTap,
      ),
    );
  }
}
