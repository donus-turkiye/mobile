import 'package:flutter/material.dart';
import '../../services/register.dart';
import 'register_main.dart';
import '../login_page.dart';

class RegisterStep3 extends StatefulWidget {
  final RegisterData registerData;
  final VoidCallback onComplete;

  const RegisterStep3({
    Key? key,
    required this.registerData,
    required this.onComplete,
  }) : super(key: key);

  @override
  State<RegisterStep3> createState() => _RegisterStep3State();
}

class _RegisterStep3State extends State<RegisterStep3> {
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Icon(Icons.verified_user, size: 80, color: Colors.white),
            const SizedBox(height: 24),
            const Text(
              'Kaydı Tamamla',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 16),
            const Text(
              'Bilgilerinizi kontrol ettik. Kayıt işlemini tamamlamak için aşağıdaki butona basın.',
              style: TextStyle(fontSize: 16, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Bilgi özeti
            _buildSummaryTile("Ad Soyad", "${widget.registerData.name} ${widget.registerData.surname}"),
            _buildSummaryTile("Telefon", widget.registerData.phone),
            _buildSummaryTile("E-posta", widget.registerData.email),
            _buildSummaryTile("Adres", widget.registerData.address),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitRegistration,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                  'KAYDI TAMAMLA',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryTile(String title, String value) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.check_circle_outline, color: Colors.white),
          title: Text(title, style: const TextStyle(color: Colors.white70)),
          subtitle: Text(value, style: const TextStyle(color: Colors.white)),
        ),
        const Divider(color: Colors.white30),
      ],
    );
  }

  Future<void> _submitRegistration() async {
    setState(() => _isSubmitting = true);

    final success = await RegisterService.registerUser(
      fullName: "${widget.registerData.name} ${widget.registerData.surname}",
      email: widget.registerData.email,
      password: widget.registerData.password,
      roleId: 1,
      telNumber: widget.registerData.phone,
      address: widget.registerData.address,
      coordinate: "coordinate", // ileride GPS'ten alınabilir
    );

    setState(() => _isSubmitting = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Kayıt başarılı! Giriş ekranına yönlendiriliyorsunuz.", textAlign: TextAlign.center),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
            (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Kayıt başarısız. Lütfen tekrar deneyin.", textAlign: TextAlign.center),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
