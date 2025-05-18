// lib/pages/main_page.dart

import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/waste_models.dart';
import '../pages/collect_waste_page.dart';

class MainPage extends StatelessWidget {
  final UserModel user;

  const MainPage({super.key, required this.user});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return 'Günaydın!';
    } else if (hour >= 12 && hour < 18) {
      return 'İyi öğleden sonralar!';
    } else if (hour >= 18 && hour < 22) {
      return 'İyi akşamlar!';
    } else {
      return 'İyi geceler!';
    }
  }

  @override
  Widget build(BuildContext context) {
    final greeting = _getGreeting();

    return Scaffold(
      backgroundColor: const Color(0xFFFDF7FD),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Selamlama ve bildirim
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.purpleAccent,
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              greeting,
                              style: const TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                            const Text(
                              'Geri Dönüşüme Bugün Başla!',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.notifications_none_outlined),
                      onPressed: () {},
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Kart: Toplam değer
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Tüm Kategoriler',
                            style: TextStyle(fontSize: 14, color: Colors.green, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '₺184.00',
                            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                          ),
                          Text('Toplanan atık değeri', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text('72 parça', style: TextStyle(color: Colors.green)),
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Atık Kategorileri
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Atık Kategorileri',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Tümünü Gör',
                      style: TextStyle(color: Colors.green),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    _CategoryIcon(label: 'Kağıt Atıklar', icon: Icons.description),
                    _CategoryIcon(label: 'Plastik Atıklar', icon: Icons.shopping_bag),
                    _CategoryIcon(label: 'Cam Atıklar', icon: Icons.wine_bar),
                    _CategoryIcon(label: 'Metal Atıklar', icon: Icons.blur_circular),
                  ],
                ),

                const SizedBox(height: 32),

                // Geri Dönüşüm Noktaları
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Yakındaki Geri Dönüşüm Noktaları',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Tümünü Gör',
                      style: TextStyle(color: Colors.green),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const _BinStationCard(
                  name: 'Merkez Atık Toplama',
                  address: 'Aziziye Mahallesi, Düzce',
                  distance: '2.3 km',
                ),
                const _BinStationCard(
                  name: 'Cedidiye Toplama Merkezi',
                  address: 'Cedidiye Mahallesi, Düzce',
                  distance: '3.1 km',
                ),
                const _BinStationCard(
                  name: 'Camikebir Atık Noktası',
                  address: 'Camikebir Mahallesi, Düzce',
                  distance: '4.2 km',
                ),

                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryIcon extends StatelessWidget {
  final String label;
  final IconData icon;

  const _CategoryIcon({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.green.shade200),
          ),
          child: Icon(icon, color: Colors.grey[700]),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        )
      ],
    );
  }
}

class _BinStationCard extends StatelessWidget {
  final String name;
  final String address;
  final String distance;

  const _BinStationCard({required this.name, required this.address, required this.distance});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.place, color: Colors.green),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(address, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 4),
                Text(distance, style: const TextStyle(color: Colors.green, fontSize: 12)),
              ],
            ),
          ),
          const Icon(Icons.more_vert, color: Colors.grey),
        ],
      ),
    );
  }
}
