// lib/pages/main_navigation.dart

import 'package:flutter/material.dart';
import 'main_page.dart';
import 'collect_waste_page.dart';
import 'profile_page.dart';
import 'wallet_page.dart';
import 'market_page.dart'; // Yeni Market sayfası
import '../models/user_model.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 2;
  
  // Örnek kullanıcı - Gerçek uygulamada veritabanından gelecek
  late UserModel _currentUser;
  
  @override
  void initState() {
    super.initState();
    // Örnek kullanıcı oluştur
    _currentUser = UserModel(
      id: '1',
      name: 'Admin',
      email: 'admin@donus.com',
      profileImageUrl: 'https://picsum.photos/200',
      walletBalance: 25.75,
      totalRecycledItems: 72,
      totalEarnings: 184.00,
    );
  }

  // Sayfalarımızı burada tanımlıyoruz
  late final List<Widget> _pages = [
    MarketPage(user: _currentUser), // "Tara" sayfası yerine "Market" sayfası
    WalletPage(user: _currentUser),
    const MainPage(),
    CollectWastePage(user: _currentUser),
    ProfilePage(user: _currentUser),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        height: 70, // Yüksekliği sabit tutmak için
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(0, Icons.shopping_bag, 'Market'), // İkon ve metin değişti
            _buildNavItem(1, Icons.account_balance_wallet, 'Cüzdan'),
            const SizedBox(width: 60), // Ortadaki home butonu için boşluk
            _buildNavItem(3, Icons.delete_outline, 'Atık Topla'),
            _buildNavItem(4, Icons.person, 'Profil'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onItemTapped(2), // Ana sayfaya git
        backgroundColor: _selectedIndex == 2 
            ? const Color(0xFF2E7D32) 
            : const Color(0xFF8BC399),
        child: const Icon(Icons.home, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _selectedIndex == index;
    
    return InkWell(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? const Color(0xFF8BC399) : Colors.grey,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? const Color(0xFF8BC399) : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}