// lib/pages/waste/waste_centers_page.dart
import 'package:flutter/material.dart';
import '../../models/user_model.dart';

/// WasteCentersPage, kullanıcıların yakındaki atık toplama merkezlerini
/// görüntüleyebildiği sayfadır.
class WasteCentersPage extends StatefulWidget {
  final UserModel user;

  const WasteCentersPage({
    super.key,
    required this.user,
  });

  @override
  State<WasteCentersPage> createState() => _WasteCentersPageState();
}

class _WasteCentersPageState extends State<WasteCentersPage> {
  // Yakındaki Atık Merkezleri
  final List<Map<String, dynamic>> _recyclingCenters = [
    {
      'name': 'Merkez Atık Toplama',
      'address': 'Aziziye Mahallesi, Düzce',
      'distance': '2.3 km',
      'rating': 4.8,
    },
    {
      'name': 'Cedidiye Toplama Merkezi',
      'address': 'Cedidiye Mahallesi, Düzce',
      'distance': '3.1 km',
      'rating': 4.5,
    },
    {
      'name': 'Camikebir Atık Noktası',
      'address': 'Camikebir Mahallesi, Düzce',
      'distance': '4.2 km',
      'rating': 4.2,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Atık Merkezleri'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: _buildRecyclingCentersView(),
    );
  }

  // Atık Merkezleri Görünümü
  Widget _buildRecyclingCentersView() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Arama Çubuğu
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(Icons.search, color: Colors.grey[600]),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Atık merkezi ara',
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.grey[500]),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Yakındaki Atık Merkezleri Başlığı
          const Text(
            'En Yakın Atık Merkezleri',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          // Merkezler Listesi
          Expanded(
            child: ListView.builder(
              itemCount: _recyclingCenters.length,
              itemBuilder: (context, index) {
                final center = _recyclingCenters[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.delete_outline,
                          color: Colors.green,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              center['name'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              center['address'],
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF8BC399)
                                        .withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    center['distance'],
                                    style: const TextStyle(
                                      color: Color(0xFF2E7D32),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(Icons.star,
                                    color: Colors.amber, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  '${center['rating']}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Yol tarifi göster
                          _showDirections(center);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2E7D32),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('YOL TARİFİ'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Yol tarifi göster
  void _showDirections(Map<String, dynamic> center) {
    // Burada harita uygulamasına yönlendirme yapılabilir
    // veya uygulama içi yol tarifi ekranı gösterilebilir
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${center['name']} Yol Tarifi'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Adres: ${center['address']}'),
            Text('Mesafe: ${center['distance']}'),
            const SizedBox(height: 12),
            const Text(
                'Yol tarifi için harita uygulamasına yönlendirileceksiniz.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İPTAL'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              // Harita uygulamasına yönlendirme kodu buraya eklenebilir
            },
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
            ),
            child: const Text('YOL TARİFİ AL'),
          ),
        ],
      ),
    );
  }
}
