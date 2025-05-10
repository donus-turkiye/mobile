import 'package:flutter/material.dart';
import 'register_main.dart';

class RegisterStep2 extends StatefulWidget {
  final RegisterData registerData;
  final VoidCallback onNext;

  const RegisterStep2({
    Key? key,
    required this.registerData,
    required this.onNext,
  }) : super(key: key);

  @override
  State<RegisterStep2> createState() => _RegisterStep2State();
}

class _RegisterStep2State extends State<RegisterStep2> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _surnameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  bool _acceptTerms = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.registerData.name);
    _surnameController = TextEditingController(text: widget.registerData.surname);
    _phoneController = TextEditingController(text: widget.registerData.phone);
    _addressController = TextEditingController(text: widget.registerData.address);
    _acceptTerms = widget.registerData.acceptTerms;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
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
            children: [
              const Text(
                'Kişisel Bilgiler',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 8),
              const Text(
                'Adım 2: Kimlik ve İletişim Bilgileri',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              const SizedBox(height: 32),

              _buildTextField(_nameController, 'Ad', Icons.person, (v) => v == null || v.isEmpty ? 'Lütfen adınızı girin' : null),
              const SizedBox(height: 16),

              _buildTextField(_surnameController, 'Soyad', Icons.person_outline, (v) => v == null || v.isEmpty ? 'Lütfen soyadınızı girin' : null),
              const SizedBox(height: 16),

              _buildTextField(_phoneController, 'Telefon Numarası', Icons.phone, (v) => v == null || v.isEmpty ? 'Telefon numarası girin' : null,
                  inputType: TextInputType.phone),
              const SizedBox(height: 16),

              TextFormField(
                controller: _addressController,
                maxLines: 3,
                decoration: _inputDecoration('Adres', Icons.location_on),
                validator: (v) => v == null || v.isEmpty ? 'Adres girin' : null,
              ),
              const SizedBox(height: 24),

              Row(
                children: [
                  Checkbox(
                    value: _acceptTerms,
                    onChanged: (v) => setState(() => _acceptTerms = v ?? false),
                    activeColor: Colors.white,
                    checkColor: Colors.green[700],
                    side: const BorderSide(color: Colors.white),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _acceptTerms = !_acceptTerms),
                      child: const Text(
                        'Kullanım koşullarını ve gizlilik politikasını okudum ve kabul ediyorum.',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (_acceptTerms && _formKey.currentState?.validate() == true)
                      ? () {
                    widget.registerData.name = _nameController.text.trim();
                    widget.registerData.surname = _surnameController.text.trim();
                    widget.registerData.phone = _phoneController.text.trim();
                    widget.registerData.address = _addressController.text.trim();
                    widget.registerData.acceptTerms = _acceptTerms;

                    widget.onNext();
                  }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    disabledBackgroundColor: Colors.grey[400],
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'DEVAM ET',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField _buildTextField(
      TextEditingController controller,
      String hint,
      IconData icon,
      String? Function(String?) validator, {
        TextInputType inputType = TextInputType.text,
      }) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      decoration: _inputDecoration(hint, icon),
      validator: validator,
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      hintText: hint,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }
}
