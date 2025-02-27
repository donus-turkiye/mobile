// lib/pages/login/register_step3.dart

import 'package:flutter/material.dart';
import 'register_main.dart';

class RegisterStep3 extends StatefulWidget {
  final RegisterData registerData;
  final VoidCallback onComplete;

  const RegisterStep3({
    Key? key,
    required this.registerData,
    required this.onComplete,
  }) : super(key: key);

  @override
  _RegisterStep3State createState() => _RegisterStep3State();
}

class _RegisterStep3State extends State<RegisterStep3> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _verificationCodeController;

  @override
  void initState() {
    super.initState();
    // Initialize controller with existing data
    _verificationCodeController =
        TextEditingController(text: widget.registerData.verificationCode);
  }

  @override
  void dispose() {
    _verificationCodeController.dispose();
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
              const Text(
                'Doğrulama',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Adım 3: Hesap Doğrulama',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 32),

              // Email verification section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.email_outlined,
                      size: 48,
                      color: Color(0xFF2E7D32),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'E-posta Doğrulama',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${widget.registerData.email} adresine doğrulama kodu gönderdik.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Email verification code input
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        6,
                        (index) => Container(
                          width: 40,
                          height: 50,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              index < _verificationCodeController.text.length
                                  ? _verificationCodeController.text[index]
                                  : '',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Hidden input field for verification code
                    TextFormField(
                      controller: _verificationCodeController,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      decoration: const InputDecoration(
                        counterText: '',
                        border: InputBorder.none,
                        hintText: '',
                      ),
                      style: const TextStyle(
                        color: Colors.transparent,
                      ),
                      onChanged: (value) {
                        // Force rebuild to update displayed digits
                        setState(() {});
                      },
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length < 6) {
                          return 'Lütfen 6 haneli doğrulama kodunu girin';
                        }
                        return null;
                      },
                    ),
                    TextButton(
                      onPressed: () {
                        // TODO: Implement resend code functionality
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Doğrulama kodu tekrar gönderildi',
                                textAlign: TextAlign.center),
                            backgroundColor: Colors.green,
                            behavior: SnackBarBehavior.floating,
                            margin: EdgeInsets.all(20),
                          ),
                        );
                      },
                      child: const Text(
                        'Kodu Tekrar Gönder',
                        style: TextStyle(
                          color: Color(0xFF2E7D32),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Phone verification section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.phone_android,
                      size: 48,
                      color: Color(0xFF2E7D32),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Telefon Doğrulama',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${widget.registerData.phone} numarasına SMS ile doğrulama kodu gönderdik.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Implement phone verification
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'SMS kodunu doğrulama işlemi başlatıldı',
                                textAlign: TextAlign.center),
                            backgroundColor: Colors.green,
                            behavior: SnackBarBehavior.floating,
                            margin: EdgeInsets.all(20),
                          ),
                        );
                      },
                      icon: const Icon(Icons.message, size: 18),
                      label: const Text('SMS Kodunu Doğrula'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8BC399),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Complete registration button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Save the verification code
                      widget.registerData.verificationCode =
                          _verificationCodeController.text;

                      // Call the onComplete callback to finalize registration
                      widget.onComplete();
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
      ),
    );
  }
}
