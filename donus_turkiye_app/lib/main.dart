// lib/main.dart

import 'package:flutter/material.dart';
import 'pages/login_page.dart'; // Doğru import yolu kontrol edildi
// Alternatif import yolları:
// import './pages/login_page.dart';
// veya mevcut yapınıza göre: 
// import 'lib/pages/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DönüşTürkiye',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      home: const LoginPage(), // LoginPage sınıfı burada kullanılıyor
    );
  }
}