// lib/pages/profile/account_page.dart

import 'package:flutter/material.dart';
import '../../models/user_model.dart';

class AccountPage extends StatefulWidget {
  final UserModel user;

  const AccountPage({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  bool _isPhoneVerified = false;
  bool _is2FAEnabled = false;
  bool _isEditMode = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.fullName);
    _emailController = TextEditingController(text: widget.user.email);
    _phoneController =
        TextEditingController(text: '+90 555 123 4567'); // Örnek telefon
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hesap Bilgileri'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _isEditMode = !_isEditMode;
                if (!_isEditMode) {
                  // Burada değişiklikler kaydedilecek (backend bağlantısı)
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Değişiklikler kaydedildi'),
                    ),
                  );
                }
              });
            },
            child: Text(
              _isEditMode ? 'KAYDET' : 'DÜZENLE',
              style: TextStyle(
                color: Colors.green[700],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profil Fotoğrafı
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    // backgroundImage: NetworkImage(widget.user.profileImageUrl),
                  ),
                  if (_isEditMode)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: () {
                            // Fotoğraf değiştirme işlemi
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Fotoğraf değiştirme özelliği yakında eklenecek'),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Form Alanları
            _buildSectionTitle('Kişisel Bilgiler'),
            const SizedBox(height: 16),

            // Ad Soyad
            _buildTextField(
              label: 'Ad Soyad',
              controller: _nameController,
              isEnabled: _isEditMode,
              prefixIcon: Icons.person,
            ),
            const SizedBox(height: 16),

            // E-posta
            _buildTextField(
              label: 'E-posta',
              controller: _emailController,
              isEnabled: _isEditMode,
              prefixIcon: Icons.email,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),

            // Telefon
            _buildTextField(
              label: 'Telefon',
              controller: _phoneController,
              isEnabled: _isEditMode,
              prefixIcon: Icons.phone,
              keyboardType: TextInputType.phone,
              suffix: _isPhoneVerified
                  ? Icon(Icons.verified, color: Colors.green[600], size: 20)
                  : TextButton(
                      onPressed: () {
                        _showVerifyDialog();
                      },
                      child: const Text(
                        'Doğrula',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
            ),
            const SizedBox(height: 32),

            // Güvenlik Ayarları
            _buildSectionTitle('Güvenlik'),
            const SizedBox(height: 16),

            // Şifre Değiştir
            _buildSecurityItem(
              icon: Icons.lock,
              title: 'Şifre değiştir',
              onTap: () {
                _showChangePasswordDialog();
              },
            ),
            const SizedBox(height: 16),

            // İki Faktörlü Kimlik Doğrulama
            Container(
              padding: const EdgeInsets.all(16),
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
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.security,
                      color: Colors.green[600],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'İki faktörlü kimlik doğrulama',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Hesabınızı daha güvenli hale getirin',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _is2FAEnabled,
                    onChanged: (value) {
                      setState(() {
                        _is2FAEnabled = value;
                      });
                      if (value) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'İki faktörlü kimlik doğrulama etkinleştirildi'),
                          ),
                        );
                      }
                    },
                    activeColor: Colors.green,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Hesap Silme
            Center(
              child: TextButton(
                onPressed: () {
                  _showDeleteAccountDialog();
                },
                child: const Text(
                  'Hesabı Sil',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool isEnabled = true,
    IconData? prefixIcon,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffix,
  }) {
    return TextField(
      controller: controller,
      enabled: isEnabled,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.grey[300]!,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.grey[300]!,
          ),
        ),
        prefixIcon: prefixIcon != null
            ? Icon(
                prefixIcon,
                color: Colors.grey[600],
              )
            : null,
        suffix: suffix,
      ),
    );
  }

  Widget _buildSecurityItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
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
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: Colors.green[600],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey[400],
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  // Telefon doğrulama diyaloğu
  void _showVerifyDialog() {
    final TextEditingController codeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Telefon Doğrulama'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Telefonunuza gönderilen 6 haneli kodu girin:'),
            const SizedBox(height: 16),
            TextField(
              controller: codeController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: InputDecoration(
                labelText: 'Doğrulama Kodu',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('İPTAL'),
          ),
          ElevatedButton(
            onPressed: () {
              // Kod doğrulama işlemi burada yapılacak
              setState(() {
                _isPhoneVerified = true;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Telefon numarası doğrulandı'),
                ),
              );
            },
            child: const Text('DOĞRULA'),
          ),
        ],
      ),
    );
  }

  // Şifre değiştirme diyaloğu
  void _showChangePasswordDialog() {
    final TextEditingController currentPasswordController =
        TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();
    final TextEditingController confirmPasswordController =
        TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Şifre Değiştir'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Mevcut Şifre',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Yeni Şifre',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Yeni Şifre (Tekrar)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('İPTAL'),
          ),
          ElevatedButton(
            onPressed: () {
              // Şifre değiştirme işlemi burada yapılacak
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Şifre başarıyla değiştirildi'),
                ),
              );
            },
            child: const Text('DEĞİŞTİR'),
          ),
        ],
      ),
    );
  }

  // Hesap silme diyaloğu
  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hesabı Sil'),
        content: const Text(
          'Hesabınızı silmek istediğinize emin misiniz? Bu işlem geri alınamaz.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('İPTAL'),
          ),
          ElevatedButton(
            onPressed: () {
              // Hesap silme işlemi burada yapılacak
              Navigator.pop(context);
              Navigator.pop(context); // Hesap sayfasından çık
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Hesabınız silindi'),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('SİL'),
          ),
        ],
      ),
    );
  }
}
