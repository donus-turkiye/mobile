import 'package:flutter/material.dart';
import 'register_main.dart';

class RegisterStep1 extends StatefulWidget {
  final RegisterData registerData;
  final VoidCallback onNext;

  const RegisterStep1({
    Key? key,
    required this.registerData,
    required this.onNext,
  }) : super(key: key);

  @override
  State<RegisterStep1> createState() => _RegisterStep1State();
}

class _RegisterStep1State extends State<RegisterStep1> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.registerData.email);
    _passwordController = TextEditingController(text: widget.registerData.password);
    _confirmPasswordController = TextEditingController(text: widget.registerData.password);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.recycling, size: 80, color: Colors.white),
              const SizedBox(height: 24),
              const Text(
                'Hesap Oluştur',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 8),
              const Text(
                'Adım 1: Giriş Bilgileri',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              const SizedBox(height: 32),

              // Email
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: _inputDecoration('E-posta', Icons.email),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen e-posta adresinizi girin';
                  }
                  if (!RegExp(r"^[^@]+@[^@]+\.[^@]+").hasMatch(value)) {
                    return 'Geçerli bir e-posta girin';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Password
              TextFormField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                decoration: _inputDecoration(
                  'Şifre',
                  Icons.lock,
                  trailing: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() => _isPasswordVisible = !_isPasswordVisible);
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen şifre girin';
                  }
                  if (value.length < 6) {
                    return 'Şifre en az 6 karakter olmalıdır';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Confirm Password
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: !_isConfirmPasswordVisible,
                decoration: _inputDecoration(
                  'Şifre Tekrar',
                  Icons.lock_outline,
                  trailing: IconButton(
                    icon: Icon(
                      _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible);
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen şifrenizi tekrar girin';
                  }
                  if (value != _passwordController.text) {
                    return 'Şifreler uyuşmuyor';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Continue button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      widget.registerData.email = _emailController.text.trim();
                      widget.registerData.password = _passwordController.text;
                      widget.onNext();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'DEVAM ET',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Already have account
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Zaten hesabınız var mı? Giriş Yap',
                  style: TextStyle(
                    color: Colors.white,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon, {Widget? trailing}) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      hintText: hint,
      prefixIcon: Icon(icon),
      suffixIcon: trailing,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }
}
