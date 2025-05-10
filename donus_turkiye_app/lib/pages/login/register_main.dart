import 'package:flutter/material.dart';
import '../../services/register.dart'; // Yeni register service'i dahil ettik
import 'register_step1.dart';
import 'register_step2.dart';
import 'register_step3.dart';

class RegisterData {
  String email = '';
  String password = '';
  String name = '';
  String surname = '';
  String phone = '';
  String address = '';
  String verificationCode = '';
  bool acceptTerms = false;
}

class RegisterMain extends StatefulWidget {
  const RegisterMain({Key? key}) : super(key: key);

  @override
  _RegisterMainState createState() => _RegisterMainState();
}

class _RegisterMainState extends State<RegisterMain> {
  final RegisterData _registerData = RegisterData();
  int _currentStep = 0;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_navigatorKey.currentState?.canPop() ?? false) {
          _navigatorKey.currentState?.pop();
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green.shade800,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              if (_navigatorKey.currentState?.canPop() ?? false) {
                _navigatorKey.currentState?.pop();
              } else {
                Navigator.of(context).pop();
              }
            },
          ),
          title: Text(_getAppBarTitle()),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.green.shade300, Colors.green.shade700],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                _buildProgressBar(),
                Expanded(
                  child: Navigator(
                    key: _navigatorKey,
                    initialRoute: 'step1',
                    onGenerateRoute: (RouteSettings settings) {
                      WidgetBuilder builder;
                      switch (settings.name) {
                        case 'step1':
                          builder = (context) => RegisterStep1(
                            registerData: _registerData,
                            onNext: () {
                              setState(() => _currentStep = 1);
                              _navigatorKey.currentState?.pushNamed('step2');
                            },
                          );
                          break;
                        case 'step2':
                          builder = (context) => RegisterStep2(
                            registerData: _registerData,
                            onNext: () {
                              setState(() => _currentStep = 2);
                              _navigatorKey.currentState?.pushNamed('step3');
                            },
                          );
                          break;
                        case 'step3':
                          builder = (context) => RegisterStep3(
                            registerData: _registerData,
                            onComplete: () {
                              _completeRegistration();
                            },
                          );
                          break;
                        default:
                          throw Exception('Invalid route: ${settings.name}');
                      }
                      return MaterialPageRoute(builder: builder, settings: settings);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getAppBarTitle() {
    switch (_currentStep) {
      case 0:
        return 'Hesap Oluştur';
      case 1:
        return 'Kişisel Bilgiler';
      case 2:
        return 'Doğrulama';
      default:
        return 'Kayıt Ol';
    }
  }

  Widget _buildProgressBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        children: List.generate(3, (index) {
          bool isActive = index <= _currentStep;
          bool isCurrent = index == _currentStep;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                if (index < _currentStep) {
                  setState(() => _currentStep = index);
                  if (index == 0) {
                    _navigatorKey.currentState?.pushNamedAndRemoveUntil('step1', (r) => false);
                  } else if (index == 1) {
                    _navigatorKey.currentState?.pushNamedAndRemoveUntil('step2', (r) => false);
                  }
                }
              },
              child: Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isActive ? const Color(0xFF8BC399) : Colors.grey[300],
                      border: isCurrent ? Border.all(color: Colors.white, width: 2) : null,
                    ),
                    child: Center(
                      child: Icon(
                        _getStepIcon(index),
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                  if (index < 2)
                    Expanded(
                      child: Container(
                        height: 2,
                        color: isActive && index < _currentStep
                            ? const Color(0xFF8BC399)
                            : Colors.grey[300],
                      ),
                    ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  IconData _getStepIcon(int step) {
    switch (step) {
      case 0:
        return Icons.account_circle;
      case 1:
        return Icons.person;
      case 2:
        return Icons.verified_user;
      default:
        return Icons.circle;
    }
  }

  void _completeRegistration() async {
    final fullName = "${_registerData.name} ${_registerData.surname}";
    final isSuccess = await RegisterService.registerUser(
      fullName: fullName,
      email: _registerData.email,
      password: _registerData.password,
      roleId: 1, // sabit atanmış (örnek olarak)
      telNumber: _registerData.phone,
      address: _registerData.address,
      coordinate: "coordinate", // sabit veya haritadan alınacaksa dinamik yapılabilir
    );

    if (isSuccess) {
      Navigator.of(context).pop(); // Login sayfasına dön
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kayıt başarılı! Giriş yapabilirsiniz.'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kayıt başarısız. Lütfen tekrar deneyin.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
