// lib/pages/profile/wallet_settings_page.dart

import 'package:flutter/material.dart';
import '../../models/user_model.dart';

class WalletSettingsPage extends StatefulWidget {
  final UserModel user;

  const WalletSettingsPage({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<WalletSettingsPage> createState() => _WalletSettingsPageState();
}

class _WalletSettingsPageState extends State<WalletSettingsPage> {
  // Otomatik para çekme için varsayılan değerler
  bool _isAutoWithdrawEnabled = false;
  double _autoWithdrawThreshold = 50.0;
  String? _selectedBankAccountId;
  
  // Bildirim ayarları
  bool _notifyOnWithdrawal = true;
  bool _notifyOnDeposit = true;
  bool _notifyOnLowBalance = true;
  double _lowBalanceThreshold = 10.0;
  
  // Gizlilik ayarları
  bool _hideWalletBalance = false;
  int _transactionHistoryDuration = 30; // Gün cinsinden
  
  // Banka hesapları (wallet_page'den alınan örnek veri)
  final List<Map<String, dynamic>> _bankAccounts = [
    {
      'id': '1',
      'bank_name': 'Ziraat Bankası',
      'account_name': 'Admin',
      'iban': 'TR54 0001 0012 3456 7890 1234 56',
      'isDefault': true,
      'icon': 'assets/images/banks/ziraat.png',
    },
    {
      'id': '2',
      'bank_name': 'İş Bankası',
      'account_name': 'Admin',
      'iban': 'TR33 0006 4000 0012 3456 7890 00',
      'isDefault': false,
      'icon': 'assets/images/banks/is_bank.png',
    },
  ];

  @override
  void initState() {
    super.initState();
    // Varsayılan hesabı otomatik para çekme için seç
    for (var account in _bankAccounts) {
      if (account['isDefault']) {
        _selectedBankAccountId = account['id'];
        break;
      }
    }
  }
  
  // Varsayılan banka hesabını döndüren yardımcı fonksiyon
  Map<String, dynamic>? _getSelectedBankAccount() {
    if (_selectedBankAccountId == null) return null;
    
    for (var account in _bankAccounts) {
      if (account['id'] == _selectedBankAccountId) {
        return account;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cüzdan Ayarları'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Otomatik Para Çekme Ayarları
            _buildSectionTitle('Otomatik Para Çekme Ayarları', Icons.autorenew),
            _buildAutoWithdrawSettings(),
            
            const SizedBox(height: 24),
            
            // Bildirim Tercihleri
            _buildSectionTitle('Bildirim Tercihleri', Icons.notifications_outlined),
            _buildNotificationSettings(),
            
            const SizedBox(height: 24),
            
            // Gizlilik Ayarları
            _buildSectionTitle('Gizlilik Ayarları', Icons.privacy_tip_outlined),
            _buildPrivacySettings(),
            
            const SizedBox(height: 32),
            
            // Kaydet butonu
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveSettings,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'AYARLARI KAYDET',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // Ayarları kaydetme fonksiyonu
  void _saveSettings() {
    // Burada ayarları kaydetme işlemi yapılacak
    // Gerçek uygulamada bu bilgiler bir veritabanına veya yerel depolamaya kaydedilir
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Ayarlar kaydedildi'),
        backgroundColor: Colors.green,
      ),
    );
  }

  // Bölüm başlığı widget'ı
  Widget _buildSectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.green,
            size: 24,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
  
  // Otomatik para çekme ayarları widget'ı
  Widget _buildAutoWithdrawSettings() {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Otomatik para çekme özelliğini aç/kapat
            SwitchListTile(
              title: const Text(
                'Otomatik Para Çekme',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: const Text(
                'Bakiyeniz belirli bir miktara ulaştığında otomatik olarak banka hesabınıza transfer edilir',
              ),
              value: _isAutoWithdrawEnabled,
              activeColor: Colors.green,
              contentPadding: EdgeInsets.zero,
              onChanged: (bool value) {
                setState(() {
                  _isAutoWithdrawEnabled = value;
                });
              },
            ),
            
            const Divider(),
            
            // Otomatik para çekme aktifse detayları göster
            if (_isAutoWithdrawEnabled) ...[
              const SizedBox(height: 16),
              
              // Bakiye eşiği ayarı
              const Text(
                'Otomatik para çekilecek bakiye eşiği:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Slider(
                      value: _autoWithdrawThreshold,
                      min: 20,
                      max: 200,
                      divisions: 18,
                      activeColor: Colors.green,
                      label: '₺${_autoWithdrawThreshold.toStringAsFixed(0)}',
                      onChanged: (double value) {
                        setState(() {
                          _autoWithdrawThreshold = value;
                        });
                      },
                    ),
                  ),
                  Container(
                    width: 70,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '₺${_autoWithdrawThreshold.toStringAsFixed(0)}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Hedef banka hesabı seçimi
              const Text(
                'Para çekilecek hesap:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  isDense: true,
                ),
                value: _selectedBankAccountId,
                items: _bankAccounts.map((account) {
                  return DropdownMenuItem<String>(
                    value: account['id'],
                    child: Text('${account['bank_name']} - ${account['iban'].substring(account['iban'].length - 7)}'),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    _selectedBankAccountId = value;
                  });
                },
              ),
              
              const SizedBox(height: 16),
              
              // Bilgilendirme notu
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[100]!),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.blue[700],
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Bakiyeniz ₺${_autoWithdrawThreshold.toStringAsFixed(0)} miktarını aştığında, otomatik olarak seçtiğiniz banka hesabınıza transfer edilecektir.',
                        style: TextStyle(
                          color: Colors.blue[700],
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            
            // Otomatik para çekme kapalıysa bilgi mesajı göster
            if (!_isAutoWithdrawEnabled) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.grey[600],
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Otomatik para çekme özelliğini aktifleştirerek, bakiyeniz belirli bir miktara ulaştığında otomatik olarak banka hesabınıza transfer edilmesini sağlayabilirsiniz.',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  // Bildirim ayarları widget'ı
  Widget _buildNotificationSettings() {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Para çekme bildirimleri
            SwitchListTile(
              title: const Text(
                'Para Çekme Bildirimleri',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: const Text(
                'Para çekme işlemleri için bildirim al',
              ),
              value: _notifyOnWithdrawal,
              activeColor: Colors.green,
              contentPadding: EdgeInsets.zero,
              onChanged: (bool value) {
                setState(() {
                  _notifyOnWithdrawal = value;
                });
              },
            ),
            
            const Divider(),
            
            // Para yatırma bildirimleri
            SwitchListTile(
              title: const Text(
                'Para Girişi Bildirimleri',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: const Text(
                'Atık satışı ve diğer para girişleri için bildirim al',
              ),
              value: _notifyOnDeposit,
              activeColor: Colors.green,
              contentPadding: EdgeInsets.zero,
              onChanged: (bool value) {
                setState(() {
                  _notifyOnDeposit = value;
                });
              },
            ),
            
            const Divider(),
            
            // Düşük bakiye bildirimleri
            SwitchListTile(
              title: const Text(
                'Düşük Bakiye Uyarıları',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: const Text(
                'Bakiyeniz belirli bir miktarın altına düştüğünde bildirim al',
              ),
              value: _notifyOnLowBalance,
              activeColor: Colors.green,
              contentPadding: EdgeInsets.zero,
              onChanged: (bool value) {
                setState(() {
                  _notifyOnLowBalance = value;
                });
              },
            ),
            
            // Düşük bakiye eşiği
            if (_notifyOnLowBalance) ...[
              const SizedBox(height: 16),
              const Text(
                'Düşük bakiye eşiği:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Slider(
                      value: _lowBalanceThreshold,
                      min: 5,
                      max: 50,
                      divisions: 9,
                      activeColor: Colors.green,
                      label: '₺${_lowBalanceThreshold.toStringAsFixed(0)}',
                      onChanged: (double value) {
                        setState(() {
                          _lowBalanceThreshold = value;
                        });
                      },
                    ),
                  ),
                  Container(
                    width: 70,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '₺${_lowBalanceThreshold.toStringAsFixed(0)}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange[100]!),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_amber_outlined,
                      color: Colors.orange[700],
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Bakiyeniz ₺${_lowBalanceThreshold.toStringAsFixed(0)} altına düştüğünde bir bildirim alacaksınız.',
                        style: TextStyle(
                          color: Colors.orange[700],
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  // Gizlilik ayarları widget'ı
  Widget _buildPrivacySettings() {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bakiye gizleme ayarı
            SwitchListTile(
              title: const Text(
                'Bakiyeyi Gizle',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: const Text(
                'Ana ekranda bakiyeniz yerine yıldız (*) gösterilir',
              ),
              value: _hideWalletBalance,
              activeColor: Colors.green,
              contentPadding: EdgeInsets.zero,
              onChanged: (bool value) {
                setState(() {
                  _hideWalletBalance = value;
                });
              },
            ),
            
            const Divider(),
            
            // İşlem geçmişi saklama süresi
            const Text(
              'İşlem geçmişi saklama süresi:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            
            // İşlem geçmişi seçenekleri
            RadioListTile<int>(
              title: const Text('Son 7 gün'),
              value: 7,
              groupValue: _transactionHistoryDuration,
              activeColor: Colors.green,
              contentPadding: EdgeInsets.zero,
              onChanged: (int? value) {
                setState(() {
                  _transactionHistoryDuration = value!;
                });
              },
            ),
            
            RadioListTile<int>(
              title: const Text('Son 30 gün'),
              value: 30,
              groupValue: _transactionHistoryDuration,
              activeColor: Colors.green,
              contentPadding: EdgeInsets.zero,
              onChanged: (int? value) {
                setState(() {
                  _transactionHistoryDuration = value!;
                });
              },
            ),
            
            RadioListTile<int>(
              title: const Text('Son 90 gün'),
              value: 90,
              groupValue: _transactionHistoryDuration,
              activeColor: Colors.green,
              contentPadding: EdgeInsets.zero,
              onChanged: (int? value) {
                setState(() {
                  _transactionHistoryDuration = value!;
                });
              },
            ),
            
            RadioListTile<int>(
              title: const Text('Tüm işlemleri sakla'),
              value: 365,
              groupValue: _transactionHistoryDuration,
              activeColor: Colors.green,
              contentPadding: EdgeInsets.zero,
              onChanged: (int? value) {
                setState(() {
                  _transactionHistoryDuration = value!;
                });
              },
            ),
            
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.purple[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.purple[100]!),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.privacy_tip_outlined,
                    color: Colors.purple[700],
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Seçtiğiniz süreden daha eski işlem geçmişi verileri cihazınızdan silinecektir. Daha eski işlemler için müşteri hizmetleriyle iletişime geçebilirsiniz.',
                      style: TextStyle(
                        color: Colors.purple[700],
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}