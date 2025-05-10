import 'package:flutter/material.dart';
import '../services/login.dart';
import 'main_navigation.dart';
import 'login/register_main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _loginController = TextEditingController(); // email veya telefon
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isEmailLogin = false;

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green.shade300, Colors.green.shade700],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Icon(Icons.recycling, size: 100, color: Colors.white),
                    const SizedBox(height: 32),
                    const Text('DönüŞTürkiye',
                        style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    const SizedBox(height: 32),

                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<bool>(
                            title: const Text("Telefon ile",
                                style: TextStyle(color: Colors.white)),
                            value: false,
                            groupValue: _isEmailLogin,
                            onChanged: (value) {
                              setState(() => _isEmailLogin = value!);
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<bool>(
                            title: const Text("E-posta ile",
                                style: TextStyle(color: Colors.white)),
                            value: true,
                            groupValue: _isEmailLogin,
                            onChanged: (value) {
                              setState(() => _isEmailLogin = value!);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    TextFormField(
                      controller: _loginController,
                      keyboardType: _isEmailLogin
                          ? TextInputType.emailAddress
                          : TextInputType.phone,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: _isEmailLogin
                            ? 'E-posta adresi'
                            : 'Telefon numarası',
                        prefixIcon: Icon(
                            _isEmailLogin ? Icons.email : Icons.phone),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return _isEmailLogin
                              ? 'E-posta adresinizi girin'
                              : 'Telefon numaranızı girin';
                        }
                        if (_isEmailLogin && !value.contains('@')) {
                          return 'Geçerli bir e-posta adresi girin';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Şifre',
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(_isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Şifrenizi girin';
                        }
                        if (value.length < 6) {
                          return 'Şifre en az 6 karakter olmalı';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final login = _loginController.text.trim();
                            final password = _passwordController.text.trim();

                            final isSuccess = await ApiService.login(
                              telNumber: _isEmailLogin ? null : login,
                              email: _isEmailLogin ? login : null,
                              password: password,
                            );

                            if (isSuccess) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const MainNavigation()),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Giriş Başarılı!',
                                      textAlign: TextAlign.center),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Giriş bilgileri hatalı! Lütfen tekrar deneyin.',
                                      textAlign: TextAlign.center),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'GİRİŞ YAP',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const RegisterMain()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.green.shade700,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Hesabınız Yok Mu?',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
