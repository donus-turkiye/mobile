// lib/pages/login_page.dart

import 'package:flutter/material.dart';
import 'main_navigation.dart';
import 'login/register_main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isEmailLogin = true; // To toggle between email and phone login
  
  // TextField için FocusNode ekleyelim
  final _loginFieldFocusNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _loginFieldFocusNode.dispose(); // FocusNode'u dispose edelim
    super.dispose();
  }

  // Email/Telefon seçimi değiştiğinde klavyeyi güncellemek için yardımcı fonksiyon
  void _updateKeyboardType() {
    // Eğer alan zaten odaklanmış durumdaysa, odağı kaldırıp tekrar oluşturarak
    // klavye tipinin güncellenmesini sağlıyoruz
    if (_loginFieldFocusNode.hasFocus) {
      _loginFieldFocusNode.unfocus();
      Future.delayed(const Duration(milliseconds: 100), () {
        FocusScope.of(context).requestFocus(_loginFieldFocusNode);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.green.shade300,
              Colors.green.shade700,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo
                    const Icon(
                      Icons.recycling,
                      size: 100,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'DönüşTürkiye',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Toggle between email and phone login
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                if (!_isEmailLogin) {
                                  setState(() {
                                    _isEmailLogin = true;
                                  });
                                  _updateKeyboardType(); // Klavye tipini güncelle
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: _isEmailLogin
                                      ? Colors.white
                                      : Colors.transparent,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(11),
                                    bottomLeft: Radius.circular(11),
                                  ),
                                ),
                                child: Text(
                                  'E-posta',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: _isEmailLogin
                                        ? Colors.green
                                        : Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                if (_isEmailLogin) {
                                  setState(() {
                                    _isEmailLogin = false;
                                  });
                                  _updateKeyboardType(); // Klavye tipini güncelle
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: !_isEmailLogin
                                      ? Colors.white
                                      : Colors.transparent,
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(11),
                                    bottomRight: Radius.circular(11),
                                  ),
                                ),
                                child: Text(
                                  'Telefon',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: !_isEmailLogin
                                        ? Colors.green
                                        : Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Email or Phone input field
                    TextFormField(
                      controller: _emailController,
                      focusNode: _loginFieldFocusNode, // FocusNode'u kullan
                      keyboardType: _isEmailLogin
                          ? TextInputType.emailAddress
                          : TextInputType.phone,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: _isEmailLogin ? 'E-posta' : 'Telefon Numarası',
                        prefixIcon: Icon(_isEmailLogin ? Icons.email : Icons.phone),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return _isEmailLogin
                              ? 'Lütfen e-posta adresinizi girin'
                              : 'Lütfen telefon numaranızı girin';
                        }
                        if (_isEmailLogin && !value.contains('@')) {
                          return 'Geçerli bir e-posta adresi girin';
                        }
                        return null;
                      },
                      onTap: () {
                        // Kullanıcı alana tıkladığında, doğru klavye tipinin gösterildiğinden emin olalım
                        if (_isEmailLogin && MediaQuery.of(context).viewInsets.bottom == 0) {
                          _loginFieldFocusNode.unfocus();
                          Future.delayed(const Duration(milliseconds: 100), () {
                            FocusScope.of(context).requestFocus(_loginFieldFocusNode);
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),

                    // Password TextField
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Şifre',
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
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
                          return 'Lütfen şifrenizi girin';
                        }
                        if (value.length < 6) {
                          return 'Şifre en az 6 karakter olmalıdır';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Forgot Password Link
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // TODO: Navigate to forgot password page
                        },
                        child: const Text(
                          'Şifremi Unuttum',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Login Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // Statik admin hesabı kontrolü
                            const String adminUsername = 'admin';
                            const String adminPassword = '123456';
                            
                            if (_emailController.text == adminUsername &&
                                _passwordController.text == adminPassword) {
                              // Ana sayfaya yönlendirme
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const MainNavigation()),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Giriş Başarılı!',
                                      textAlign: TextAlign.center),
                                  backgroundColor: Colors.green,
                                  behavior: SnackBarBehavior.floating,
                                  margin: EdgeInsets.all(20),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Giriş bilgileri hatalı! (ipucu: admin/123456)',
                                      textAlign: TextAlign.center),
                                  backgroundColor: Colors.red,
                                  behavior: SnackBarBehavior.floating,
                                  margin: EdgeInsets.all(20),
                                ),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'GİRİŞ YAP',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // OR divider
                    Row(
                      children: const [
                        Expanded(
                          child: Divider(
                            color: Colors.white54,
                            thickness: 1,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'veya',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: Colors.white54,
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Google Sign In Button - Güncellenmiş tasarım ve logo
                    ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Implement Google Sign In
                      },
                      icon: Container(
                        height: 24,
                        width: 24,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                              'https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_24dp.png',
                            ),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      label: const Text(
                        'Google ile Giriş Yap',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Register Link - Yeni basitleştirilmiş tasarım
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterMain(),
                            ),
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
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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