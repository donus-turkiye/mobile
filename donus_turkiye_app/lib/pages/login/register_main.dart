// lib/pages/login/register_main.dart

import 'package:flutter/material.dart';
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

  // Global key for navigator
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Handle back button press
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
              colors: [
                Colors.green.shade300,
                Colors.green.shade700,
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // Progress bar
                _buildProgressBar(),

                // Main content
                Expanded(
                  child: Navigator(
                    key: _navigatorKey,
                    initialRoute: 'step1',
                    onGenerateRoute: (RouteSettings settings) {
                      WidgetBuilder builder;

                      switch (settings.name) {
                        case 'step1':
                          builder = (BuildContext context) => RegisterStep1(
                                registerData: _registerData,
                                onNext: () {
                                  setState(() {
                                    _currentStep = 1;
                                  });
                                  _navigatorKey.currentState
                                      ?.pushNamed('step2');
                                },
                              );
                          break;
                        case 'step2':
                          builder = (BuildContext context) => RegisterStep2(
                                registerData: _registerData,
                                onNext: () {
                                  setState(() {
                                    _currentStep = 2;
                                  });
                                  _navigatorKey.currentState
                                      ?.pushNamed('step3');
                                },
                              );
                          break;
                        case 'step3':
                          builder = (BuildContext context) => RegisterStep3(
                                registerData: _registerData,
                                onComplete: () {
                                  _completeRegistration();
                                },
                              );
                          break;
                        default:
                          throw Exception('Invalid route: ${settings.name}');
                      }

                      return MaterialPageRoute(
                        builder: builder,
                        settings: settings,
                      );
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

  // Get app bar title based on current step
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

  // Build progress bar
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
                // Sadece önceki adımlara geri dönebilmesine izin ver
                if (index < _currentStep) {
                  setState(() {
                    _currentStep = index;
                  });

                  // Navigate to the appropriate step
                  if (index == 0) {
                    _navigatorKey.currentState
                        ?.pushNamedAndRemoveUntil('step1', (route) => false);
                  } else if (index == 1) {
                    _navigatorKey.currentState
                        ?.pushNamedAndRemoveUntil('step2', (route) => false);
                  }
                }
              },
              child: Row(
                children: [
                  // Step circle
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          isActive ? const Color(0xFF8BC399) : Colors.grey[300],
                      border: isCurrent
                          ? Border.all(color: Colors.white, width: 2)
                          : null,
                    ),
                    child: Center(
                      child: Icon(
                        _getStepIcon(index),
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),

                  // Progress line
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

  // Get icon for step
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

  // Complete registration
  void _completeRegistration() {
    // Print the collected info
    print('Registration completed');
    print('Email: ${_registerData.email}');
    print('Name: ${_registerData.name} ${_registerData.surname}');
    print('Phone: ${_registerData.phone}');
    print('Address: ${_registerData.address}');

    // Navigate back to login
    Navigator.of(context).pop();
  }
}
