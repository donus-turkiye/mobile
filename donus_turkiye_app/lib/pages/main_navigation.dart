import 'package:flutter/material.dart';
import 'main_page.dart';
import 'collect_waste_page.dart';
import 'profile_page.dart';
import 'wallet_page.dart';
import 'market_page.dart';
import '../models/user_model.dart';
import '../services/auth_storage.dart';
import '../services/user_service.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 2;
  UserModel? _currentUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userId = await AuthStorage.getUserId();
    if (userId != null) {
      final user = await UserService.getCurrentUser();
      setState(() {
        _currentUser = user;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _currentUser == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final pages = [
      MarketPage(user: _currentUser!),
      WalletPage(user: _currentUser!),
      MainPage(user: _currentUser!),
      CollectWastePage(user: _currentUser!),
      ProfilePage(user: _currentUser!),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: Container(
        height: 70,
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
            _buildNavItem(0, Icons.shopping_bag, 'Market'),
            _buildNavItem(1, Icons.account_balance_wallet, 'Cüzdan'),
            const SizedBox(width: 60),
            _buildNavItem(3, Icons.delete_outline, 'Atık Topla'),
            _buildNavItem(4, Icons.person, 'Profil'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onItemTapped(2),
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